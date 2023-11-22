import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/data/data_source/static/establishing_companies_on_boarding_data.dart';
import 'package:fahem/presentation/features/fahem_services/establishing_companies/controllers/establishing_companies_on_boarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EstablishingCompanyBuildPageView extends StatefulWidget {

  const EstablishingCompanyBuildPageView({super.key});

  @override
  State<EstablishingCompanyBuildPageView> createState() => _EstablishingCompanyBuildPageViewState();
}

class _EstablishingCompanyBuildPageViewState extends State<EstablishingCompanyBuildPageView> {
  late AppProvider appProvider;
  late EstablishingCompaniesOnBoardingProvider establishingCompaniesOnBoardingProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    establishingCompaniesOnBoardingProvider = Provider.of<EstablishingCompaniesOnBoardingProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Selector<EstablishingCompaniesOnBoardingProvider, PageController>(
      selector: (context, provider) => provider.pageController,
      builder: (context, pageController, child) {
        return PageView.builder(
          controller: pageController,
          onPageChanged: (index) => establishingCompaniesOnBoardingProvider.onPageChanged(index),
          itemCount: establishingCompaniesOnBoardingData.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(SizeManager.s0),
              child: Column(
                children: [
                  Expanded(
                    child: Image.asset(establishingCompaniesOnBoardingData[index].image, width: SizeManager.s400, height: SizeManager.s400),
                  ),
                  Column(
                    children: [
                      const SizedBox(height: SizeManager.s20),
                      FittedBox(
                        child: Text(
                          appProvider.isEnglish ? establishingCompaniesOnBoardingData[index].titleEn : establishingCompaniesOnBoardingData[index].titleAr,
                          style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.secondaryColor, fontWeight: FontWeightManager.black, fontSize: SizeManager.s30),
                        ),
                      ),
                      const SizedBox(height: SizeManager.s20),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          appProvider.isEnglish ? establishingCompaniesOnBoardingData[index].bodyEn : establishingCompaniesOnBoardingData[index].bodyAr,
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