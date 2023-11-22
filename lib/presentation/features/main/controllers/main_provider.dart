import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/cache_helper.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/presentation/btm_nav_bar/home/screens/home_page.dart';
import 'package:fahem/presentation/btm_nav_bar/menu/menu/menu_page.dart';
import 'package:fahem/presentation/btm_nav_bar/search/screens/search_screen.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/screens/transactions_page.dart';
import 'package:fahem/presentation/btm_nav_bar/wallet/screens/wallet_page.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/features/start/controllers/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainProvider with ChangeNotifier {

  int _bottomNavigationBarIndex = 0;
  int get bottomNavigationBarIndex => _bottomNavigationBarIndex;
  setBottomNavigationBarIndex(int index) => _bottomNavigationBarIndex = index;
  changeBottomNavigationBarIndex(int index) {_bottomNavigationBarIndex = index; notifyListeners();}

  final List<Widget> _pages = const [
    HomePage(),
    SearchPage(),
    TransactionsPage(),
    WalletPage(),
    MenuPage(),
  ];
  List<Widget> get pages => _pages;

  void onBottomNavigationBarPressed({required BuildContext context,  required int index}) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    if(index == 2 || index == 3) {
      UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
      if(userAccountProvider.userAccount == null) {
        Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.youMustLoginFirstToAccessTheService, appProvider.isEnglish).toCapitalized()).then((value) async {
          if(value) {Navigator.pushNamed(context, Routes.signInWithPhoneNumberRoute);}
        });
      }
      else {
        if(index == 2) {
          CacheHelper.setData(key: PREFERENCES_KEY_IS_TRANSACTIONS_PAGE_VIEWED, value: true);
        }
        changeBottomNavigationBarIndex(index);
      }
    }
    else {
      changeBottomNavigationBarIndex(index);
    }
  }

  Future<bool> onBackPressed(BuildContext context) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    if(_bottomNavigationBarIndex == 0) {
      return await Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.doYouWantToExitAnApp, appProvider.isEnglish).toCapitalized());
    }
    else {
      changeBottomNavigationBarIndex(0);
      return await Future.value(false);
    }
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  changeIsLoading(bool isLoading) {_isLoading = isLoading; notifyListeners();}

  Future<void> onRefresh(BuildContext context) async {
    SplashProvider splashProvider = Provider.of<SplashProvider>(context, listen: false);

    changeIsLoading(true);
    await splashProvider.getData(context: context, isSwipeRefresh: true);
    changeIsLoading(false);
  }
}