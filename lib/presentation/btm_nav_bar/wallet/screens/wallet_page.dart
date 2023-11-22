import 'package:animate_do/animate_do.dart';
import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/presentation/features/logs/controllers/logs_provider.dart';
import 'package:fahem/presentation/features/logs/widgets/log_item.dart';
import 'package:fahem/presentation/features/packages/controllers/packages_provider.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/wallet/controllers/wallet_provider.dart';
import 'package:fahem/presentation/shared/absorb_pointer_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletPage extends StatefulWidget {

  const WalletPage({super.key});

  @override
  State<WalletPage> createState() => _WalletPageState();
}

class _WalletPageState extends State<WalletPage> {
  late AppProvider appProvider;
  late WalletProvider walletProvider;
  late PackagesProvider packagesProvider;
  late LogsProvider logsProvider;
  late UserAccountProvider userAccountProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    walletProvider = Provider.of<WalletProvider>(context, listen: false);
    packagesProvider = Provider.of<PackagesProvider>(context, listen: false);
    logsProvider = Provider.of<LogsProvider>(context, listen: false);
    userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);

    logsProvider.initScrollController();
    logsProvider.showDataInList(isResetData: true, isRefresh: false, isScrollUp: false);
  }

  @override
  Widget build(BuildContext context) {
    return FlipInY(
      duration: const Duration(seconds: 1),
      child: Selector<WalletProvider, bool>(
        selector: (context, provider) => provider.isLoading,
        builder: (context, isLoading, _) {
          return AbsorbPointerWidget(
            alignment: Alignment.topCenter,
            absorbing: isLoading,
            child: IgnorePointer(
              ignoring: isLoading,
              child: Padding(
                padding: const EdgeInsets.all(SizeManager.s16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Methods.getText(StringsManager.hello, appProvider.isEnglish).toTitleCase(),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.black),
                        ),
                        Selector<UserAccountProvider, UserAccountModel?>(
                          selector: (context, provider) => provider.userAccount,
                          builder: (context, account, _) {
                            return Text(
                              account == null ? Methods.getText(StringsManager.guest, appProvider.isEnglish).toCapitalized() : '${account.firstName} ${account.familyName}',
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: SizeManager.s20),

                    Text(
                      Methods.getText(StringsManager.myWallet, appProvider.isEnglish).toCapitalized(),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s24, fontWeight: FontWeightManager.black),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: SizeManager.s50,
                            padding: const EdgeInsets.all(SizeManager.s10),
                            decoration: BoxDecoration(
                              color: ColorsManager.primaryColor,
                              border: Border.all(color: ColorsManager.primaryColor),
                              borderRadius: const BorderRadiusDirectional.only(
                                topStart: Radius.circular(SizeManager.s10),
                                bottomStart: Radius.circular(SizeManager.s10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                Methods.getText(StringsManager.yourCurrentWalletBalance, appProvider.isEnglish).toCapitalized(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.black),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: SizeManager.s50,
                            padding: const EdgeInsets.all(SizeManager.s10),
                            decoration: BoxDecoration(
                              color: ColorsManager.white,
                              border: Border.all(color: ColorsManager.primaryColor),
                              borderRadius: const BorderRadiusDirectional.only(
                                topEnd: Radius.circular(SizeManager.s10),
                                bottomEnd: Radius.circular(SizeManager.s10),
                              ),
                            ),
                            child: Center(
                              child: Selector<WalletProvider, int>(
                                selector: (context, provider) =>  provider.wallet == null ? 0 : provider.wallet!.balance,
                                builder: (context, balance, child) {
                                  return Text(
                                    '$balance ${Methods.getText(StringsManager.egp, appProvider.isEnglish).toUpperCase()}',
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeightManager.black),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: SizeManager.s20),

                    if(false) Text(
                      Methods.getText(StringsManager.package, appProvider.isEnglish).toCapitalized(),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s24, fontWeight: FontWeightManager.black),
                    ),
                    if(false) Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: SizeManager.s50,
                            padding: const EdgeInsets.all(SizeManager.s10),
                            decoration: BoxDecoration(
                              color: ColorsManager.primaryColor,
                              border: Border.all(color: ColorsManager.primaryColor),
                              borderRadius: const BorderRadiusDirectional.only(
                                topStart: Radius.circular(SizeManager.s10),
                                bottomStart: Radius.circular(SizeManager.s10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                Methods.getText(StringsManager.yourPackage, appProvider.isEnglish).toCapitalized(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.black),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Selector<WalletProvider, int?>(
                            selector: (context, provider) => provider.wallet == null ? null : provider.wallet!.packageId,
                            builder: (context, packageId, child) {
                              return Container(
                                height: SizeManager.s50,
                                decoration: BoxDecoration(
                                  color: ColorsManager.white,
                                  border: Border.all(color: ColorsManager.primaryColor),
                                  borderRadius: const BorderRadiusDirectional.only(
                                    topEnd: Radius.circular(SizeManager.s10),
                                    bottomEnd: Radius.circular(SizeManager.s10),
                                  ),
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => packageId == null ? Navigator.pushNamed(context, Routes.packagesRoute) : null,
                                    borderRadius: BorderRadius.only(
                                      topLeft: appProvider.isEnglish ? Radius.zero : const Radius.circular(SizeManager.s10),
                                      topRight: appProvider.isEnglish ? const Radius.circular(SizeManager.s10) : Radius.zero,
                                      bottomLeft: appProvider.isEnglish ? Radius.zero : const Radius.circular(SizeManager.s10),
                                      bottomRight: appProvider.isEnglish ? const Radius.circular(SizeManager.s10) : Radius.zero,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(SizeManager.s10),
                                      child: Center(
                                        child: Text(
                                          packageId == null
                                              ? Methods.getText(StringsManager.chooseYourPackage, appProvider.isEnglish).toCapitalized()
                                              : appProvider.isEnglish ? packagesProvider.getPackageFromId(packageId).nameEn : packagesProvider.getPackageFromId(packageId).nameAr,
                                          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeightManager.black),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    if(false) const SizedBox(height: SizeManager.s20),

                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Dialogs.addMoneyToWallet(context: context),
                        child: Padding(
                          padding: const EdgeInsets.all(SizeManager.s8),
                          child: Row(
                            children: [
                              Container(
                                width: SizeManager.s25,
                                height: SizeManager.s25,
                                padding: const EdgeInsets.all(SizeManager.s8),
                                decoration: const BoxDecoration(
                                  color: ColorsManager.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(ImagesManager.addIc, color: ColorsManager.white),
                              ),
                              const SizedBox(width: SizeManager.s10),
                              Text(
                                Methods.getText(StringsManager.addMoneyToTheWallet, appProvider.isEnglish).toCapitalized(),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: SizeManager.s10),
                    if(false) Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => Navigator.pushNamed(context, Routes.packagesRoute),
                        child: Padding(
                          padding: const EdgeInsets.all(SizeManager.s8),
                          child: Row(
                            children: [
                              Container(
                                width: SizeManager.s25,
                                height: SizeManager.s25,
                                padding: const EdgeInsets.all(SizeManager.s5),
                                decoration: const BoxDecoration(
                                  color: ColorsManager.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Image.asset(ImagesManager.boxIc, color: ColorsManager.white),
                              ),
                              const SizedBox(width: SizeManager.s10),
                              Text(
                                Methods.getText(StringsManager.browseFahemPackages, appProvider.isEnglish).toCapitalized(),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if(false) const SizedBox(height: SizeManager.s20),

                    Text(
                      Methods.getText(StringsManager.logs, appProvider.isEnglish).toCapitalized(),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s24, fontWeight: FontWeightManager.black),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Consumer<LogsProvider>(
                            builder: (context, provider, __) {
                              return provider.logs.isEmpty ? Text(
                                Methods.getText(StringsManager.thereAreNoLogs, appProvider.isEnglish).toCapitalized(),
                                style: Theme.of(context).textTheme.displayLarge,
                              ) : Expanded(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: ColorsManager.black38,
                                    borderRadius: BorderRadius.circular(SizeManager.s10),
                                  ),
                                  child: ListView.separated(
                                    controller: provider.scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.all(SizeManager.s8),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          LogItem(logModel: provider.logs[index]),
                                          if(index == provider.numberOfItems-1) Padding(
                                            padding: const EdgeInsets.only(top: SizeManager.s16),
                                            child: Column(
                                              children: [
                                                if(provider.hasMoreData) const Center(
                                                  child: SizedBox(
                                                    width: SizeManager.s20,
                                                    height: SizeManager.s20,
                                                    child: CircularProgressIndicator(strokeWidth: SizeManager.s3, color: ColorsManager.primaryColor),
                                                  ),
                                                ),
                                                if(!provider.hasMoreData && provider.logs.length > provider.limit) Text(
                                                  Methods.getText(StringsManager.thereAreNoOtherResults, appProvider.isEnglish).toCapitalized(),
                                                  textAlign: TextAlign.center,
                                                  style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeightManager.black),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) => const SizedBox(height: SizeManager.s10),
                                    itemCount: provider.numberOfItems,
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    logsProvider.disposeScrollController();
    super.dispose();
  }
}