import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:flutter/material.dart';

class UserAccountProvider with ChangeNotifier {

  UserAccountProvider({required userAccount}) {
    _userAccount = userAccount;
  }

  UserAccountModel? _userAccount;
  UserAccountModel? get userAccount => _userAccount;
  setUserAccount(UserAccountModel? userAccount) => _userAccount = userAccount;
  changeUserAccount(UserAccountModel? userAccount) {_userAccount = userAccount; notifyListeners();}
}