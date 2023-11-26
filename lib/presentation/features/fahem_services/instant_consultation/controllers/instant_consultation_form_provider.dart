import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/network/firebase_constants.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/services/kashier_payment_service.dart';
import 'package:fahem/core/services/notification_service.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/cache_helper.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/users/logs/log_model.dart';
import 'package:fahem/data/models/transactions/transactions/transaction_model.dart';
import 'package:fahem/data/models/users/wallet/wallet_model.dart';
import 'package:fahem/domain/usecases/users/logs/insert_log_usecase.dart';
import 'package:fahem/domain/usecases/transactions/transactions/insert_transaction_usecase.dart';
import 'package:fahem/domain/usecases/users/wallet/edit_wallet_usecase.dart';
import 'package:fahem/presentation/features/logs/controllers/logs_provider.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/features/settings/controllers/settings_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/transactions_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/wallet/controllers/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

class InstantConsultationFormProvider with ChangeNotifier {

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  void onPressedConsultNow(BuildContext context, TransactionModel transactionModel) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
    TransactionsProvider transactionsProvider = Provider.of<TransactionsProvider>(context, listen: false);
    LogsProvider logsProvider = Provider.of<LogsProvider>(context, listen: false);
    SettingsProvider settingsProvider = Provider.of<SettingsProvider>(context, listen: false);
    int serviceCost = settingsProvider.settings.instantConsultationPrice;

    Dialogs.showPayConfirmationDialog(
      context: context,
      title: Methods.getText(StringsManager.payTheCostOfTheInstantConsultation, appProvider.isEnglish).toCapitalized(),
      serviceCost: serviceCost,
    ).then((paymentMethod) async {
      if(paymentMethod != null) {
        if(paymentMethod == PaymentsMethods.wallet) {
          if(walletProvider.wallet != null && walletProvider.wallet!.balance >= serviceCost) {
            Dialogs.showBottomSheetConfirmation(context: context, message: '${Methods.getText(StringsManager.areYouSureToWithdraw, appProvider.isEnglish).toCapitalized()} $serviceCost ${Methods.getText(StringsManager.poundsFromYourWallet, appProvider.isEnglish)}').then((value) async {
              if(value) {
                changeIsLoading(true);

                // Edit Wallet
                WalletModel walletModel = WalletModel(
                  walletId: walletProvider.wallet!.walletId,
                  userAccountId: userAccountProvider.userAccount!.userAccountId,
                  balance: walletProvider.wallet!.balance - serviceCost,
                  packageId: walletProvider.wallet!.packageId,
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
                  // Insert Transaction
                  InsertTransactionParameters parameters = InsertTransactionParameters(
                    transactionModel: transactionModel,
                  );
                  Either<Failure, TransactionModel> response = await transactionsProvider.insertTransactionImpl(parameters);
                  response.fold((failure) async {
                    changeIsLoading(false);
                    Dialogs.failureOccurred(context, failure);
                  }, (transaction) async {
                    // Insert Log
                    LogModel logModel = LogModel(
                      logId: 0,
                      userAccountId: userAccountProvider.userAccount!.userAccountId,
                      textAr: 'تم دفع $serviceCost جنية لحجز استشارة فورية',
                      textEn: '$serviceCost EGP were paid to book an instant consultation',
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
                      CacheHelper.setData(key: PREFERENCES_KEY_IS_TRANSACTIONS_PAGE_VIEWED, value: false);
                      NotificationService.pushNotification(topic: FirebaseConstants.instantConsultationsTopic, title: 'استشارة فورية', body: 'يوجد استشارة فورية جديدة');
                      changeIsLoading(false);
                      transactionsProvider.addTransaction(transaction);
                      logsProvider.addLog(log);
                      walletProvider.changeWallet(walletModel);
                      Dialogs.showBottomSheetMessage(
                        context: context,
                        message: Methods.getText(StringsManager.yourConsultationHasBeenSentAndYouWillBeAnsweredWithinMinutes, appProvider.isEnglish).toCapitalized(),
                        showMessage: ShowMessage.success,
                        thenMethod: () => Navigator.pop(context),
                      );
                    });
                  });
                });
              }
            });
          }
          else {
            Dialogs.showBottomSheetMessage(
              context: context,
              message: Methods.getText(StringsManager.thereIsNotEnoughBalanceInYourAccount, appProvider.isEnglish).toCapitalized(),
            );
          }
        }
        else {
          await InternetConnectionChecker().hasConnection.then((hasConnection) async {
            if(hasConnection) {
              UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
              String name = '${userAccountProvider.userAccount!.firstName} ${userAccountProvider.userAccount!.familyName}';

              await KashierPaymentService.chargeWallet(
                context: context,
                customerName: name,
                totalAmount: serviceCost,
                onPaymentStatusPaid: () async {
                  changeIsLoading(true);

                  // Insert Transaction
                  InsertTransactionParameters parameters = InsertTransactionParameters(
                    transactionModel: transactionModel,
                  );
                  Either<Failure, TransactionModel> response = await transactionsProvider.insertTransactionImpl(parameters);
                  response.fold((failure) async {
                    changeIsLoading(false);
                    Dialogs.failureOccurred(context, failure);
                  }, (transaction) async {
                    // Insert Log
                    LogModel logModel = LogModel(
                      logId: 0,
                      userAccountId: userAccountProvider.userAccount!.userAccountId,
                      textAr: 'تم دفع $serviceCost جنية لحجز استشارة فورية',
                      textEn: '$serviceCost EGP were paid to book an instant consultation',
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
                      CacheHelper.setData(key: PREFERENCES_KEY_IS_TRANSACTIONS_PAGE_VIEWED, value: false);
                      NotificationService.pushNotification(topic: FirebaseConstants.instantConsultationsTopic, title: 'استشارة فورية', body: 'يوجد استشارة فورية جديدة');
                      changeIsLoading(false);
                      transactionsProvider.addTransaction(transaction);
                      logsProvider.addLog(log);
                      Dialogs.showBottomSheetMessage(
                        context: context,
                        message: Methods.getText(StringsManager.yourConsultationHasBeenSentAndYouWillBeAnsweredWithinMinutes, appProvider.isEnglish).toCapitalized(),
                        showMessage: ShowMessage.success,
                        thenMethod: () => Navigator.pop(context),
                      );
                    });
                  });
                },
              );
            }
            else {
              Dialogs.failureOccurred(context, LocalFailure(messageAr: 'تحقق من اتصالك بالانترنت', messageEn: 'check your internet connection'));
            }
          });
        }
      }
    });
  }
}