import 'dart:async';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/error/firebase_exception_handler.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignInWithPhoneProvider with ChangeNotifier {

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  Timer? _timer;
  int? _resendCodeTimer;
  int? get resendCodeTimer => _resendCodeTimer;
  changeResendCodeTimer(int? resendCodeTimer) {_resendCodeTimer = resendCodeTimer; notifyListeners();}

  void startResendCodeTimer() {
    _timer?.cancel();
    _resendCodeTimer = ConstantsManager.resendCodeDuration;
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if(timer.isActive) {
        if (_resendCodeTimer! <= 0) {timer.cancel();}
        else {_resendCodeTimer = _resendCodeTimer! - 1;}
        notifyListeners(); // TODO: Exception when leave this page
      }
    });
  }

  Future<void> verifyPhoneNumber({required BuildContext context, required String phoneNumber}) async {
    if(_resendCodeTimer == 0) {changeResendCodeTimer(null);}
    if(resendCodeTimer == null) {
      await Methods.checkConnectivityState().then((isConnected) async {
        if(isConnected) {
          try {
            changeIsLoading(true);
            await FirebaseAuth.instance.verifyPhoneNumber(
              timeout: const Duration(seconds: ConstantsManager.resendCodeDuration),
              phoneNumber: '${ConstantsManager.dialingCodeEG}$phoneNumber',
              verificationCompleted: (phoneAuthCredential) {
                changeIsLoading(false);
                debugPrint('verificationCompleted');
              },
              verificationFailed: (error) {
                if(error.message != null) Dialogs.failureOccurred(context, LocalFailure(messageAr: error.message!, messageEn: error.message!), bottomSheetClosedDuration: 5);
                changeIsLoading(false);
                debugPrint('verificationFailed: $error');
                FirebaseExceptionHandler.handleFirebaseException(context: context, code: error.code);
              },
              codeSent: (verificationId, forceResendingToken) async {
                changeIsLoading(false);
                debugPrint('codeSent');
                startResendCodeTimer();
                Navigator.pushNamed(
                  context,
                  Routes.otpRoute,
                  arguments: {
                    ConstantsManager.verificationIdArgument: verificationId,
                    ConstantsManager.phoneNumberArgument: phoneNumber,
                  },
                );
              },
              codeAutoRetrievalTimeout: (verificationId) {
                changeIsLoading(false);
                debugPrint('codeAutoRetrievalTimeout');
              },
            );
          }
          catch (error) {
            Dialogs.failureOccurred(context, LocalFailure(messageAr: Methods.getText(StringsManager.anErrorOccurred, false), messageEn: Methods.getText(StringsManager.anErrorOccurred, true)));
          }
        }
        else {
          Dialogs.failureOccurred(context, LocalFailure(messageAr: Methods.getText(StringsManager.checkYourInternetConnection, false), messageEn: Methods.getText(StringsManager.checkYourInternetConnection, true)));
        }
      });
    }
  }
}