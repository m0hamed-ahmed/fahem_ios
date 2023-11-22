import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:fahem/core/error/failure.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/cache_helper.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/domain/usecases/users/users_accounts/delete_user_account_usecase.dart';
import 'package:fahem/domain/usecases/users/users_accounts/edit_user_account_usecase.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileProvider with ChangeNotifier {
  final EditUserAccountUseCase _editUserAccountUseCase;
  final DeleteUserAccountUseCase _deleteUserAccountUseCase;

  ProfileProvider(this._editUserAccountUseCase, this._deleteUserAccountUseCase);

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
    return true;
  }

  Future<void> editProfile({required BuildContext context, required EditUserAccountParameters editUserAccountParameters}) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);

    changeIsLoading(true);

    // Edit Profile
    Either<Failure, UserAccountModel> response = await editUserAccountImpl(editUserAccountParameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (userAccount) async {
      changeIsLoading(false);
      CacheHelper.setData(key: PREFERENCES_KEY_USER_ACCOUNT, value: json.encode(UserAccountModel.toMap(userAccount)));
      userAccountProvider.changeUserAccount(userAccount);
      Dialogs.showBottomSheetMessage(
        context: context,
        message: Methods.getText(StringsManager.profileModifiedSuccessfully, appProvider.isEnglish).toCapitalized(),
        showMessage: ShowMessage.success,
      );
    });
  }

  Future<void> deleteAccount({required BuildContext context, required DeleteUserAccountParameters deleteUserAccountParameters}) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    changeIsLoading(true);

    // Delete Account
    Either<Failure, void> response = await deleteUserAccountImpl(deleteUserAccountParameters);
    response.fold((failure) async {
      changeIsLoading(false);
      Dialogs.failureOccurred(context, failure);
    }, (_) async {
      changeIsLoading(false);
      Methods.logout(context).then((value) {
        Dialogs.showBottomSheetMessage(
          context: context,
          message: Methods.getText(StringsManager.theAccountHasBeenDeletedSuccessfully, appProvider.isEnglish).toCapitalized(),
          showMessage: ShowMessage.success,
          thenMethod: () => Navigator.pop(context),
        );
      });
    });
  }
}