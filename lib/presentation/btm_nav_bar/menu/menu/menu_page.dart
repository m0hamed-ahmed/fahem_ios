import 'dart:io';
import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/cache_helper.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/presentation/features/main/controllers/main_provider.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class MenuPage extends StatefulWidget {

  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  late AppProvider appProvider;
  late MainProvider mainProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    mainProvider = Provider.of<MainProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FlipInY(
      duration: const Duration(seconds: 1),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Selector<UserAccountProvider, UserAccountModel?>(
                    selector: (context, provider) => provider.userAccount,
                    builder: (context, account, _) {
                      return Text(
                        account == null ? Methods.getText(StringsManager.guest, appProvider.isEnglish).toCapitalized() : '${account.firstName} ${account.familyName}',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                      );
                    },
                  ),
                  const SizedBox(height: SizeManager.s24),
                  const Divider(color: ColorsManager.grey, height: SizeManager.s0),
                  Column(
                    children: [
                      Selector<UserAccountProvider, UserAccountModel?>(
                        selector: (context, provider) => provider.userAccount,
                        builder: (context, account, _) {
                          return Material(
                            color: Colors.transparent,
                            child: ListTile(
                              onTap: () {
                                if(account == null) {
                                  Navigator.pushNamed(context, Routes.signInWithPhoneNumberRoute);
                                }
                                else {
                                  Navigator.pushNamed(context, Routes.profileRoute);
                                }
                              },
                              leading: Image.asset(account == null ? ImagesManager.loginIc : ImagesManager.profileIc, fit: BoxFit.fill, color: ColorsManager.primaryColor, width: SizeManager.s20, height: SizeManager.s20),
                              title: Text(
                                Methods.getText(account == null ? StringsManager.login : StringsManager.profile, appProvider.isEnglish).toCapitalized(),
                                style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.greyColor),
                              ),
                              trailing: Transform(
                                alignment: FractionalOffset.center,
                                transform: Matrix4.rotationY(appProvider.isEnglish ? pi : 0),
                                child: SvgPicture.asset(ImagesManager.nextArrowIc, width: SizeManager.s20, height: SizeManager.s20),
                              ),
                              visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                              contentPadding: const EdgeInsets.symmetric(horizontal: SizeManager.s16, vertical: SizeManager.s8),
                            ),
                          );
                        },
                      ),
                      Selector<UserAccountProvider, UserAccountModel?>(
                        selector: (context, provider) => provider.userAccount,
                        builder: (context, account, _) {
                          return const Divider(color: ColorsManager.grey, height: SizeManager.s0);
                        },
                      ),

                      Material(
                        color: Colors.transparent,
                        child: ListTile(
                          onTap: () {
                            UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
                            if(userAccountProvider.userAccount == null) {
                              Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.youMustLoginFirstToAccessTheService, appProvider.isEnglish).toCapitalized()).then((value) async {
                                if(value) {Navigator.pushNamed(context, Routes.signInWithPhoneNumberRoute);}
                              });
                            }
                            else {
                              mainProvider.changeBottomNavigationBarIndex(2);
                            }
                          },
                          leading: Image.asset(ImagesManager.transactionIc, fit: BoxFit.fill, color: ColorsManager.primaryColor, width: SizeManager.s20, height: SizeManager.s20),
                          title: Text(
                            Methods.getText(StringsManager.myTransactions, appProvider.isEnglish).toCapitalized(),
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.greyColor),
                          ),
                          trailing: Transform(
                            alignment: FractionalOffset.center,
                            transform: Matrix4.rotationY(appProvider.isEnglish ? pi : 0),
                            child: SvgPicture.asset(ImagesManager.nextArrowIc, width: SizeManager.s20, height: SizeManager.s20),
                          ),
                          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                          contentPadding: const EdgeInsets.symmetric(horizontal: SizeManager.s16, vertical: SizeManager.s8),
                        ),
                      ),
                      const Divider(color: ColorsManager.grey, height: SizeManager.s0),
                      Material(
                        color: Colors.transparent,
                        child: ListTile(
                          onTap: () => Navigator.pushNamed(context, Routes.playlistsRoute),
                          leading: Image.asset(ImagesManager.playlistsIc, fit: BoxFit.fill, color: ColorsManager.primaryColor, width: SizeManager.s20, height: SizeManager.s20),
                          title: Text(
                            Methods.getText(StringsManager.playlists, appProvider.isEnglish).toCapitalized(),
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.greyColor),
                          ),
                          trailing: Transform(
                            alignment: FractionalOffset.center,
                            transform: Matrix4.rotationY(appProvider.isEnglish ? pi : 0),
                            child: SvgPicture.asset(ImagesManager.nextArrowIc, width: SizeManager.s20, height: SizeManager.s20),
                          ),
                          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                          contentPadding: const EdgeInsets.symmetric(horizontal: SizeManager.s16, vertical: SizeManager.s8),
                        ),
                      ),
                      const Divider(color: ColorsManager.grey, height: SizeManager.s0),
                      Material(
                        color: Colors.transparent,
                        child: ListTile(
                          onTap: () {
                            UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
                            if(userAccountProvider.userAccount == null) {
                              Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.youMustLoginFirstToAccessTheService, appProvider.isEnglish).toCapitalized()).then((value) async {
                                if(value) {Navigator.pushNamed(context, Routes.signInWithPhoneNumberRoute);}
                              });
                            }
                            else {
                              mainProvider.changeBottomNavigationBarIndex(3);
                            }
                          },
                          leading: Image.asset(ImagesManager.walletIc, fit: BoxFit.fill, color: ColorsManager.primaryColor, width: SizeManager.s20, height: SizeManager.s20),
                          title: Text(
                            Methods.getText(StringsManager.myWallet, appProvider.isEnglish).toCapitalized(),
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.greyColor),
                          ),
                          trailing: Transform(
                            alignment: FractionalOffset.center,
                            transform: Matrix4.rotationY(appProvider.isEnglish ? pi : 0),
                            child: SvgPicture.asset(ImagesManager.nextArrowIc, width: SizeManager.s20, height: SizeManager.s20),
                          ),
                          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                          contentPadding: const EdgeInsets.symmetric(horizontal: SizeManager.s16, vertical: SizeManager.s8),
                        ),
                      ),
                      const Divider(color: ColorsManager.grey, height: SizeManager.s0),
                      Material(
                        color: Colors.transparent,
                        child: ListTile(
                          onTap: () => Navigator.pushNamed(context, Routes.jobsRoute),
                          leading: Image.asset(ImagesManager.jobsIc, fit: BoxFit.fill, color: ColorsManager.primaryColor, width: SizeManager.s20, height: SizeManager.s20),
                          title: Text(
                            Methods.getText(StringsManager.jobs, appProvider.isEnglish).toCapitalized(),
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.greyColor),
                          ),
                          trailing: Transform(
                            alignment: FractionalOffset.center,
                            transform: Matrix4.rotationY(appProvider.isEnglish ? pi : 0),
                            child: SvgPicture.asset(ImagesManager.nextArrowIc, width: SizeManager.s20, height: SizeManager.s20),
                          ),
                          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                          contentPadding: const EdgeInsets.symmetric(horizontal: SizeManager.s16, vertical: SizeManager.s8),
                        ),
                      ),
                      const Divider(color: ColorsManager.grey, height: SizeManager.s0),
                      Material(
                        color: Colors.transparent,
                        child: ListTile(
                          onTap: () async {
                            Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.doYouWantToChangeTheLanguage, appProvider.isEnglish).toCapitalized()).then((value) async {
                              if(value) {
                                appProvider.changeIsEnglish(!appProvider.isEnglish);
                                CacheHelper.setData(key: PREFERENCES_KEY_IS_ENGLISH, value: appProvider.isEnglish);
                                Phoenix.rebirth(context);
                              }
                            });
                          },
                          leading: Image.asset(ImagesManager.languageIc, fit: BoxFit.fill, color: ColorsManager.primaryColor, width: SizeManager.s20, height: SizeManager.s20),
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                Methods.getText(StringsManager.language, appProvider.isEnglish).toCapitalized(),
                                style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.greyColor),
                              ),
                              Text(
                                Methods.getText(appProvider.isEnglish ? StringsManager.english : StringsManager.arabic, appProvider.isEnglish).toCapitalized(),
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ],
                          ),
                          trailing: Transform(
                            alignment: FractionalOffset.center,
                            transform: Matrix4.rotationY(appProvider.isEnglish ? pi : 0),
                            child: SvgPicture.asset(ImagesManager.nextArrowIc, width: SizeManager.s20, height: SizeManager.s20),
                          ),
                          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                          contentPadding: const EdgeInsets.symmetric(horizontal: SizeManager.s16, vertical: SizeManager.s8),
                        ),
                      ),
                      const Divider(color: ColorsManager.grey, height: SizeManager.s0),
                      Material(
                        color: Colors.transparent,
                        child: ListTile(
                          onTap: () {
                            UserAccountProvider userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
                            if(userAccountProvider.userAccount == null) {
                              Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.youMustLoginFirstToAccessTheService, appProvider.isEnglish).toCapitalized()).then((value) async {
                                if(value) {Navigator.pushNamed(context, Routes.signInWithPhoneNumberRoute);}
                              });
                            }
                            else {
                              Navigator.pushNamed(context, Routes.chatRoomRoute);
                            }
                          },
                          leading: Image.asset(ImagesManager.helpIc, fit: BoxFit.fill, color: ColorsManager.primaryColor, width: SizeManager.s20, height: SizeManager.s20),
                          title: Text(
                            Methods.getText(StringsManager.help, appProvider.isEnglish).toCapitalized(),
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.greyColor),
                          ),
                          trailing: Transform(
                            alignment: FractionalOffset.center,
                            transform: Matrix4.rotationY(appProvider.isEnglish ? pi : 0),
                            child: SvgPicture.asset(ImagesManager.nextArrowIc, width: SizeManager.s20, height: SizeManager.s20),
                          ),
                          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                          contentPadding: const EdgeInsets.symmetric(horizontal: SizeManager.s16, vertical: SizeManager.s8),
                        ),
                      ),
                      const Divider(color: ColorsManager.grey, height: SizeManager.s0),
                      Material(
                        color: Colors.transparent,
                        child: ListTile(
                          onTap: () => Methods.openUrl(Platform.isAndroid ? ConstantsManager.playStoreUrl : ConstantsManager.appStoreUrl),
                          leading: Image.asset(ImagesManager.evaluationIc, fit: BoxFit.fill, color: ColorsManager.primaryColor, width: SizeManager.s20, height: SizeManager.s20),
                          title: Text(
                            Methods.getText(StringsManager.applicationEvaluation, appProvider.isEnglish).toCapitalized(),
                            style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.greyColor),
                          ),
                          trailing: Transform(
                            alignment: FractionalOffset.center,
                            transform: Matrix4.rotationY(appProvider.isEnglish ? pi : 0),
                            child: SvgPicture.asset(ImagesManager.nextArrowIc, width: SizeManager.s20, height: SizeManager.s20),
                          ),
                          visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                          contentPadding: const EdgeInsets.symmetric(horizontal: SizeManager.s16, vertical: SizeManager.s8),
                        ),
                      ),
                      const Divider(color: ColorsManager.grey, height: SizeManager.s0),
                      Selector<UserAccountProvider, UserAccountModel?>(
                        selector: (context, provider) => provider.userAccount,
                        builder: (context, account, _) {
                          return account != null ? Material(
                            color: Colors.transparent,
                            child: ListTile(
                              onTap: () => Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.doYouWantToLogout, appProvider.isEnglish).toCapitalized()).then((value) {
                                if(value) Methods.logout(context);
                              }),
                              leading: Image.asset(ImagesManager.logoutIc, fit: BoxFit.fill, color: ColorsManager.primaryColor, width: SizeManager.s20, height: SizeManager.s20),
                              title: Text(
                                Methods.getText(StringsManager.logout, appProvider.isEnglish).toCapitalized(),
                                style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.greyColor),
                              ),
                              trailing: Transform(
                                alignment: FractionalOffset.center,
                                transform: Matrix4.rotationY(appProvider.isEnglish ? pi : 0),
                                child: SvgPicture.asset(ImagesManager.nextArrowIc, width: SizeManager.s20, height: SizeManager.s20),
                              ),
                              visualDensity: const VisualDensity(vertical: -4, horizontal: -4),
                              contentPadding: const EdgeInsets.symmetric(horizontal: SizeManager.s16, vertical: SizeManager.s8),
                            ),
                          ) : Container();
                        },
                      ),
                      Selector<UserAccountProvider, UserAccountModel?>(
                        selector: (context, provider) => provider.userAccount,
                        builder: (context, account, _) {
                          return account != null ? const Divider(color: ColorsManager.grey, height: SizeManager.s0) : Container();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: SizeManager.s16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () => Methods.openUrl(ConstantsManager.facebookUrl),
                      child: Image.asset(ImagesManager.facebookIc, width: SizeManager.s20, height: SizeManager.s20),
                    ),
                    // const SizedBox(width: SizeManager.s15),
                    // InkWell(
                    //   onTap: () => Methods.openUrl(ConstantsManager.instagramUrl),
                    //   child: Image.asset(ImagesManager.instagramIc, width: SizeManager.s20, height: SizeManager.s20),
                    // ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, Routes.termsOfUseRoute),
                      child: Text(
                        Methods.getText(StringsManager.termsOfUse, appProvider.isEnglish).toCapitalized(),
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorsManager.black, fontWeight: FontWeightManager.bold),
                      ),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, Routes.privacyPolicyRoute),
                      child: Text(
                        Methods.getText(StringsManager.privacyPolicy, appProvider.isEnglish).toCapitalized(),
                        style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorsManager.black, fontWeight: FontWeightManager.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      Methods.getText(StringsManager.appVersion, appProvider.isEnglish).toCapitalized(),
                    ),
                    const SizedBox(width: SizeManager.s3),
                    Text(
                      appProvider.version,
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.black),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}