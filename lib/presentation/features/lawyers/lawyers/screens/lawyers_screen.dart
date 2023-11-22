import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/presentation/features/lawyers/lawyers/controllers/lawyers_provider.dart';
import 'package:fahem/presentation/features/lawyers/lawyers/widgets/lawyer_item.dart';
import 'package:fahem/presentation/features/lawyers/lawyers_categories/controllers/lawyers_categories_provider.dart';
import 'package:fahem/presentation/features/settings/controllers/settings_provider.dart';
import 'package:fahem/presentation/shared/background.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/custom_text_form_field.dart';
import 'package:fahem/presentation/shared/not_found_widget.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class LawyersScreen extends StatefulWidget {
  final int lawyersCategoryId;

  const LawyersScreen({super.key, required this.lawyersCategoryId});

  @override
  State<LawyersScreen> createState() => _LawyersScreenState();
}

class _LawyersScreenState extends State<LawyersScreen> {
  late AppProvider appProvider;
  late LawyersProvider lawyersProvider;
  late LawyersCategoriesProvider lawyersCategoriesProvider;
  late SettingsProvider settingsProvider;
  final TextEditingController _textEditingControllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    lawyersProvider = Provider.of<LawyersProvider>(context, listen: false);
    lawyersCategoriesProvider = Provider.of<LawyersCategoriesProvider>(context, listen: false);
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    lawyersProvider.initScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Directionality(
        textDirection: Methods.getDirection(appProvider.isEnglish),
        child: Scaffold(
          body: Background(
            child: SafeArea(
              child: Consumer<LawyersProvider>(
                builder: (context, provider, _) {
                  return Padding(
                    padding: const EdgeInsets.only(top: SizeManager.s16, left: SizeManager.s16, right: SizeManager.s16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const PreviousButton(),
                            const SizedBox(width: SizeManager.s20),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Methods.getText(StringsManager.theLawyers, appProvider.isEnglish).toTitleCase(),
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeightManager.black),
                                  ),
                                  Text(
                                    appProvider.isEnglish ? lawyersCategoriesProvider.getLawyerCategoryWithId(widget.lawyersCategoryId).nameEn : lawyersCategoriesProvider.getLawyerCategoryWithId(widget.lawyersCategoryId).nameAr,
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: SizeManager.s5),
                            SizedBox(
                              width: SizeManager.s150,
                              child: CustomButton(
                                buttonType: ButtonType.preImage,
                                onPressed: () => Dialogs.showBottomSheetGovernorates(context: context).then((value) {
                                  if(value != null) {
                                    if(value.governoratesMode == GovernoratesMode.currentLocation) {
                                      provider.changeSelectedLawyers(provider.lawyers.where((lawyer) {
                                        double distanceKm = Geolocator.distanceBetween(value.latitude, value.longitude, lawyer.latitude, lawyer.longitude) / 1000;
                                        return lawyer.categoriesIds.contains(widget.lawyersCategoryId.toString())
                                            && distanceKm <= settingsProvider.settings.distanceKm;
                                      }).toList());
                                      provider.changeSelectedGovernmentModel(value);
                                    }
                                    else if(value.governoratesMode == GovernoratesMode.allGovernorates) {
                                      provider.changeSelectedLawyers(provider.lawyers.where((lawyer) {
                                        return lawyer.categoriesIds.contains(widget.lawyersCategoryId.toString());
                                      }).toList());
                                      provider.changeSelectedGovernmentModel(value);
                                    }
                                    else {
                                      provider.changeSelectedLawyers(provider.lawyers.where((lawyer) {
                                        return lawyer.categoriesIds.contains(widget.lawyersCategoryId.toString())
                                            && lawyer.governorate == value.nameAr;
                                      }).toList());
                                      provider.changeSelectedGovernmentModel(value);
                                    }
                                  }
                                }),
                                text: provider.selectedGovernmentModel == null
                                    ? Methods.getText(StringsManager.searchByLocation, appProvider.isEnglish).toTitleCase()
                                    : appProvider.isEnglish ? provider.selectedGovernmentModel!.nameEn : provider.selectedGovernmentModel!.nameAr,
                                textColor: ColorsManager.primaryColor,
                                imageName: ImagesManager.animatedMapIc,
                                imageColor: ColorsManager.primaryColor,
                                imageSize: SizeManager.s25,
                                width: null,
                                buttonColor: ColorsManager.white,
                                borderColor: ColorsManager.primaryColor,
                                height: SizeManager.s35,
                                borderRadius: SizeManager.s10,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: SizeManager.s16),
                        CustomTextFormField(
                          controller: _textEditingControllerSearch,
                          textInputAction: TextInputAction.search,
                          textDirection: Methods.getDirection(appProvider.isEnglish),
                          labelText: Methods.getText(StringsManager.searchByLawyerNameOrCaseType, appProvider.isEnglish).toCapitalized(),
                          onChanged: (val) => provider.onChangeSearch(context, val.trim(), widget.lawyersCategoryId),
                          prefixIcon: Image.asset(ImagesManager.searchOutlineIc, color: ColorsManager.primaryColor, width: SizeManager.s20, height: SizeManager.s20),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _textEditingControllerSearch.clear();
                              provider.onClearSearch(context, widget.lawyersCategoryId);
                            },
                            icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                          ),
                        ),
                        const SizedBox(height: SizeManager.s16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Methods.getText(StringsManager.results, appProvider.isEnglish).toCapitalized(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '${provider.selectedLawyers.length} ${Methods.getText(StringsManager.result, appProvider.isEnglish)}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: SizeManager.s8),
                        Expanded(
                          child: provider.selectedLawyers.isEmpty ? const NotFoundWidget(text: StringsManager.thereAreNoLawyers) : ListView.separated(
                            controller: provider.scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(top: SizeManager.s8, bottom: SizeManager.s16),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  LawyerItem(lawyerModel: provider.selectedLawyers[index], index: index),
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
                                        if(!provider.hasMoreData && provider.selectedLawyers.length > provider.limit) Text(
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
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingControllerSearch.dispose();
    lawyersProvider.disposeScrollController();
    super.dispose();
  }
}