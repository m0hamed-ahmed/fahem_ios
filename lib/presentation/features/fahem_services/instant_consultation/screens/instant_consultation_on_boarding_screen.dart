import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/data_source/static/instant_consultation_on_boarding_data.dart';
import 'package:fahem/presentation/features/fahem_services/instant_consultation/controllers/instant_consultation_on_boarding_provider.dart';
import 'package:fahem/presentation/features/fahem_services/instant_consultation/widgets/instant_consultation_build_page_view.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstantConsultationOnBoardingScreen extends StatefulWidget {

  const InstantConsultationOnBoardingScreen({super.key});

  @override
  State<InstantConsultationOnBoardingScreen> createState() => _InstantConsultationOnBoardingScreenState();
}

class _InstantConsultationOnBoardingScreenState extends State<InstantConsultationOnBoardingScreen> {
  late AppProvider appProvider;
  late InstantConsultationOnBoardingProvider instantConsultationOnBoardingProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    instantConsultationOnBoardingProvider = Provider.of<InstantConsultationOnBoardingProvider>(context, listen: false);
    instantConsultationOnBoardingProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Methods.getDirection(appProvider.isEnglish),
      child: Scaffold(
        appBar: AppBar(
          leading: const Padding(
            padding: EdgeInsets.all(SizeManager.s10),
            child: PreviousButton(buttonColor: ColorsManager.secondaryColor),
          ),
          actions: [
            if(instantConsultationOnBoardingData.length > 1) Padding(
              padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
              child: TextButton(
                onPressed: () async => await instantConsultationOnBoardingProvider.skip(context),
                child: Text(
                  Methods.getText(StringsManager.skip, appProvider.isEnglish).toUpperCase(),
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.secondaryColor, fontWeight: FontWeightManager.black),
                ),
              ),
            ),
          ],
        ),
        body: const Padding(
          padding: EdgeInsets.all(SizeManager.s16),
          child: InstantConsultationBuildPageView(),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: SizeManager.s16),
          padding: const EdgeInsets.symmetric(horizontal: SizeManager.s32),
          width: double.infinity,
          height: SizeManager.s100,
          child: Selector<InstantConsultationOnBoardingProvider, int>(
            selector: (context, provider) => provider.currentPage,
            builder: (context, currentPage, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  instantConsultationOnBoardingData.length == 1 ? const SizedBox(height: SizeManager.s10) : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(instantConsultationOnBoardingData.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: ConstantsManager.onBoardingPageViewDuration),
                        margin: const EdgeInsets.only(right: SizeManager.s5),
                        width: currentPage == index ? SizeManager.s40 : SizeManager.s20,
                        height: SizeManager.s10,
                        decoration: BoxDecoration(
                          color: currentPage == index ? ColorsManager.secondaryColor : ColorsManager.grey1,
                          borderRadius: BorderRadius.circular(SizeManager.s10),
                        ),
                      );
                    }),
                  ),
                  CustomButton(
                    buttonType: ButtonType.text,
                    onPressed: () async => await instantConsultationOnBoardingProvider.next(context),
                    text: Methods.getText(currentPage == instantConsultationOnBoardingData.length-1 ? StringsManager.startNow : StringsManager.next, appProvider.isEnglish).toUpperCase(),
                    buttonColor: ColorsManager.secondaryColor,
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
    instantConsultationOnBoardingProvider.setCurrentPage(0);
    super.dispose();
  }
}