import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/data/data_source/static/debt_collection_on_boarding_data.dart';
import 'package:fahem/presentation/features/fahem_services/debt_collection/controllers/debt_collection_on_boarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DebtCollectionBuildPageView extends StatefulWidget {

  const DebtCollectionBuildPageView({super.key});

  @override
  State<DebtCollectionBuildPageView> createState() => _DebtCollectionBuildPageViewState();
}

class _DebtCollectionBuildPageViewState extends State<DebtCollectionBuildPageView> {
  late AppProvider appProvider;
  late DebtCollectionOnBoardingProvider debtCollectionOnBoardingProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    debtCollectionOnBoardingProvider = Provider.of<DebtCollectionOnBoardingProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<DebtCollectionOnBoardingProvider, PageController>(
      selector: (context, provider) => provider.pageController,
      builder: (context, pageController, child) {
        return PageView.builder(
          controller: pageController,
          onPageChanged: (index) => debtCollectionOnBoardingProvider.onPageChanged(index),
          itemCount: debtCollectionOnBoardingData.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(SizeManager.s0),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(debtCollectionOnBoardingData[index].image, width: SizeManager.s400, height: SizeManager.s400),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: SizeManager.s20),
                      FittedBox(
                        child: Text(
                          appProvider.isEnglish ? debtCollectionOnBoardingData[index].titleEn : debtCollectionOnBoardingData[index].titleAr,
                          style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.secondaryColor, fontWeight: FontWeightManager.black, fontSize: SizeManager.s30),
                        ),
                      ),
                      const SizedBox(height: SizeManager.s20),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          appProvider.isEnglish ? debtCollectionOnBoardingData[index].bodyEn : debtCollectionOnBoardingData[index].bodyAr,
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