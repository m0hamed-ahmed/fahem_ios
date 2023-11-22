import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/utils/cache_helper.dart';
import 'package:flutter/material.dart';

class GetStartProvider with ChangeNotifier{

  Future<void> startNow(BuildContext context) async {
    CacheHelper.setData(key: PREFERENCES_KEY_IS_FIRST_OPEN_APP, value: false);
    Navigator.pushNamedAndRemoveUntil(context, Routes.splashRoute, (route) => false);
  }
}