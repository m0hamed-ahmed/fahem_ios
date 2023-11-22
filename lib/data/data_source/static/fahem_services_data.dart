import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/static/fahem_service_model.dart';

List<FahemServiceModel> fahemServicesData = [
  FahemServiceModel(
    fahemServiceType: FahemServiceType.instantLawyer,
    image: ImagesManager.services1,
    nameAr: Methods.getText(StringsManager.instantLawyer, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.instantLawyer, true).toTitleCase(),
    route: Routes.instantLawyersOnBoardingRoute,
  ),
  FahemServiceModel(
    fahemServiceType: FahemServiceType.instantConsultation,
    image: ImagesManager.services2,
    nameAr: Methods.getText(StringsManager.instantConsultation, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.instantConsultation, true).toTitleCase(),
    route: Routes.instantConsultationOnBoardingRoute,
  ),
  FahemServiceModel(
    fahemServiceType: FahemServiceType.secretConsultation,
    image: ImagesManager.services1,
    nameAr: Methods.getText(StringsManager.secretConsultation, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.secretConsultation, true).toTitleCase(),
    route: Routes.secretConsultationOnBoardingRoute,
  ),
  FahemServiceModel(
    fahemServiceType: FahemServiceType.debtCollection,
    image: ImagesManager.services2,
    nameAr: Methods.getText(StringsManager.debtCollection, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.debtCollection, true).toTitleCase(),
    route: Routes.debtCollectionRoute,
  ),
  FahemServiceModel(
    fahemServiceType: FahemServiceType.establishingCompanies,
    image: ImagesManager.services2,
    nameAr: Methods.getText(StringsManager.establishingCompanies, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.establishingCompanies, true).toTitleCase(),
    route: Routes.establishingCompaniesRoute,
  ),
  FahemServiceModel(
    fahemServiceType: FahemServiceType.realEstateLegalAdvice,
    image: ImagesManager.services1,
    nameAr: Methods.getText(StringsManager.realEstateLegalAdvice, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.realEstateLegalAdvice, true).toTitleCase(),
    route: Routes.realEstateLegalAdviceRoute,
  ),
  FahemServiceModel(
    fahemServiceType: FahemServiceType.investmentLegalAdvice,
    image: ImagesManager.services2,
    nameAr: Methods.getText(StringsManager.investmentLegalAdvice, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.investmentLegalAdvice, true).toTitleCase(),
    route: Routes.investmentLegalAdviceRoute,
  ),
  FahemServiceModel(
    fahemServiceType: FahemServiceType.trademarkRegistrationAndIntellectualProtection,
    image: ImagesManager.services1,
    nameAr: Methods.getText(StringsManager.trademarkRegistrationAndIntellectualProtection, false).toTitleCase(),
    nameEn: Methods.getText(StringsManager.trademarkRegistrationAndIntellectualProtection, true).toTitleCase(),
    route: Routes.trademarkRegistrationAndIntellectualProtectionRoute,
  ),
];