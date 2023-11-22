import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:flutter/material.dart';

class FirebaseExceptionHandler {

  static void handleFirebaseException({required BuildContext context, required String code}) {
    switch (code) {
      case 'invalid-phone-number':
        Dialogs.failureOccurred(context, LocalFailure(messageAr: Methods.getText(StringsManager.phoneNumberIsNotValid, false), messageEn: Methods.getText(StringsManager.phoneNumberIsNotValid, true)));
        break;
      case 'network-request-failed':
        Dialogs.failureOccurred(context, LocalFailure(messageAr: Methods.getText(StringsManager.networkRequestFailed, false), messageEn: Methods.getText(StringsManager.networkRequestFailed, true)));
        break;
      case 'invalid-verification-code':
        Dialogs.failureOccurred(context, LocalFailure(messageAr: Methods.getText(StringsManager.theVerificationCodeIsNotValid, false), messageEn: Methods.getText(StringsManager.theVerificationCodeIsNotValid, true)));
        break;
      case 'invalid-verification-id':
        Dialogs.failureOccurred(context, LocalFailure(messageAr: Methods.getText(StringsManager.theVerificationCodeIsNotValid, false), messageEn: Methods.getText(StringsManager.theVerificationCodeIsNotValid, true)));
        break;


    }
  }
}