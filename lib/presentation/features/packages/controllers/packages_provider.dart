import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/users/logs/log_model.dart';
import 'package:fahem/data/models/packages/package_model.dart';
import 'package:fahem/data/models/users/wallet/wallet_model.dart';
import 'package:fahem/domain/usecases/base/base_usecase.dart';
import 'package:fahem/domain/usecases/users/logs/insert_log_usecase.dart';
import 'package:fahem/domain/usecases/packages/get_all_packages_usecase.dart';
import 'package:fahem/domain/usecases/users/wallet/edit_wallet_usecase.dart';
import 'package:fahem/presentation/features/logs/controllers/logs_provider.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/wallet/controllers/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PackagesProvider with ChangeNotifier {
  final GetAllPackagesUseCase _getAllPackagesUseCase;

  PackagesProvider(this._getAllPackagesUseCase);

  Future<Either<Failure, List<PackageModel>>> getAllPackagesImpl() async {
    return await _getAllPackagesUseCase.call(const NoParameters());
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  List<PackageModel> _packages = [];
  List<PackageModel> get packages => _packages;
  setPackages(List<PackageModel> packages) => _packages = packages;

  PackageModel? _selectedPackage;
  PackageModel? get selectedPackage => _selectedPackage;
  changeSelectedPackage(PackageModel? selectedPackage) {_selectedPackage = selectedPackage; notifyListeners();}

  PackageModel getPackageFromId(int packageId) {
    return _packages.firstWhere((element) => element.packageId == packageId);
  }

  void onPressedPayNow(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
    LogsProvider logsProvider = Provider.of<LogsProvider>(context, listen: false);
    UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);

    String messageEn = 'You will be subscribing to a ${selectedPackage!.nameEn} for ${selectedPackage!.price} pounds from your balance';
    String messageAr = 'سوف يتم الاشتراك فى ${selectedPackage!.nameAr} مقابل ${selectedPackage!.price} جنية من رصيدك';
    Dialogs.showBottomSheetConfirmation(
      context: context,
      message: appProvider.isEnglish ? messageEn : messageAr,
    ).then((value) async {
      if(value) {
        changeIsLoading(true);

        // Edit Wallet
        WalletModel walletModel = WalletModel(
          walletId: walletProvider.wallet!.walletId,
          userAccountId: userAccountProvider.userAccount!.userAccountId,
          balance: walletProvider.wallet!.balance - getPackageFromId(_selectedPackage!.packageId).price,
          packageId: _selectedPackage!.packageId,
          createdAt: walletProvider.wallet!.createdAt,
        );
        EditWalletParameters parameters = EditWalletParameters(
          walletModel: walletModel,
        );
        Either<Failure, WalletModel> response = await walletProvider.editWalletImpl(parameters);
        response.fold((failure) async {
          changeIsLoading(false);
          Dialogs.failureOccurred(context, failure);
        }, (wallet) async {
          // Insert Log
          LogModel logModel = LogModel(
            logId: 0,
            userAccountId: userAccountProvider.userAccount!.userAccountId,
            textAr: 'تم سحب ${selectedPackage!.price} جنية من المحفظة للاشتراك فى باقة ${selectedPackage!.nameAr}',
            textEn: '${selectedPackage!.price} EGP were withdrawn from the wallet to subscribe to ${selectedPackage!.nameEn}',
            createdAt: DateTime.now(),
          );
          InsertLogParameters parameters = InsertLogParameters(
            logModel: logModel,
          );
          Either<Failure, LogModel> response = await logsProvider.insertLogImpl(parameters);
          response.fold((failure) async {
            changeIsLoading(false);
            Dialogs.failureOccurred(context, failure);
          }, (log) {
            changeIsLoading(false);
            resetAllData();
            logsProvider.addLog(log);
            walletProvider.changeWallet(wallet);
            Dialogs.showBottomSheetMessage(
              context: context,
              message: Methods.getText(StringsManager.thePackageHasBeenSuccessfullySubscribed, appProvider.isEnglish).toCapitalized(),
              showMessage: ShowMessage.success,
              thenMethod: () => Navigator.pop(context),
            );
          });
        });
      }
    });
  }

  void resetAllData() {
    changeSelectedPackage(null);
  }

  Future<bool> onBackPressed(BuildContext context) async {
    resetAllData();
    return await Future.value(true);
  }

  // Start Pagination //
  int _numberOfItems = 0;
  int get numberOfItems => _numberOfItems;
  setNumberOfItems(int numberOfItems) => _numberOfItems = numberOfItems;
  changeNumberOfItems(int numberOfItems) {_numberOfItems = numberOfItems; notifyListeners();}

  bool _hasMoreData = true;
  bool get hasMoreData => _hasMoreData;
  setHasMoreData(bool hasMoreData) => _hasMoreData = hasMoreData;
  changeHasMoreData(bool hasMoreData) {_hasMoreData = hasMoreData;  notifyListeners();}

  late ScrollController _scrollController;
  ScrollController get scrollController => _scrollController;
  initScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if(_scrollController.offset == _scrollController.position.maxScrollExtent) {
        showDataInList(isResetData: false, isRefresh: true, isScrollUp: false);
      }
    });
  }
  disposeScrollController() => _scrollController.dispose();
  _scrollUp() => _scrollController.animateTo(0, duration: const Duration(seconds: 1), curve: Curves.fastOutSlowIn);

  int limit = 10;

  void showDataInList({required bool isResetData, required bool isRefresh, required bool isScrollUp}) async {
    try { // Check scrollController created or not & hasClients or not
      if(_scrollController.hasClients) {
        if(isScrollUp) {_scrollUp();}
      }
    }
    catch(error) {
      debugPrint(error.toString());
    }

    if(isResetData) {
      setNumberOfItems(0);
      setHasMoreData(true);
    }

    if(_hasMoreData) {
      List list = _packages;
      if(isRefresh) {changeNumberOfItems(_numberOfItems += (list.length - numberOfItems) >= limit ? limit : (list.length - numberOfItems));}
      if(!isRefresh) {setNumberOfItems(_numberOfItems += (list.length - numberOfItems) >= limit ? limit : (list.length - numberOfItems));}
      debugPrint('numberOfItems: $_numberOfItems');

      if(numberOfItems == list.length) {
        if(isRefresh) {changeHasMoreData(false);}
        if(!isRefresh) {setHasMoreData(false);}
      }
    }
  }
  // End Pagination //
}