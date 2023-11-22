import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/data_source/static/secret_lawyer_on_boarding_data.dart';
import 'package:fahem/presentation/features/fahem_services/secret_consultation/controllers/secret_consultation_on_boarding_provider.dart';
import 'package:fahem/presentation/features/fahem_services/secret_consultation/widgets/secret_consultation_build_page_view.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecretConsultationOnBoardingScreen extends StatefulWidget {

  const SecretConsultationOnBoardingScreen({super.key});

  @override
  State<SecretConsultationOnBoardingScreen> createState() => _SecretConsultationOnBoardingScreenState();
}

class _SecretConsultationOnBoardingScreenState extends State<SecretConsultationOnBoardingScreen> {
  late AppProvider appProvider;
  late SecretConsultationOnBoardingProvider secretConsultationOnBoardingProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    secretConsultationOnBoardingProvider = Provider.of<SecretConsultationOnBoardingProvider>(context, listen: false);
    secretConsultationOnBoardingProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Methods.getDirection(appProvider.isEnglish),
      child: Scaffold(
        backgroundColor: ColorsManager.secondaryDarkColor,
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.all(SizeManager.s10),
            child: PreviousButton(buttonColor: ColorsManager.white, iconColor: ColorsManager.black),
          ),
          actions: [
            if(secretLawyerOnBoardingData.length > 1) Padding(
              padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
              child: TextButton(
                onPressed: () async => await secretConsultationOnBoardingProvider.skip(context),
                child: Text(
                  Methods.getText(StringsManager.skip, appProvider.isEnglish).toUpperCase(),
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.black),
                ),
              ),
            ),
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.all(SizeManager.s16),
          child: SecretConsultationPageView(),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: SizeManager.s16),
          padding: const EdgeInsets.symmetric(horizontal: SizeManager.s32),
          width: double.infinity,
          height: SizeManager.s100,
          child: Selector<SecretConsultationOnBoardingProvider, int>(
            selector: (context, provider) => provider.currentPage,
            builder: (context, currentPage, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  secretLawyerOnBoardingData.length == 1 ? const SizedBox(height: SizeManager.s10) : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(secretLawyerOnBoardingData.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: ConstantsManager.onBoardingPageViewDuration),
                        margin: const EdgeInsets.only(right: SizeManager.s5),
                        width: currentPage == index ? SizeManager.s40 : SizeManager.s20,
                        height: SizeManager.s10,
                        decoration: BoxDecoration(
                          color: currentPage == index ? ColorsManager.white : ColorsManager.black38,
                          borderRadius: BorderRadius.circular(SizeManager.s10),
                        ),
                      );
                    }),
                  ),
                  CustomButton(
                    buttonType: ButtonType.text,
                    onPressed: () async => await secretConsultationOnBoardingProvider.next(context),
                    text: Methods.getText(currentPage == secretLawyerOnBoardingData.length-1 ? StringsManager.startNow : StringsManager.next, appProvider.isEnglish).toUpperCase(),
                    buttonColor: ColorsManager.white,
                    textColor: ColorsManager.black,
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
    secretConsultationOnBoardingProvider.setCurrentPage(0);
    super.dispose();
  }
}