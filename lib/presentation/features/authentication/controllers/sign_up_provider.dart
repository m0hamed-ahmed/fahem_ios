import 'dart:async';
import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/network/firebase_constants.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/services/notification_service.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/cache_helper.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/domain/usecases/users/users_accounts/check_and_get_user_account_usecase.dart';
import 'package:fahem/domain/usecases/users/users_accounts/delete_user_account_usecase.dart';
import 'package:fahem/domain/usecases/users/users_accounts/edit_user_account_usecase.dart';
import 'package:fahem/domain/usecases/users/users_accounts/insert_user_account_usecase.dart';
import 'package:fahem/domain/usecases/users/users_accounts/is_user_account_exist_usecase.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignUpProvider with ChangeNotifier {
  final CheckAndGetUserAccountUseCase _checkAndGetUserAccountUseCase;
  final IsUserAccountExistUseCase _isUserAccountExistUseCase;
  final InsertUserAccountUseCase _insertUserAccountUseCase;
  final EditUserAccountUseCase _editUserAccountUseCase;
  final DeleteUserAccountUseCase _deleteUserAccountUseCase;

  SignUpProvider(this._checkAndGetUserAccountUseCase, this._isUserAccountExistUseCase, this._insertUserAccountUseCase, this._editUserAccountUseCase, this._deleteUserAccountUseCase);

  Future<Either<Failure, UserAccountModel?>> checkAndGetUserAccountImpl(CheckAndGetUserAccountParameters parameters) async {
    return await _checkAndGetUserAccountUseCase.call(parameters);
  }

  Future<Either<Failure, bool>> isUserAccountExistImpl(IsUserAccountExistParameters parameters) async {
    return await _isUserAccountExistUseCase.call(parameters);
  }

  Future<Either<Failure, UserAccountModel>> insertUserAccountImpl(InsertUserAccountParameters parameters) async {
    return await _insertUserAccountUseCase.call(parameters);
  }

  Future<Either<Failure, UserAccountModel>> editUserAccountImpl(EditUserAccountParameters parameters) async {
    return await _editUserAccountUseCase.call(parameters);
  }

  Future<Either<Failure, void>> deleteUserAccountImpl(DeleteUserAccountParameters parameters) async {
    return await _deleteUserAccountUseCase.call(parameters);
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  Gender? _gender;
  Gender? get gender => _gender;
  setGender(Gender? gender) => _gender = gender;
  changeGender(Gender? gender) {_gender = gender; notifyListeners();}

  DateTime? _birthDate;
  DateTime? get birthDate => _birthDate;
  setBirthDate(DateTime? birthDate) => _birthDate = birthDate;
  changeBirthDate(DateTime? birthDate) {_birthDate = birthDate; notifyListeners();}

  bool isAllDataValid() {
    if(_gender == null) {return false;}
    else if(_birthDate == null) {return false;}
    else {return true;}
  }

  Future<void> signUp({required BuildContext context, required UserAccountModel userAccountModel}) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);

    changeIsLoading(true);

    // Sign Up
    InsertUserAccountParameters parameters = InsertUserAccountParameters(
      userAccountModel: userAccountModel,
    );
    Either<Failure, UserAccountModel> response = await insertUserAccountImpl(parameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (account) async {
      await NotificationService.subscribeToTopic(FirebaseConstants.fahemTopic).then((value) async {
        await NotificationService.subscribeToTopic('${account.userAccountId}${ConstantsManager.keywordApp}').then((value) {
          NotificationService.createLocalNotification(title: 'اهلا ${account.firstName} ${account.familyName}', body: 'مرحبا بك فى فاهم نحن سعداء بتواجدك معنا');
          changeIsLoading(false);
          CacheHelper.setData(key: PREFERENCES_KEY_USER_ACCOUNT, value: json.encode(UserAccountModel.toMap(account)));
          userAccountProvider.changeUserAccount(account);
          Dialogs.showBottomSheetMessage(
            context: context,
            message: '${Methods.getText(StringsManager.thankYou, appProvider.isEnglish).toTitleCase()}\n${Methods.getText(StringsManager.successfullyRegistered, appProvider.isEnglish).toTitleCase()}',
            showMessage: ShowMessage.success,
            thenMethod: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
          );
        }).catchError((error) {
          changeIsLoading(false);
        });
      }).catchError((error) {
        changeIsLoading(false);
      });
    });
  }

  void resetAllData() {
    setGender(null);
    setBirthDate(null);
  }
}