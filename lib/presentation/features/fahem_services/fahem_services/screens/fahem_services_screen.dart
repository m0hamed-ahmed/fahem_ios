import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/data_source/static/fahem_services_data.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FahemServicesScreen extends StatefulWidget {

  const FahemServicesScreen({super.key});

  @override
  State<FahemServicesScreen> createState() => _FahemServicesScreenState();
}

class _FahemServicesScreenState extends State<FahemServicesScreen> {
  late AppProvider appProvider;
  late UserAccountProvider userAccountProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Methods.getDirection(appProvider.isEnglish),
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    ImagesManager.fahemServices,
                    width: double.infinity,
                    height: SizeManager.s250,
                    fit: BoxFit.fill,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeManager.s16, vertical: SizeManager.s50),
                    child: PreviousButton(),
                  ),
                ],
              ),
              Container(
                color: ColorsManager.white,
                child: Transform.translate(
                  offset: const Offset(SizeManager.s0, -30),
                  child: Container(
                    padding: const EdgeInsets.only(left: SizeManager.s16, right: SizeManager.s16, top: SizeManager.s32),
                    decoration: const BoxDecoration(
                      color: ColorsManager.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(SizeManager.s30),
                        topRight: Radius.circular(SizeManager.s30),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Methods.getText(StringsManager.fahemServices, appProvider.isEnglish).toTitleCase(),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s24, fontWeight: FontWeightManager.black),
                        ),
                        const SizedBox(height: SizeManager.s10),
                        Text(
                          Methods.getText(StringsManager.fahemServicesAreServicesFromUsToYouToFacilitateAnyLegalNattersYouNeed, appProvider.isEnglish).toCapitalized(),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s18),
                        ),
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) => Container(
                            height: SizeManager.s80,
                            decoration: BoxDecoration(
                              color: index % 2 == 0 ? ColorsManager.primaryColor : ColorsManager.secondaryColor,
                              borderRadius: BorderRadius.circular(SizeManager.s10),
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () async {
                                  if(userAccountProvider.userAccount == null) {
                                    Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.youMustLoginFirstToAccessTheService, appProvider.isEnglish).toCapitalized()).then((value) async {
                                      if(value) {Navigator.pushNamed(context, Routes.signInWithPhoneNumberRoute);}
                                    });
                                  }
                                  else {
                                    if(fahemServicesData[index].fahemServiceType == FahemServiceType.instantLawyer) {
                                      // Navigator.pushNamed(context, CacheHelper.getData(key: PREFERENCES_KEY_IS_FIRST_OPEN_INSTANTS_LAWYERS) ?? true ? Routes.instantLawyersOnBoardingRoute : Routes.serviceLocationRoute);
                                      Navigator.pushNamed(context, Routes.instantLawyersOnBoardingRoute);
                                    }
                                    else if(fahemServicesData[index].fahemServiceType == FahemServiceType.instantConsultation) {
                                      // Navigator.pushNamed(context, CacheHelper.getData(key: PREFERENCES_KEY_IS_FIRST_OPEN_INSTANTS_CONSULTATION) ?? true ? Routes.instantConsultationOnBoardingRoute : Routes.instantConsultationFormRoute);
                                      Navigator.pushNamed(context, Routes.instantConsultationOnBoardingRoute);
                                    }
                                    else if(fahemServicesData[index].fahemServiceType == FahemServiceType.secretConsultation) {
                                      // Navigator.pushNamed(context, CacheHelper.getData(key: PREFERENCES_KEY_IS_FIRST_OPEN_SECRET_LAWYER) ?? true ? Routes.secretConsultationOnBoardingRoute : Routes.secretConsultationFormRoute);
                                      Navigator.pushNamed(context, Routes.secretConsultationOnBoardingRoute);
                                    }
                                    else if(fahemServicesData[index].fahemServiceType == FahemServiceType.debtCollection) {
                                      // Navigator.pushNamed(context, CacheHelper.getData(key: PREFERENCES_KEY_IS_FIRST_OPEN_DEBT_COLLECTION) ?? true ? Routes.debtCollectionOnBoardingRoute : Routes.serviceLocationRoute);
                                      Navigator.pushNamed(context, Routes.debtCollectionOnBoardingRoute);
                                    }
                                    else if(fahemServicesData[index].fahemServiceType == FahemServiceType.establishingCompanies) {
                                      // Navigator.pushNamed(context, CacheHelper.getData(key: PREFERENCES_KEY_IS_FIRST_OPEN_ESTABLISHING_COMPANIES) ?? true ? Routes.establishingCompaniesOnBoardingRoute : Routes.serviceLocationRoute);
                                      Navigator.pushNamed(context, Routes.establishingCompaniesOnBoardingRoute);
                                    }
                                    else if(fahemServicesData[index].fahemServiceType == FahemServiceType.realEstateLegalAdvice) {
                                      // Navigator.pushNamed(context, CacheHelper.getData(key: PREFERENCES_KEY_IS_FIRST_OPEN_REAL_ESTATE_LEGAL_ADVICE) ?? true ? Routes.realEstateLegalAdviceOnBoardingRoute : Routes.serviceLocationRoute);
                                      Navigator.pushNamed(context, Routes.realEstateLegalAdviceOnBoardingRoute);
                                    }
                                    else if(fahemServicesData[index].fahemServiceType == FahemServiceType.investmentLegalAdvice) {
                                      // Navigator.pushNamed(context, CacheHelper.getData(key: PREFERENCES_KEY_IS_FIRST_OPEN_INVESTMENT_LEGAL_ADVICE) ?? true ? Routes.investmentLegalAdviceOnBoardingRoute : Routes.serviceLocationRoute);
                                      Navigator.pushNamed(context, Routes.investmentLegalAdviceOnBoardingRoute);
                                    }
                                    else if(fahemServicesData[index].fahemServiceType == FahemServiceType.trademarkRegistrationAndIntellectualProtection) {
                                      // Navigator.pushNamed(context, CacheHelper.getData(key: PREFERENCES_KEY_IS_FIRST_OPEN_TRADEMARK_REGISTRATION_AND_INTELLECTUAL_PROTECTION) ?? true ? Routes.trademarkRegistrationAndIntellectualProtectionOnBoardingRoute : Routes.serviceLocationRoute);
                                      Navigator.pushNamed(context, Routes.trademarkRegistrationAndIntellectualProtectionOnBoardingRoute);
                                    }
                                  }
                                },
                                borderRadius: BorderRadius.circular(SizeManager.s10),
                                child: Padding(
                                  padding: const EdgeInsets.all(SizeManager.s10),
                                  child: Center(
                                    child: Text(
                                      appProvider.isEnglish ? fahemServicesData[index].nameEn : fahemServicesData[index].nameAr,
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.white, fontSize: SizeManager.s18, fontWeight: FontWeightManager.black),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ),
                          separatorBuilder: (context, index) => const SizedBox(height: SizeManager.s10),
                          itemCount: fahemServicesData.length,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}