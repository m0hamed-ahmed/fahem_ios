import 'package:animate_do/animate_do.dart';
import 'package:fahem/core/network/api_constants.dart';
import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/lawyers/lawyers/lawyer_model.dart';
import 'package:fahem/presentation/features/fahem_services/establishing_companies/controllers/establishing_companies_provider.dart';
import 'package:fahem/presentation/shared/cached_network_image_widget.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vibration/vibration.dart';

class EstablishingCompanyItem extends StatefulWidget {
  final LawyerModel lawyerModel;

  const EstablishingCompanyItem({super.key, required this.lawyerModel});

  @override
  State<EstablishingCompanyItem> createState() => _EstablishingCompanyItemState();
}

class _EstablishingCompanyItemState extends State<EstablishingCompanyItem> {
  late AppProvider appProvider;
  late EstablishingCompaniesProvider establishingCompaniesProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    establishingCompaniesProvider = Provider.of<EstablishingCompaniesProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    double distanceKm = Geolocator.distanceBetween(establishingCompaniesProvider.myCurrentPositionLatitude, establishingCompaniesProvider.myCurrentPositionLongitude, widget.lawyerModel.latitude, widget.lawyerModel.longitude)/1000;
    String distance = distanceKm.toStringAsFixed(2).endsWith('0') ? distanceKm.toStringAsFixed(1) : distanceKm.toStringAsFixed(2);

    return Container(
      decoration: BoxDecoration(
        color: ColorsManager.white,
        borderRadius: BorderRadius.circular(SizeManager.s10),
        boxShadow: [
          BoxShadow(
            color: ColorsManager.grey.withOpacity(0.2),
            spreadRadius: SizeManager.s5,
            blurRadius: SizeManager.s5,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(SizeManager.s10),
          onTap: () {
           establishingCompaniesProvider.googleMapController.animateCamera(CameraUpdate.newLatLng(LatLng(widget.lawyerModel.latitude, widget.lawyerModel.longitude)));
           establishingCompaniesProvider.changeMakers({
             Marker(
               markerId: const MarkerId('1'),
               position: LatLng(widget.lawyerModel.latitude, widget.lawyerModel.longitude),
             ),
           });
         },
          child: Padding(
            padding: const EdgeInsets.all(SizeManager.s10),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, Routes.showFullImageRoute, arguments: {ConstantsManager.imageArgument: widget.lawyerModel.personalImage, ConstantsManager.directoryArgument: ApiConstants.lawyersDirectory}),
                      child: SizedBox(
                        width: SizeManager.s80,
                        height: SizeManager.s80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(SizeManager.s40),
                          child: CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${ApiConstants.lawyersDirectory}/${widget.lawyerModel.personalImage}')),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: SizeManager.s10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.lawyerModel.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.black),
                            ),
                            Text(
                              widget.lawyerModel.jobTitle,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox(height: SizeManager.s5),
                            Text(
                              '${Methods.getText(StringsManager.consultationPrice, appProvider.isEnglish).toCapitalized()}: ${widget.lawyerModel.consultationPrice} ${Methods.getText(StringsManager.egyptianPound, appProvider.isEnglish).toUpperCase()}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              '${Methods.getText(StringsManager.government, appProvider.isEnglish).toCapitalized()}: ${widget.lawyerModel.governorate}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              appProvider.isEnglish ? '$distance km away' : 'يبعد عن موقعك مسافة $distance كم',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flash(
                      duration: const Duration(seconds: 5),
                      infinite: true,
                      child: GestureDetector(
                        onTap: () async {
                          await Vibration.hasVibrator().then((hasVibrator) {
                            if(hasVibrator != null && hasVibrator) {
                              Vibration.vibrate(duration: 100);
                            }
                            Dialogs.onPressedCallNow(
                              context: context,
                              title: Methods.getText(StringsManager.pleaseEnterYourDataToShowTheLawyerNumber, appProvider.isEnglish).toCapitalized(),
                              targetId: widget.lawyerModel.lawyerId,
                              textAr: 'تم طلب رقم هاتف المحامي ${widget.lawyerModel.name}',
                              textEn: 'Lawyer ${widget.lawyerModel.name} phone number has been requested',
                              transactionType: TransactionType.showLawyerNumber,
                              targetNumberText: Methods.getText(StringsManager.lawyerNumber, appProvider.isEnglish).toTitleCase(),
                              model: widget.lawyerModel,
                            );
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.all(SizeManager.s3),
                          decoration: BoxDecoration(
                            color: ColorsManager.callNowColor1,
                            borderRadius: BorderRadius.circular(SizeManager.s5),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(SizeManager.s3),
                            decoration: BoxDecoration(
                              color: ColorsManager.callNowColor2,
                              borderRadius: BorderRadius.circular(SizeManager.s5),
                            ),
                            child: Container(
                              padding: const EdgeInsets.all(SizeManager.s3),
                              decoration: BoxDecoration(
                                color: ColorsManager.callNowColor3,
                                borderRadius: BorderRadius.circular(SizeManager.s5),
                              ),
                              child: Row(
                                children: [
                                  Text(
                                    Methods.getText(StringsManager.callNow, appProvider.isEnglish).toUpperCase(),
                                    style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.white),
                                  ),
                                  const SizedBox(width: SizeManager.s5),
                                  const Icon(Icons.phone, color: ColorsManager.white, size: SizeManager.s16),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: SizeManager.s10),
                Row(
                  children: [
                    Expanded(
                      child: CustomButton(
                        buttonType: ButtonType.postImage,
                        onPressed: () => Navigator.pushNamed(context, Routes.lawyerDetailsRoute, arguments: {ConstantsManager.lawyerModelArgument: widget.lawyerModel}),
                        text: Methods.getText(StringsManager.viewProfile, appProvider.isEnglish).toTitleCase(),
                        imageName: ImagesManager.profileIc,
                        imageColor: ColorsManager.white,
                        height: SizeManager.s35,
                        borderRadius: SizeManager.s10,
                      ),
                    ),
                    const SizedBox(width: SizeManager.s5),
                    Expanded(
                      child: CustomButton(
                        buttonType: ButtonType.postImage,
                        onPressed: () {
                          establishingCompaniesProvider.googleMapController.animateCamera(CameraUpdate.newLatLng(LatLng(widget.lawyerModel.latitude, widget.lawyerModel.longitude)));
                          establishingCompaniesProvider.changeMakers({
                            Marker(
                              markerId: const MarkerId('1'),
                              position: LatLng(widget.lawyerModel.latitude, widget.lawyerModel.longitude),
                            ),
                          });
                        },
                        text: Methods.getText(StringsManager.showOnMap, appProvider.isEnglish).toTitleCase(),
                        imageName: ImagesManager.mapIc,
                        imageColor: ColorsManager.white,
                        height: SizeManager.s35,
                        borderRadius: SizeManager.s10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}