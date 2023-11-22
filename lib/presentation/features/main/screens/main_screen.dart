import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/presentation/btm_nav_bar/wallet/controllers/wallet_provider.dart';
import 'package:fahem/presentation/features/main/controllers/main_provider.dart';
import 'package:fahem/presentation/features/main/widget/bottom_navigation_bar_item.dart';
import 'package:fahem/presentation/btm_nav_bar/transactions/controllers/transactions_provider.dart';
import 'package:fahem/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem/presentation/shared/background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {

  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late AppProvider appProvider;
  late MainProvider mainProvider;
  late TransactionsProvider transactionsProvider;
  late WalletProvider walletProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    mainProvider = Provider.of<MainProvider>(context, listen: false);
    transactionsProvider = Provider.of<TransactionsProvider>(context, listen: false);
    walletProvider = Provider.of<WalletProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(!walletProvider.isLoading),
      child: IgnorePointer(
        ignoring: walletProvider.isLoading,
        child: RefreshIndicator(
          onRefresh: () async => await mainProvider.onRefresh(context),
          displacement: SizeManager.s100,
          backgroundColor: ColorsManager.primaryColor,
          color: ColorsManager.white,
          strokeWidth: SizeManager.s3,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Selector<MainProvider, bool>(
              selector: (context, provider) => provider.isLoading,
              builder: (context, isLoading, _) {
                return AbsorbPointerWidget(
                  absorbing: isLoading,
                  isCircularProgressIndicator: false,
                  child: Selector<AppProvider, bool>(
                    selector: (context, provider) => provider.isEnglish,
                    builder: (context, isEnglish, _) {
                      return WillPopScope(
                        onWillPop: () => isLoading ? Future.value(false) : mainProvider.onBackPressed(context),
                        child: Directionality(
                          textDirection: Methods.getDirection(appProvider.isEnglish),
                          child: Selector<MainProvider, int>(
                            selector: (context, provider) => provider.bottomNavigationBarIndex,
                            builder: (context, bottomNavigationBarIndex, child) {
                              return Scaffold(
                                body: Background(
                                  child: SafeArea(
                                    child: mainProvider.pages[mainProvider.bottomNavigationBarIndex],
                                  ),
                                ),
                                bottomNavigationBar: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(SizeManager.s20),
                                    topLeft: Radius.circular(SizeManager.s20),
                                  ),
                                  child: BottomNavigationBar(
                                    currentIndex: mainProvider.bottomNavigationBarIndex,
                                    backgroundColor: ColorsManager.primaryColor,
                                    type: BottomNavigationBarType.fixed,
                                    selectedItemColor: ColorsManager.white,
                                    unselectedItemColor: ColorsManager.white.withOpacity(0.5),
                                    selectedFontSize: SizeManager.s12,
                                    unselectedFontSize: SizeManager.s10,
                                    elevation: SizeManager.s0,
                                    onTap: (index) => mainProvider.onBottomNavigationBarPressed(context: context, index: index),
                                    items: [
                                      bottomNavigationBarItem(context: context, index: 0, text: Methods.getText(StringsManager.home, appProvider.isEnglish).toCapitalized(), image: ImagesManager.homeIc),
                                      bottomNavigationBarItem(context: context, index: 1, text: Methods.getText(StringsManager.search, appProvider.isEnglish).toCapitalized(), image: ImagesManager.searchIc),
                                      bottomNavigationBarItem(context: context, index: 2, text: Methods.getText(StringsManager.myTransactions, appProvider.isEnglish).toCapitalized(), image: ImagesManager.transactionIc),
                                      bottomNavigationBarItem(context: context, index: 3, text: Methods.getText(StringsManager.myWallet, appProvider.isEnglish).toCapitalized(), image: ImagesManager.walletIc),
                                      bottomNavigationBarItem(context: context, index: 4, text: Methods.getText(StringsManager.menu, appProvider.isEnglish).toCapitalized(), image: ImagesManager.menuIc),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}