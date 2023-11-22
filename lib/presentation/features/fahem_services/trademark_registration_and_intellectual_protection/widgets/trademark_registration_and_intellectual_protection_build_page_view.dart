import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/data/data_source/static/trademark_registration_and_intellectual_protection_on_boarding_data.dart';
import 'package:fahem/presentation/features/fahem_services/trademark_registration_and_intellectual_protection/controllers/trademark_registration_and_intellectual_protection_on_boarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TrademarkRegistrationAndIntellectualProtectionBuildPageView extends StatefulWidget {

  const TrademarkRegistrationAndIntellectualProtectionBuildPageView({super.key});

  @override
  State<TrademarkRegistrationAndIntellectualProtectionBuildPageView> createState() => _TrademarkRegistrationAndIntellectualProtectionBuildPageViewState();
}

class _TrademarkRegistrationAndIntellectualProtectionBuildPageViewState extends State<TrademarkRegistrationAndIntellectualProtectionBuildPageView> {
  late AppProvider appProvider;
  late TrademarkRegistrationAndIntellectualProtectionOnBoardingProvider trademarkRegistrationAndIntellectualProtectionOnBoardingProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    trademarkRegistrationAndIntellectualProtectionOnBoardingProvider = Provider.of<TrademarkRegistrationAndIntellectualProtectionOnBoardingProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<TrademarkRegistrationAndIntellectualProtectionOnBoardingProvider, PageController>(
      selector: (context, provider) => provider.pageController,
      builder: (context, pageController, child) {
        return PageView.builder(
          controller: pageController,
          onPageChanged: (index) => trademarkRegistrationAndIntellectualProtectionOnBoardingProvider.onPageChanged(index),
          itemCount: trademarkRegistrationAndIntellectualProtectionOnBoardingData.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(SizeManager.s0),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(trademarkRegistrationAndIntellectualProtectionOnBoardingData[index].image, width: SizeManager.s400, height: SizeManager.s400),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: SizeManager.s20),
                      FittedBox(
                        child: Text(
                          appProvider.isEnglish ? trademarkRegistrationAndIntellectualProtectionOnBoardingData[index].titleEn : trademarkRegistrationAndIntellectualProtectionOnBoardingData[index].titleAr,
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeightManager.black, fontSize: SizeManager.s30),
                        ),
                      ),
                      const SizedBox(height: SizeManager.s20),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          appProvider.isEnglish ? trademarkRegistrationAndIntellectualProtectionOnBoardingData[index].bodyEn : trademarkRegistrationAndIntellectualProtectionOnBoardingData[index].bodyAr,
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