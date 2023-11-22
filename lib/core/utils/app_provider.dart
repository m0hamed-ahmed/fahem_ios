import 'package:flutter/material.dart';

class AppProvider with ChangeNotifier {

  AppProvider({required isEnglish, required version}) {
    _isEnglish = isEnglish;
    _version = version;
  }

  bool _isEnglish = false;
  bool get isEnglish => _isEnglish;
  changeIsEnglish(bool isEnglish) {_isEnglish = isEnglish; notifyListeners();}

  String _version = '';
  String get version => _version;
  setVersion(String version) => _version = version;
}