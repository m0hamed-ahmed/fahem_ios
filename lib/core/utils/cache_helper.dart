import 'package:shared_preferences/shared_preferences.dart';

// App
const String PREFERENCES_KEY_IS_FIRST_OPEN_APP = "PREFERENCES_KEY_IS_FIRST_OPEN_APP";
const String PREFERENCES_KEY_IS_ENGLISH = "PREFERENCES_KEY_IS_ENGLISH";
const String PREFERENCES_KEY_USER_ACCOUNT = "PREFERENCES_KEY_USER_ACCOUNT";
const String PREFERENCES_KEY_IS_TRANSACTIONS_PAGE_VIEWED = "PREFERENCES_KEY_IS_TRANSACTIONS_PAGE_VIEWED";
const String PREFERENCES_KEY_IS_FIRST_OPEN_INSTANTS_LAWYERS = "PREFERENCES_KEY_IS_FIRST_OPEN_INSTANTS_LAWYERS";
const String PREFERENCES_KEY_IS_FIRST_OPEN_INSTANTS_CONSULTATION = "PREFERENCES_KEY_IS_FIRST_OPEN_INSTANTS_CONSULTATION";
const String PREFERENCES_KEY_IS_FIRST_OPEN_SECRET_LAWYER = "PREFERENCES_KEY_IS_FIRST_OPEN_SECRET_LAWYER";
const String PREFERENCES_KEY_IS_FIRST_OPEN_ESTABLISHING_COMPANIES = "PREFERENCES_KEY_IS_FIRST_OPEN_ESTABLISHING_COMPANIES";
const String PREFERENCES_KEY_IS_FIRST_OPEN_REAL_ESTATE_LEGAL_ADVICE = "PREFERENCES_KEY_IS_FIRST_OPEN_REAL_ESTATE_LEGAL_ADVICE";
const String PREFERENCES_KEY_IS_FIRST_OPEN_INVESTMENT_LEGAL_ADVICE = "PREFERENCES_KEY_IS_FIRST_OPEN_INVESTMENT_LEGAL_ADVICE";
const String PREFERENCES_KEY_IS_FIRST_OPEN_TRADEMARK_REGISTRATION_AND_INTELLECTUAL_PROTECTION = "PREFERENCES_KEY_IS_FIRST_OPEN_TRADEMARK_REGISTRATION_AND_INTELLECTUAL_PROTECTION";
const String PREFERENCES_KEY_IS_FIRST_OPEN_DEBT_COLLECTION = "PREFERENCES_KEY_IS_FIRST_OPEN_DEBT_COLLECTION";

class CacheHelper {
  static late SharedPreferences _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
    // clearData();
  }

  static Future<bool> setData({required String key, required dynamic value}) async {
    if(value.runtimeType == String) {return await _sharedPreferences.setString(key, value);}
    if(value.runtimeType == bool) {return await _sharedPreferences.setBool(key, value);}
    if(value.runtimeType == int) {return await _sharedPreferences.setInt(key, value);}
    return await _sharedPreferences.setDouble(key, value);
  }

  static dynamic getData({required String key}) {
    return _sharedPreferences.get(key);
  }

  static Future<bool> removeData({required String key}) async {
    return await _sharedPreferences.remove(key);
  }

  static Future<bool> clearData() async {
    return await _sharedPreferences.clear();
  }
}