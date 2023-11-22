import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/error/firebase_exception_handler.dart';
import 'package:fahem/core/network/firebase_constants.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/services/notification_service.dart';
import 'package:fahem/core/utils/cache_helper.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/users/logs/log_model.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/data/models/transactions/transactions/transaction_model.dart';
import 'package:fahem/data/models/users/wallet/wallet_model.dart';
import 'package:fahem/domain/usecases/users/logs/get_logs_for_user_usecase.dart';
import 'package:fahem/domain/usecases/transactions/transactions/get_transactions_for_user_usecase.dart';
import 'package:fahem/domain/usecases/users/users_accounts/check_and_get_user_account_usecase.dart';
import 'package:fahem/domain/usecases/users/wallet/get_wallet_for_user_usecase.dart';
import 'package:fahem/presentation/features/authentication/controllers/sign_up_provider.dart';
import 'package:fahem/presentation/features/logs/controllers/logs_provider.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/transactions_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/wallet/controllers/wallet_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OtpProvider with ChangeNotifier {

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  String? _myOtpCode;
  String? get myOtpCode => _myOtpCode;
  setMyOtpCode(String? myOtpCode) => _myOtpCode = myOtpCode;
  changeMyOtpCode(String? myOtpCode) {_myOtpCode = myOtpCode; notifyListeners();}

  Future<void> verifyCode({required BuildContext context, required String verificationId, required String phoneNumber}) async {
    await Methods.checkConnectivityState().then((isConnected) async {
      if(isConnected) {
        try {
          changeIsLoading(true);
          PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: _myOtpCode!);
           await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential).then((value) async {
             await signInWithPhoneNumber(context: context, phoneNumber: phoneNumber);
          });
          changeIsLoading(false);
        }
        on FirebaseAuthException catch (error) {
          changeIsLoading(false);
          FirebaseExceptionHandler.handleFirebaseException(context: context, code: error.code);
        }
        catch (error) {
          changeIsLoading(false);
          Dialogs.failureOccurred(context, LocalFailure(messageAr: Methods.getText(StringsManager.anErrorOccurred, false), messageEn: Methods.getText(StringsManager.anErrorOccurred, true)));
        }
      }
      else {
        Dialogs.failureOccurred(context, LocalFailure(messageAr: Methods.getText(StringsManager.checkYourInternetConnection, false), messageEn: Methods.getText(StringsManager.checkYourInternetConnection, true)));
       }
    });
  }

  Future<void> signInWithPhoneNumber({required BuildContext context, required String phoneNumber}) async {
    UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
    LogsProvider logsProvider = Provider.of<LogsProvider>(context, listen: false);
    TransactionsProvider transactionsProvider = Provider.of<TransactionsProvider>(context, listen: false);
    SignUpProvider signUpProvider = Provider.of<SignUpProvider>(context, listen: false);

    changeIsLoading(true);

    // Check And Get Account
    CheckAndGetUserAccountParameters parameters = CheckAndGetUserAccountParameters(
      phoneNumber: phoneNumber,
    );
    Either<Failure, UserAccountModel?> response = await signUpProvider.checkAndGetUserAccountImpl(parameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (account) async {
      if(account == null) {
        changeIsLoading(false);
        Navigator.pushReplacementNamed(context, Routes.signUpRoute, arguments: {ConstantsManager.phoneNumberArgument: phoneNumber});
      }
      else {
        // Get Wallet
        GetWalletParameters parameters = GetWalletParameters(
          userAccountId: account.userAccountId,
        );
        Either<Failure, WalletModel?> response = await walletProvider.getWalletForUserImpl(parameters);
        response.fold((failure) async {
          changeIsLoading(false);
          Dialogs.failureOccurred(context, failure);
        }, (wallet) async {
          // Get Logs
          GetLogsForUserParameters parameters = GetLogsForUserParameters(
            userAccountId: account.userAccountId,
          );
          Either<Failure, List<LogModel>> response = await logsProvider.getLogsForUserImpl(parameters);
          response.fold((failure) async {
            changeIsLoading(false);
            Dialogs.failureOccurred(context, failure);
          }, (logs) async {
            // Get Transactions
            GetTransactionsForUserParameters parameters = GetTransactionsForUserParameters(
              userAccountId: account.userAccountId,
            );
            Either<Failure, List<TransactionModel>> response = await transactionsProvider.getTransactionsForUserImpl(parameters);
            response.fold((failure) async {
              changeIsLoading(false);
              Dialogs.failureOccurred(context, failure);
            }, (transactions) async {
              await NotificationService.subscribeToTopic(FirebaseConstants.fahemTopic).then((value) async {
                await NotificationService.subscribeToTopic('${account.userAccountId}${ConstantsManager.keywordApp}').then((value) {
                  NotificationService.createLocalNotification(title: 'اهلا ${account.firstName} ${account.familyName}', body: 'مرحبا بك فى فاهم نحن سعداء بتواجدك معنا');
                  changeIsLoading(false);
                  CacheHelper.setData(key: PREFERENCES_KEY_USER_ACCOUNT, value: json.encode(UserAccountModel.toMap(account)));
                  userAccountProvider.changeUserAccount(account);
                  walletProvider.changeWallet(wallet);
                  logsProvider.changeLogs(logs);
                  transactionsProvider.changeTransactions(transactions);
                  Navigator.pop(context);
                  Navigator.pop(context);
                }).catchError((error) {
                  changeIsLoading(false);
                });
              }).catchError((error) {
                changeIsLoading(false);
              });
            });
          });
        });
      }
    });
  }

  void resetAllDate() {
    setMyOtpCode(null);
  }
}