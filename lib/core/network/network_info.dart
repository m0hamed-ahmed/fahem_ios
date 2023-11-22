import 'package:internet_connection_checker/internet_connection_checker.dart';

abstract class BaseNetworkInfo {
  Future<bool> get isConnected;
}

class NetworkInfo extends BaseNetworkInfo {
  final InternetConnectionChecker _internetConnectionChecker;

  NetworkInfo(this._internetConnectionChecker);

  @override
  Future<bool> get isConnected async => await _internetConnectionChecker.hasConnection;
}