import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/data/data_source/static/instant_lawyer_on_boarding_data.dart';
import 'package:fahem/presentation/features/fahem_services/instant_lawyers/controllers/instant_lawyers_on_boarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstantLawyerBuildPageView extends StatefulWidget {

  const InstantLawyerBuildPageView({super.key});

  @override
  State<InstantLawyerBuildPageView> createState() => _InstantLawyerBuildPageViewState();
}

class _InstantLawyerBuildPageViewState extends State<InstantLawyerBuildPageView> {
  late AppProvider appProvider;
  late InstantLawyersOnBoardingProvider instantLawyersOnBoardingProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    instantLawyersOnBoardingProvider = Provider.of<InstantLawyersOnBoardingProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<InstantLawyersOnBoardingProvider, PageController>(
      selector: (context, provider) => provider.pageController,
      builder: (context, pageController, child) {
        return PageView.builder(
          controller: pageController,
          onPageChanged: (index) => instantLawyersOnBoardingProvider.onPageChanged(index),
          itemCount: instantLawyerOnBoardingData.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(SizeManager.s0),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(instantLawyerOnBoardingData[index].image, width: SizeManager.s400, height: SizeManager.s400),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: SizeManager.s20),
                      FittedBox(
                        child: Text(
                          appProvider.isEnglish ? instantLawyerOnBoardingData[index].titleEn : instantLawyerOnBoardingData[index].titleAr,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeightManager.black, fontSize: SizeManager.s30),
                        ),
                      ),
                      const SizedBox(height: SizeManager.s20),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          appProvider.isEnglish ? instantLawyerOnBoardingData[index].bodyEn : instantLawyerOnBoardingData[index].bodyAr,
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