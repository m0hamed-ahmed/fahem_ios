import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/data/data_source/static/investment_legal_advice_on_boarding_data.dart';
import 'package:fahem/presentation/features/fahem_services/investment_legal_advice/controllers/investment_legal_advice_on_boarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InvestmentLegalAdviceBuildPageView extends StatefulWidget {

  const InvestmentLegalAdviceBuildPageView({super.key});

  @override
  State<InvestmentLegalAdviceBuildPageView> createState() => _InvestmentLegalAdviceBuildPageViewState();
}

class _InvestmentLegalAdviceBuildPageViewState extends State<InvestmentLegalAdviceBuildPageView> {
  late AppProvider appProvider;
  late InvestmentLegalAdviceOnBoardingProvider investmentLegalAdviceOnBoardingProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    investmentLegalAdviceOnBoardingProvider = Provider.of<InvestmentLegalAdviceOnBoardingProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<InvestmentLegalAdviceOnBoardingProvider, PageController>(
      selector: (context, provider) => provider.pageController,
      builder: (context, pageController, child) {
        return PageView.builder(
          controller: pageController,
          onPageChanged: (index) => investmentLegalAdviceOnBoardingProvider.onPageChanged(index),
          itemCount: investmentLegalAdviceOnBoardingData.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(SizeManager.s0),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(investmentLegalAdviceOnBoardingData[index].image, width: SizeManager.s400, height: SizeManager.s400),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: SizeManager.s20),
                      FittedBox(
                        child: Text(
                          appProvider.isEnglish ? investmentLegalAdviceOnBoardingData[index].titleEn : investmentLegalAdviceOnBoardingData[index].titleAr,
                          style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.secondaryColor, fontWeight: FontWeightManager.black, fontSize: SizeManager.s30),
                        ),
                      ),
                      const SizedBox(height: SizeManager.s20),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          appProvider.isEnglish ? investmentLegalAdviceOnBoardingData[index].bodyEn : investmentLegalAdviceOnBoardingData[index].bodyAr,
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