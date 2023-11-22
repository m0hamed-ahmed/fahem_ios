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
import 'package:fahem/presentation/features/fahem_services/trademark_registration_and_intellectual_protection/controllers/trademark_registration_and_intellectual_protection_provider.dart';
import 'package:fahem/presentation/features/fahem_services/trademark_registration_and_intellectual_protection/widgets/trademark_registration_and_intellectual_protection_item.dart';
import 'package:fahem/presentation/features/lawyers/lawyers/controllers/lawyers_provider.dart';
import 'package:fahem/presentation/features/settings/controllers/settings_provider.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/not_found_widget.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class TrademarkRegistrationAndIntellectualProtectionScreen extends StatefulWidget {

  const TrademarkRegistrationAndIntellectualProtectionScreen({super.key});

  @override
  State<TrademarkRegistrationAndIntellectualProtectionScreen> createState() => _TrademarkRegistrationAndIntellectualProtectionScreenState();
}

class _TrademarkRegistrationAndIntellectualProtectionScreenState extends State<TrademarkRegistrationAndIntellectualProtectionScreen> {
  late AppProvider appProvider;
  late TrademarkRegistrationAndIntellectualProtectionProvider trademarkRegistrationAndIntellectualProtectionProvider;
  late LawyersProvider lawyersProvider;
  late SettingsProvider settingsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    trademarkRegistrationAndIntellectualProtectionProvider = Provider.of<TrademarkRegistrationAndIntellectualProtectionProvider>(context, listen: false);
    lawyersProvider = Provider.of<LawyersProvider>(context, listen: false);
    settingsProvider = Provider.of<SettingsProvider>(context, listen: false);

    trademarkRegistrationAndIntellectualProtectionProvider.setTrademarkRegistrationAndIntellectualProtection(lawyersProvider.lawyers.where((element) {
      double distanceKm = Geolocator.distanceBetween(trademarkRegistrationAndIntellectualProtectionProvider.myCurrentPositionLatitude, trademarkRegistrationAndIntellectualProtectionProvider.myCurrentPositionLongitude, element.latitude, element.longitude)/1000;
      return element.isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ && distanceKm <= settingsProvider.settings.distanceKm;
    }).toList());
    trademarkRegistrationAndIntellectualProtectionProvider.initScrollController();
    trademarkRegistrationAndIntellectualProtectionProvider.showDataInList(isResetData: true, isRefresh: false, isScrollUp: false);

    trademarkRegistrationAndIntellectualProtectionProvider.setMakers({
      Marker(
        markerId: const MarkerId('1'),
        position: LatLng(trademarkRegistrationAndIntellectualProtectionProvider.myCurrentPositionLatitude, trademarkRegistrationAndIntellectualProtectionProvider.myCurrentPositionLongitude),
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Methods.getDirection(appProvider.isEnglish),
      child: Scaffold(
        body: SafeArea(
          child: Consumer<TrademarkRegistrationAndIntellectualProtectionProvider>(
            builder: (context, provider, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Center(
                        child: SizedBox(
                          width: SizeManager.s150,
                          child: CustomButton(
                            buttonType: ButtonType.preImage,
                            onPressed: () => Dialogs.showBottomSheetGovernorates(context: context).then((value) {
                              if(value != null) {
                                if(value.governoratesMode == GovernoratesMode.currentLocation) {
                                  provider.changeTrademarkRegistrationAndIntellectualProtection(lawyersProvider.lawyers.where((element) {
                                    double distanceKm = Geolocator.distanceBetween(provider.myCurrentPositionLatitude, provider.myCurrentPositionLongitude, element.latitude, element.longitude)/1000;
                                    return element.isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ
                                        && distanceKm <= settingsProvider.settings.distanceKm;
                                  }).toList());
                                  provider.changeSelectedGovernmentModel(value);
                                }
                                else if(value.governoratesMode == GovernoratesMode.allGovernorates) {
                                  provider.changeTrademarkRegistrationAndIntellectualProtection(lawyersProvider.lawyers.where((element) {
                                    return element.isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ;
                                  }).toList());
                                  provider.changeSelectedGovernmentModel(value);
                                }
                                else {
                                  provider.changeTrademarkRegistrationAndIntellectualProtection(lawyersProvider.lawyers.where((element) {
                                    return element.isSubscriberToTrademarkRegistrationAndIntellectualProtectionServ
                                        && element.governorate == value.nameAr;
                                  }).toList());
                                  provider.changeSelectedGovernmentModel(value);
                                }
                              }
                            }),
                            text: appProvider.isEnglish ? provider.selectedGovernmentModel.nameEn : provider.selectedGovernmentModel.nameAr,
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
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: SizeManager.s10),
                        child: PreviousButton(),
                      ),
                    ],
                  ),
                  const SizedBox(height: SizeManager.s10),
                  if(provider.trademarkRegistrationAndIntellectualProtection.isNotEmpty) SizedBox(
                    height: SizeManager.s300,
                    child: GoogleMap(
                      onMapCreated: (GoogleMapController controller) => provider.googleMapController = controller,
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(provider.selectedGovernmentModel.latitude, provider.selectedGovernmentModel.longitude),
                        zoom: 17,
                      ),
                      markers: provider.markers,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: SizeManager.s16, left: SizeManager.s16, right: SizeManager.s16, bottom: SizeManager.s8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          Methods.getText(StringsManager.atYourService, appProvider.isEnglish).toTitleCase(),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s20, fontWeight: FontWeightManager.black),
                        ),
                        Text(
                          '${provider.trademarkRegistrationAndIntellectualProtection.length} ${Methods.getText(StringsManager.result, appProvider.isEnglish)}',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: provider.trademarkRegistrationAndIntellectualProtection.isEmpty ? const NotFoundWidget(text: StringsManager.thereAreNoResults) : ListView.separated(
                      controller: provider.scrollController,
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.only(top: SizeManager.s8, left: SizeManager.s16, right: SizeManager.s16, bottom: SizeManager.s16),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            TrademarkRegistrationAndIntellectualProtectionItem(lawyerModel: provider.trademarkRegistrationAndIntellectualProtection[index]),
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
                                  if(!provider.hasMoreData && provider.trademarkRegistrationAndIntellectualProtection.length > provider.limit) Text(
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
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    try {trademarkRegistrationAndIntellectualProtectionProvider.googleMapController.dispose();} catch(error) {debugPrint(error.toString());}
    trademarkRegistrationAndIntellectualProtectionProvider.disposeScrollController();
    super.dispose();
  }
}