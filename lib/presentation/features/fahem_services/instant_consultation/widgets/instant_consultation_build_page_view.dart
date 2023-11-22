import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/data/data_source/static/instant_consultation_on_boarding_data.dart';
import 'package:fahem/presentation/features/fahem_services/instant_consultation/controllers/instant_consultation_on_boarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstantConsultationBuildPageView extends StatefulWidget {

  const InstantConsultationBuildPageView({super.key});

  @override
  State<InstantConsultationBuildPageView> createState() => _InstantConsultationBuildPageViewState();
}

class _InstantConsultationBuildPageViewState extends State<InstantConsultationBuildPageView> {
  late AppProvider appProvider;
  late InstantConsultationOnBoardingProvider instantConsultationOnBoardingProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    instantConsultationOnBoardingProvider = Provider.of<InstantConsultationOnBoardingProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<InstantConsultationOnBoardingProvider, PageController>(
      selector: (context, provider) => provider.pageController,
      builder: (context, pageController, child) {
        return PageView.builder(
          controller: pageController,
          onPageChanged: (index) => instantConsultationOnBoardingProvider.onPageChanged(index),
          itemCount: instantConsultationOnBoardingData.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(SizeManager.s0),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(instantConsultationOnBoardingData[index].image, width: SizeManager.s400, height: SizeManager.s400),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: SizeManager.s20),
                      FittedBox(
                        child: Text(
                          appProvider.isEnglish ? instantConsultationOnBoardingData[index].titleEn : instantConsultationOnBoardingData[index].titleAr,
                          style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.secondaryColor, fontWeight: FontWeightManager.black, fontSize: SizeManager.s30),
                        ),
                      ),
                      const SizedBox(height: SizeManager.s20),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          appProvider.isEnglish ? instantConsultationOnBoardingData[index].bodyEn : instantConsultationOnBoardingData[index].bodyAr,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
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