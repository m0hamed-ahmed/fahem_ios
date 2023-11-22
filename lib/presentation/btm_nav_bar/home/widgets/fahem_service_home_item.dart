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
import 'package:fahem/data/models/static/fahem_service_model.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FahemServiceHomeItem extends StatefulWidget {
  final FahemServiceModel fahemServiceModel;
  final int index;

  const FahemServiceHomeItem({super.key, required this.fahemServiceModel, required this.index});

  @override
  State<FahemServiceHomeItem> createState() => _FahemServiceHomeItemState();
}

class _FahemServiceHomeItemState extends State<FahemServiceHomeItem> {
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
    return Container(
      width: SizeManager.s250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeManager.s20),
      ),
      child: InkWell(
        onTap: () async {
          if(userAccountProvider.userAccount == null) {
            Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.youMustLoginFirstToAccessTheService, appProvider.isEnglish).toCapitalized()).then((value) async {
              if(value) {Navigator.pushNamed(context, Routes.signInWithPhoneNumberRoute);}
            });
          }
          else {
            if(widget.fahemServiceModel.fahemServiceType == FahemServiceType.instantLawyer) {
              // Navigator.pushNamed(context, CacheHelper.getData(key: PREFERENCES_KEY_IS_FIRST_OPEN_INSTANTS_LAWYERS) ?? true ? Routes.instantLawyersOnBoardingRoute : Routes.serviceLocationRoute);
              Navigator.pushNamed(context, Routes.instantLawyersOnBoardingRoute);
            }
            else if(widget.fahemServiceModel.fahemServiceType == FahemServiceType.instantConsultation) {
              // Navigator.pushNamed(context, CacheHelper.getData(key: PREFERENCES_KEY_IS_FIRST_OPEN_INSTANTS_CONSULTATION) ?? true ? Routes.instantConsultationOnBoardingRoute : Routes.instantConsultationFormRoute);
              Navigator.pushNamed(context, Routes.instantConsultationOnBoardingRoute);
            }
            else if(widget.fahemServiceModel.fahemServiceType == FahemServiceType.secretConsultation) {
              // Navigator.pushNamed(context, CacheHelper.getData(key: PREFERENCES_KEY_IS_FIRST_OPEN_SECRET_LAWYER) ?? true ? Routes.secretConsultationOnBoardingRoute : Routes.secretConsultationFormRoute);
              Navigator.pushNamed(context, Routes.secretConsultationOnBoardingRoute);
            }
            else if(widget.fahemServiceModel.fahemServiceType == FahemServiceType.establishingCompanies) {
              // Navigator.pushNamed(context, CacheHelper.getData(key: PREFERENCES_KEY_IS_FIRST_OPEN_ESTABLISHING_COMPANIES) ?? true ? Routes.establishingCompaniesOnBoardingRoute : Routes.serviceLocationRoute);
              Navigator.pushNamed(context, Routes.establishingCompaniesOnBoardingRoute);
            }
            else if(widget.fahemServiceModel.fahemServiceType == FahemServiceType.realEstateLegalAdvice) {
              // Navigator.pushNamed(context, CacheHelper.getData(key: PREFERENCES_KEY_IS_FIRST_OPEN_REAL_ESTATE_LEGAL_ADVICE) ?? true ? Routes.realEstateLegalAdviceOnBoardingRoute : Routes.serviceLocationRoute);
              Navigator.pushNamed(context, Routes.realEstateLegalAdviceOnBoardingRoute);
            }
            else if(widget.fahemServiceModel.fahemServiceType == FahemServiceType.investmentLegalAdvice) {
              // Navigator.pushNamed(context, CacheHelper.getData(key: PREFERENCES_KEY_IS_FIRST_OPEN_INVESTMENT_LEGAL_ADVICE) ?? true ? Routes.investmentLegalAdviceOnBoardingRoute : Routes.serviceLocationRoute);
              Navigator.pushNamed(context, Routes.investmentLegalAdviceOnBoardingRoute);
            }
            else if(widget.fahemServiceModel.fahemServiceType == FahemServiceType.trademarkRegistrationAndIntellectualProtection) {
              // Navigator.pushNamed(context, CacheHelper.getData(key: PREFERENCES_KEY_IS_FIRST_OPEN_TRADEMARK_REGISTRATION_AND_INTELLECTUAL_PROTECTION) ?? true ? Routes.trademarkRegistrationAndIntellectualProtectionOnBoardingRoute : Routes.serviceLocationRoute);
              Navigator.pushNamed(context, Routes.trademarkRegistrationAndIntellectualProtectionOnBoardingRoute);
            }
            else if(widget.fahemServiceModel.fahemServiceType == FahemServiceType.debtCollection) {
              // Navigator.pushNamed(context, CacheHelper.getData(key: PREFERENCES_KEY_IS_FIRST_OPEN_DEBT_COLLECTION) ?? true ? Routes.debtCollectionOnBoardingRoute : Routes.serviceLocationRoute);
              Navigator.pushNamed(context, Routes.debtCollectionOnBoardingRoute);
            }
          }
        },
        child: Stack(
          alignment: AlignmentDirectional.centerStart,
          children: [
            Image.asset(widget.fahemServiceModel.image, width: SizeManager.s250, fit: BoxFit.fill),
            Padding(
              padding: const EdgeInsets.all(SizeManager.s10),
              child: Text(
                appProvider.isEnglish ? widget.fahemServiceModel.nameEn : widget.fahemServiceModel.nameAr,
                style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}