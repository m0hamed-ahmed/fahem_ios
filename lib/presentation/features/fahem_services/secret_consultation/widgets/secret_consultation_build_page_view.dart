import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/data/data_source/static/secret_lawyer_on_boarding_data.dart';
import 'package:fahem/presentation/features/fahem_services/secret_consultation/controllers/secret_consultation_on_boarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SecretConsultationPageView extends StatefulWidget {

  const SecretConsultationPageView({super.key});

  @override
  State<SecretConsultationPageView> createState() => _SecretConsultationPageViewState();
}

class _SecretConsultationPageViewState extends State<SecretConsultationPageView> {
  late AppProvider appProvider;
  late SecretConsultationOnBoardingProvider secretConsultationOnBoardingProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    secretConsultationOnBoardingProvider = Provider.of<SecretConsultationOnBoardingProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<SecretConsultationOnBoardingProvider, PageController>(
      selector: (context, provider) => provider.pageController,
      builder: (context, pageController, child) {
        return PageView.builder(
          controller: pageController,
          onPageChanged: (index) => secretConsultationOnBoardingProvider.onPageChanged(index),
          itemCount: secretLawyerOnBoardingData.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(SizeManager.s0),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(secretLawyerOnBoardingData[index].image, width: SizeManager.s400, height: SizeManager.s400),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: SizeManager.s20),
                      FittedBox(
                        child: Text(
                          appProvider.isEnglish ? secretLawyerOnBoardingData[index].titleEn : secretLawyerOnBoardingData[index].titleAr,
                          style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.black, fontSize: SizeManager.s30),
                        ),
                      ),
                      const SizedBox(height: SizeManager.s20),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          appProvider.isEnglish ? secretLawyerOnBoardingData[index].bodyEn : secretLawyerOnBoardingData[index].bodyAr,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}