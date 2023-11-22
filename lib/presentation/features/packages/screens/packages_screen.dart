import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/presentation/features/packages/controllers/packages_provider.dart';
import 'package:fahem/presentation/features/packages/widgets/package_item.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem/presentation/shared/background.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/not_found_widget.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PackagesScreen extends StatefulWidget {

  const PackagesScreen({super.key});

  @override
  State<PackagesScreen> createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  late AppProvider appProvider;
  late PackagesProvider packagesProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    packagesProvider = Provider.of<PackagesProvider>(context, listen: false);

    packagesProvider.initScrollController();
    packagesProvider.showDataInList(isResetData: true, isRefresh: false, isScrollUp: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<PackagesProvider, bool>(
      selector: (context, provider) => provider.isLoading,
      builder: (context, isLoading, _) {
        return AbsorbPointerWidget(
          absorbing: isLoading,
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: WillPopScope(
              onWillPop: () => isLoading ? Future.value(false) : packagesProvider.onBackPressed(context),
              child: Directionality(
                textDirection: Methods.getDirection(appProvider.isEnglish),
                child: Scaffold(
                  body: Background(
                    child: SafeArea(
                      child: Consumer<PackagesProvider>(
                        builder: (context, provider, _) {
                          return Padding(
                            padding: const EdgeInsets.only(top: SizeManager.s16, left: SizeManager.s16, right: SizeManager.s16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    PreviousButton(
                                      onBackPressed: () {
                                        packagesProvider.onBackPressed(context);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    const SizedBox(width: SizeManager.s20),
                                    Flexible(
                                      child: Column(
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
                                    ),
                                  ],
                                ),
                                const SizedBox(height: SizeManager.s20),
                                Text(
                                  Methods.getText(StringsManager.chooseYourPreferredPackage, appProvider.isEnglish).toCapitalized(),
                                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s24, fontWeight: FontWeightManager.black),
                                ),
                                const SizedBox(height: SizeManager.s8),
                                Expanded(
                                  child: provider.packages.isEmpty ? const NotFoundWidget(text: StringsManager.noPackagesFound) : ListView.separated(
                                    controller: provider.scrollController,
                                    physics: const BouncingScrollPhysics(),
                                    padding: const EdgeInsets.only(top: SizeManager.s8),
                                    itemBuilder: (context, index) {
                                      return Column(
                                        children: [
                                          PackageItem(packageModel: packagesProvider.packages[index], index: index),
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
                                                if(!provider.hasMoreData && provider.packages.length > provider.limit) Text(
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
                                Container(
                                  margin: const EdgeInsets.symmetric(vertical: SizeManager.s16),
                                  child: IgnorePointer(
                                    ignoring: provider.selectedPackage == null,
                                    child: Opacity(
                                      opacity: provider.selectedPackage != null ? 1 : 0.5,
                                      child: CustomButton(
                                        buttonType: ButtonType.text,
                                        onPressed: () => packagesProvider.onPressedPayNow(context),
                                        text: Methods.getText(StringsManager.payNow, appProvider.isEnglish).toUpperCase(),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    packagesProvider.disposeScrollController();
    super.dispose();
  }
}