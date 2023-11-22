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
import 'package:fahem/presentation/features/public_relations/public_relations/controllers/public_relations_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relations/widgets/public_relation_item.dart';
import 'package:fahem/presentation/features/public_relations/public_relations_categories/controllers/public_relations_categories_provider.dart';
import 'package:fahem/presentation/features/settings/controllers/settings_provider.dart';
import 'package:fahem/presentation/shared/background.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/custom_text_form_field.dart';
import 'package:fahem/presentation/shared/not_found_widget.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class PublicRelationsScreen extends StatefulWidget {
  final int publicRelationCategoryId;

  const PublicRelationsScreen({Key? key, required this.publicRelationCategoryId}) : super(key: key);

  @override
  State<PublicRelationsScreen> createState() => _PublicRelationsScreenState();
}

class _PublicRelationsScreenState extends State<PublicRelationsScreen> {
  late AppProvider appProvider;
  late PublicRelationsProvider publicRelationsProvider;
  late PublicRelationsCategoriesProvider publicRelationsCategoriesProvider;
  late SettingsProvider settingsProvider;
  final TextEditingController _textEditingControllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    publicRelationsProvider = Provider.of<PublicRelationsProvider>(context, listen: false);
    publicRelationsCategoriesProvider = Provider.of<PublicRelationsCategoriesProvider>(context, listen: false);
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    publicRelationsProvider.initScrollController();
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
              child: Consumer<PublicRelationsProvider>(
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
                                    Methods.getText(StringsManager.publicRelations, appProvider.isEnglish).toTitleCase(),
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeightManager.black),
                                  ),
                                  Text(
                                    appProvider.isEnglish ? publicRelationsCategoriesProvider.getPublicRelationCategoryWithId(widget.publicRelationCategoryId).nameEn : publicRelationsCategoriesProvider.getPublicRelationCategoryWithId(widget.publicRelationCategoryId).nameAr,
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
                                      provider.changeSelectedPublicRelations(provider.publicRelations.where((publicRelations) {
                                        double distanceKm = Geolocator.distanceBetween(value.latitude, value.longitude, publicRelations.latitude, publicRelations.longitude) / 1000;
                                        return publicRelations.categoriesIds.contains(widget.publicRelationCategoryId.toString())
                                            && distanceKm <= settingsProvider.settings.distanceKm;
                                      }).toList());
                                      provider.changeSelectedGovernmentModel(value);
                                    }
                                    else if(value.governoratesMode == GovernoratesMode.allGovernorates) {
                                      provider.changeSelectedPublicRelations(provider.publicRelations.where((publicRelations) {
                                        return publicRelations.categoriesIds.contains(widget.publicRelationCategoryId.toString());
                                      }).toList());
                                      provider.changeSelectedGovernmentModel(value);
                                    }
                                    else {
                                      provider.changeSelectedPublicRelations(provider.publicRelations.where((publicRelations) {
                                        return publicRelations.categoriesIds.contains(widget.publicRelationCategoryId.toString())
                                            && publicRelations.governorate == value.nameAr;
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
                          onChanged: (val) => provider.onChangeSearch(context, val.trim(), widget.publicRelationCategoryId),
                          prefixIcon: Image.asset(ImagesManager.searchOutlineIc, color: ColorsManager.primaryColor, width: SizeManager.s20, height: SizeManager.s20),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _textEditingControllerSearch.clear();
                              provider.onClearSearch(context, widget.publicRelationCategoryId);
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
                              '${provider.selectedPublicRelations.length} ${Methods.getText(StringsManager.result, appProvider.isEnglish)}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: SizeManager.s8),
                        Expanded(
                          child: provider.selectedPublicRelations.isEmpty ? const NotFoundWidget(text: StringsManager.nothing) : ListView.separated(
                            controller: provider.scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(top: SizeManager.s8, bottom: SizeManager.s16),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  PublicRelationItem(publicRelationModel: provider.selectedPublicRelations[index], index: index),
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
                                        if(!provider.hasMoreData && provider.selectedPublicRelations.length > provider.limit) Text(
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
    publicRelationsProvider.disposeScrollController();
    super.dispose();
  }
}