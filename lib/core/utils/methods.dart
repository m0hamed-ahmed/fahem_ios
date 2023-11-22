import 'dart:async';
import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fahem/core/network/firebase_constants.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/language_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/services/notification_service.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/cache_helper.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/presentation/features/logs/controllers/logs_provider.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/transactions_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/wallet/controllers/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart' as intl;

class Methods {

  static String getText(String text, bool isEnglish) {
    String language = isEnglish ? ConstantsManager.english : ConstantsManager.arabic;
    return languageManager[text]![language]!;
  }

  static String formatDate({required BuildContext context, required int milliseconds, bool isDateOnly = false, bool isTimeAndAOnly = false}) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    String locale = appProvider.isEnglish ? 'en_US' : 'ar_EG';

    String date = intl.DateFormat.yMMMMd(locale).format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
    String time = intl.DateFormat('h:mm', locale).format(DateTime.fromMillisecondsSinceEpoch(milliseconds));
    String a = intl.DateFormat('a', locale).format(DateTime.fromMillisecondsSinceEpoch(milliseconds));

    if(isDateOnly) {
      return date;
    }
    else if(isTimeAndAOnly) {
      return '$time $a';
    }
    else {
      return '$date / $time $a';
    }
  }

  static String getYoutubeThumbnail(String videoId) {
    return 'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';
  }

  static String getRandomId() {
    List<String> characters = [
      '0', '1', '2', '3', '4', '5', '6', '7', '8', '9',
      'a','b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
      'A','B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
    ];
    String id = '';
    for(int i=0; i<20; i++) {
      id+= characters[Random().nextInt(characters.length)];
    }
    return id;
  }

  static String getRatingText({required BuildContext context, required double rating}) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    if(rating >= 0 && rating <= 1) {return getText(StringsManager.veryBad, appProvider.isEnglish).toCapitalized();}
    else if(rating > 1 && rating <= 2) {return getText(StringsManager.bad, appProvider.isEnglish).toCapitalized();}
    else if(rating > 2 && rating <= 3) {return getText(StringsManager.okay, appProvider.isEnglish).toCapitalized();}
    else if(rating > 3 && rating <= 4) {return getText(StringsManager.good, appProvider.isEnglish).toCapitalized();}
    else {return getText(StringsManager.excellent, appProvider.isEnglish).toCapitalized();}
  }

  static TextDirection getDirection(bool isEnglish) {
    return isEnglish ? TextDirection.ltr : TextDirection.rtl;
  }

  static Future<void> openUrl(String url) async {
    try {
      Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {await launchUrl(uri, mode: LaunchMode.externalApplication);}
      else {throw 'can\'t launch url';}
    }
    catch (e) {
      debugPrint(e.toString());
    }
  }

  static Future<bool> checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.wifi) {return true;}
    else if (result == ConnectivityResult.mobile) {return true;}
    else {return false;}
  }

  static Future<Position?> checkPermissionAndGetCurrentPosition(BuildContext context) async {
    Position? position;

    await Geolocator.isLocationServiceEnabled().then((isLocationServiceEnabled) async {
      if(isLocationServiceEnabled) {
        await Geolocator.checkPermission().then((locationPermission) async {
          if(locationPermission == LocationPermission.denied) {
            await Geolocator.requestPermission().then((locationPermission) async {
              if(locationPermission == LocationPermission.denied) {
                Dialogs.showPermissionDialog(
                  context: context,
                  title: StringsManager.permission,
                  message: StringsManager.youShouldUpdateTheLocationPermissionInTheAppSettings,
                );
              }
              if(locationPermission == LocationPermission.deniedForever) {
                Dialogs.showPermissionDialog(
                  context: context,
                  title: StringsManager.permission,
                  message: StringsManager.youShouldUpdateTheLocationPermissionInTheAppSettings,
                );
              }
              if(locationPermission == LocationPermission.whileInUse || locationPermission == LocationPermission.always) {
                position = await Geolocator.getCurrentPosition().then((value) => value);
              }
            });
          }
          else if(locationPermission == LocationPermission.deniedForever) {
            Dialogs.showPermissionDialog(
              context: context,
              title: StringsManager.location,
              message: StringsManager.youShouldUpdateTheLocationPermissionInTheAppSettings,
            );
          }
          else if(locationPermission == LocationPermission.whileInUse || locationPermission == LocationPermission.always) {
            position = await Geolocator.getCurrentPosition().then((value) => value);
          }
        });
      }
      else {
        Dialogs.showPermissionDialog(
          context: context,
          title: StringsManager.location,
          message: StringsManager.locationServicesAreDisabledTurnItOnToContinue,
        );
      }
    });

    return position;
  }

  static Future<void> logout(BuildContext context) async {
    UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
    WalletProvider walletProvider = Provider.of<WalletProvider>(context, listen: false);
    LogsProvider logsProvider = Provider.of<LogsProvider>(context, listen: false);
    TransactionsProvider transactionsProvider = Provider.of<TransactionsProvider>(context, listen: false);

    int userAccountId = userAccountProvider.userAccount!.userAccountId;

    CacheHelper.removeData(key: PREFERENCES_KEY_USER_ACCOUNT);

    userAccountProvider.changeUserAccount(null);
    walletProvider.changeWallet(null);
    logsProvider.changeLogs([]);
    transactionsProvider.changeTransactions([]);

    await NotificationService.unsubscribeFromTopic(FirebaseConstants.fahemTopic);
    await NotificationService.unsubscribeFromTopic('$userAccountId${ConstantsManager.keywordApp}');
  }
}