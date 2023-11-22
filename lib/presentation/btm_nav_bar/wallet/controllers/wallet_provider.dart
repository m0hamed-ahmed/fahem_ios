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
import 'package:fahem/data/models/users/wallet/wallet_model.dart';
import 'package:fahem/domain/usecases/users/logs/insert_log_usecase.dart';
import 'package:fahem/domain/usecases/users/wallet/edit_wallet_usecase.dart';
import 'package:fahem/domain/usecases/users/wallet/get_wallet_for_user_usecase.dart';
import 'package:fahem/domain/usecases/users/wallet/insert_wallet_usecase.dart';
import 'package:fahem/domain/usecases/users/wallet/is_user_have_wallet_usecase.dart';
import 'package:fahem/presentation/features/logs/controllers/logs_provider.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletProvider with ChangeNotifier {
  final GetWalletForUserUseCase _getWalletForUserUseCase;
  final InsertWalletUseCase _insertWalletUseCase;
  final EditWalletUseCase _editWalletUseCase;
  final IsUserHaveWalletUseCase _isUserHaveWalletUseCase;

  WalletProvider(
    this._getWalletForUserUseCase,
    this._insertWalletUseCase,
    this._editWalletUseCase,
    this._isUserHaveWalletUseCase,
  );

  Future<Either<Failure, WalletModel?>> getWalletForUserImpl(GetWalletParameters parameters) async {
    return await _getWalletForUserUseCase.call(parameters);
  }

  Future<Either<Failure, WalletModel>> insertWalletImpl(InsertWalletParameters parameters) async {
    return await _insertWalletUseCase.call(parameters);
  }

  Future<Either<Failure, WalletModel>> editWalletImpl(EditWalletParameters parameters) async {
    return await _editWalletUseCase.call(parameters);
  }

  Future<Either<Failure, bool>> isUserHaveWalletImpl(IsUserHaveWalletParameters parameters) async {
    return await _isUserHaveWalletUseCase.call(parameters);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  WalletModel? _wallet;
  WalletModel? get wallet => _wallet;
  setWallet(WalletModel? wallet) => _wallet = wallet;
  changeWallet(WalletModel? wallet) {_wallet = wallet; notifyListeners();}

  Future<void> onPressedAddMoneyToTheWallet(BuildContext context, int balance) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
    LogsProvider logsProvider = Provider.of<LogsProvider>(context, listen: false);

    changeIsLoading(true);

    if(_wallet == null) {
      // Insert Wallet
      WalletModel walletModel = WalletModel(
        walletId: 0,
        userAccountId: userAccountProvider.userAccount!.userAccountId,
        balance: balance,
        packageId: null,
        createdAt: DateTime.now(),
      );
      InsertWalletParameters parameters = InsertWalletParameters(
        walletModel: walletModel,
      );
      Either<Failure, WalletModel> response = await insertWalletImpl(parameters);
      response.fold((failure) async {
        changeIsLoading(false);
        Dialogs.failureOccurred(context, failure);
      }, (wallet) async {
        // Insert Log
        LogModel logModel = LogModel(
          logId: 0,
          userAccountId: userAccountProvider.userAccount!.userAccountId,
          textAr: 'تم شحن المحفظة برصيد ${walletModel.balance} جنية',
          textEn: 'Charging the wallet with a balance of ${walletModel.balance} EGP',
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
          logsProvider.addLog(log);
          changeWallet(wallet);
          Dialogs.showBottomSheetMessage(
            context: context,
            message: Methods.getText(StringsManager.theBalanceHasBeenAddedToTheWallet, appProvider.isEnglish).toCapitalized(),
            showMessage: ShowMessage.success,
          );
        });
      });
    }
    else {
      // Edit Wallet
      WalletModel walletModel = WalletModel(
        walletId: _wallet!.walletId,
        userAccountId: userAccountProvider.userAccount!.userAccountId,
        balance: _wallet!.balance + balance,
        packageId: _wallet!.packageId,
        createdAt: _wallet!.createdAt,
      );
      EditWalletParameters parameters = EditWalletParameters(
        walletModel: walletModel,
      );
      Either<Failure, WalletModel> response = await editWalletImpl(parameters);
      response.fold((failure) async {
        changeIsLoading(false);
        Dialogs.failureOccurred(context, failure);
      }, (wallet) async {
        // Insert Log
        LogModel logModel = LogModel(
          logId: 0,
          userAccountId: userAccountProvider.userAccount!.userAccountId,
          textAr: 'تم شحن المحفظة برصيد $balance جنية',
          textEn: 'Charging the wallet with a balance of $balance EGP',
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
          logsProvider.addLog(log);
          changeWallet(wallet);
          Dialogs.showBottomSheetMessage(
            context: context,
            message: Methods.getText(StringsManager.theBalanceHasBeenAddedToTheWallet, appProvider.isEnglish).toCapitalized(),
            showMessage: ShowMessage.success,
          );
        });
      });
    }
  }
}