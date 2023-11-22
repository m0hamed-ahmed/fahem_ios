import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/data/data_source/static/real_estate_legal_advice_on_boarding_data.dart';
import 'package:fahem/presentation/features/fahem_services/real_estate_legal_advice/controllers/real_estate_legal_advice_on_boarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RealEstateLegalAdviceBuildPageView extends StatefulWidget {

  const RealEstateLegalAdviceBuildPageView({super.key});

  @override
  State<RealEstateLegalAdviceBuildPageView> createState() => _RealEstateLegalAdviceBuildPageViewState();
}

class _RealEstateLegalAdviceBuildPageViewState extends State<RealEstateLegalAdviceBuildPageView> {
  late AppProvider appProvider;
  late RealEstateLegalAdviceOnBoardingProvider realEstateLegalAdviceOnBoardingProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    realEstateLegalAdviceOnBoardingProvider = Provider.of<RealEstateLegalAdviceOnBoardingProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<RealEstateLegalAdviceOnBoardingProvider, PageController>(
      selector: (context, provider) => provider.pageController,
      builder: (context, pageController, child) {
        return PageView.builder(
          controller: pageController,
          onPageChanged: (index) => realEstateLegalAdviceOnBoardingProvider.onPageChanged(index),
          itemCount: realEstateLegalAdviceOnBoardingData.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(SizeManager.s0),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(realEstateLegalAdviceOnBoardingData[index].image, width: SizeManager.s400, height: SizeManager.s400),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: SizeManager.s20),
                      FittedBox(
                        child: Text(
                          appProvider.isEnglish ? realEstateLegalAdviceOnBoardingData[index].titleEn : realEstateLegalAdviceOnBoardingData[index].titleAr,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeightManager.black, fontSize: SizeManager.s30),
                        ),
                      ),
                      const SizedBox(height: SizeManager.s20),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          appProvider.isEnglish ? realEstateLegalAdviceOnBoardingData[index].bodyEn : realEstateLegalAdviceOnBoardingData[index].bodyAr,
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