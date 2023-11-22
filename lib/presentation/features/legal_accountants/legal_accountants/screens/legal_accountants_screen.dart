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
import 'package:fahem/presentation/features/legal_accountants/legal_accountants/controllers/legal_accountants_provider.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountants/widgets/legal_accountant_item.dart';
import 'package:fahem/presentation/features/settings/controllers/settings_provider.dart';
import 'package:fahem/presentation/shared/background.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/custom_text_form_field.dart';
import 'package:fahem/presentation/shared/not_found_widget.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class LegalAccountantsScreen extends StatefulWidget {

  const LegalAccountantsScreen({super.key});

  @override
  State<LegalAccountantsScreen> createState() => _LegalAccountantsScreenState();
}

class _LegalAccountantsScreenState extends State<LegalAccountantsScreen> {
  late AppProvider appProvider;
  late LegalAccountantsProvider legalAccountantsProvider;
  late SettingsProvider settingsProvider;
  final TextEditingController _textEditingControllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    legalAccountantsProvider = Provider.of<LegalAccountantsProvider>(context, listen: false);
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    legalAccountantsProvider.initScrollController();
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
              child: Consumer<LegalAccountantsProvider>(
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
                              child: Text(
                                Methods.getText(StringsManager.legalAccountants, appProvider.isEnglish).toTitleCase(),
                                style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                              ),
                            ),
                            SizedBox(
                              width: SizeManager.s150,
                              child: CustomButton(
                                buttonType: ButtonType.preImage,
                                onPressed: () => Dialogs.showBottomSheetGovernorates(context: context).then((value) {
                                  if(value != null) {
                                    if(value.governoratesMode == GovernoratesMode.currentLocation) {
                                      provider.changeSelectedLegalAccountants(provider.legalAccountants.where((legalAccountants) {
                                        double distanceKm = Geolocator.distanceBetween(value.latitude, value.longitude, legalAccountants.latitude, legalAccountants.longitude) / 1000;
                                        return distanceKm <= settingsProvider.settings.distanceKm;
                                      }).toList());
                                      provider.changeSelectedGovernmentModel(value);
                                    }
                                    else if(value.governoratesMode == GovernoratesMode.allGovernorates) {
                                      provider.changeSelectedLegalAccountants(provider.legalAccountants);
                                      provider.changeSelectedGovernmentModel(value);
                                    }
                                    else {
                                      provider.changeSelectedLegalAccountants(provider.legalAccountants.where((legalAccountants) {
                                        return legalAccountants.governorate == value.nameAr;
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
                          labelText: Methods.getText(StringsManager.searchByNameOrSpecialty, appProvider.isEnglish).toCapitalized(),
                          onChanged: (val) => provider.onChangeSearch(context, val.trim()),
                          prefixIcon: Image.asset(ImagesManager.searchOutlineIc, color: ColorsManager.primaryColor, width: SizeManager.s20, height: SizeManager.s20),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _textEditingControllerSearch.clear();
                              provider.onClearSearch(context);
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
                              '${provider.selectedLegalAccountants.length} ${Methods.getText(StringsManager.result, appProvider.isEnglish)}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: SizeManager.s8),
                        Expanded(
                          child: provider.selectedLegalAccountants.isEmpty ? const NotFoundWidget(text: StringsManager.thereAreNoAccountants) : ListView.separated(
                            controller: provider.scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(top: SizeManager.s8, bottom: SizeManager.s16),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  LegalAccountantItem(legalAccountantModel: provider.selectedLegalAccountants[index], index: index),
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
                                        if(!provider.hasMoreData && provider.selectedLegalAccountants.length > provider.limit) Text(
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
    legalAccountantsProvider.disposeScrollController();
    super.dispose();
  }
}