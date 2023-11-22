import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/data_source/static/debt_collection_on_boarding_data.dart';
import 'package:fahem/presentation/features/fahem_services/debt_collection/controllers/debt_collection_on_boarding_provider.dart';
import 'package:fahem/presentation/features/fahem_services/debt_collection/widgets/debt_collection_build_page_view.dart';
import 'package:fahem/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DebtCollectionOnBoardingScreen extends StatefulWidget {

  const DebtCollectionOnBoardingScreen({super.key});

  @override
  State<DebtCollectionOnBoardingScreen> createState() => _DebtCollectionOnBoardingScreenState();
}

class _DebtCollectionOnBoardingScreenState extends State<DebtCollectionOnBoardingScreen> {
  late AppProvider appProvider;
  late DebtCollectionOnBoardingProvider debtCollectionOnBoardingProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    debtCollectionOnBoardingProvider = Provider.of<DebtCollectionOnBoardingProvider>(context, listen: false);
    debtCollectionOnBoardingProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Methods.getDirection(appProvider.isEnglish),
      child: Selector<DebtCollectionOnBoardingProvider, bool>(
        selector: (context, provider) => provider.isLoading,
        builder: (context, isLoading, _) {
          return AbsorbPointerWidget(
            absorbing: isLoading,
            child: Scaffold(
              appBar: AppBar(
                leading: const Padding(
                  padding: EdgeInsets.all(SizeManager.s10),
                  child: PreviousButton(buttonColor: ColorsManager.secondaryColor),
                ),
                actions: [
                  if(debtCollectionOnBoardingData.length > 1) Padding(
                    padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
                    child: TextButton(
                      onPressed: () async => await debtCollectionOnBoardingProvider.skip(context),
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
                child: DebtCollectionBuildPageView(),
              ),
              bottomNavigationBar: Container(
                margin: const EdgeInsets.only(bottom: SizeManager.s16),
                padding: const EdgeInsets.symmetric(horizontal: SizeManager.s32),
                width: double.infinity,
                height: SizeManager.s100,
                child: Selector<DebtCollectionOnBoardingProvider, int>(
                  selector: (context, provider) => provider.currentPage,
                  builder: (context, currentPage, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        debtCollectionOnBoardingData.length == 1 ? const SizedBox(height: SizeManager.s10) : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(debtCollectionOnBoardingData.length, (index) {
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
                          onPressed: () async => await debtCollectionOnBoardingProvider.next(context),
                          text: Methods.getText(currentPage == debtCollectionOnBoardingData.length-1 ? StringsManager.startNow : StringsManager.next, appProvider.isEnglish).toUpperCase(),
                          buttonColor: ColorsManager.secondaryColor,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    debtCollectionOnBoardingProvider.setCurrentPage(0);
    super.dispose();
  }
}