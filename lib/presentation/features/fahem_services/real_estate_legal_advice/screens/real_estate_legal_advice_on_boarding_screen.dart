import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/data_source/static/real_estate_legal_advice_on_boarding_data.dart';
import 'package:fahem/presentation/features/fahem_services/real_estate_legal_advice/widgets/real_estate_legal_advice_build_page_view.dart';
import 'package:fahem/presentation/features/fahem_services/real_estate_legal_advice/controllers/real_estate_legal_advice_on_boarding_provider.dart';
import 'package:fahem/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RealEstateLegalAdviceOnBoardingScreen extends StatefulWidget {

  const RealEstateLegalAdviceOnBoardingScreen({super.key});

  @override
  State<RealEstateLegalAdviceOnBoardingScreen> createState() => _RealEstateLegalAdviceOnBoardingScreenState();
}

class _RealEstateLegalAdviceOnBoardingScreenState extends State<RealEstateLegalAdviceOnBoardingScreen> {
  late AppProvider appProvider;
  late RealEstateLegalAdviceOnBoardingProvider realEstateLegalAdviceOnBoardingProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    realEstateLegalAdviceOnBoardingProvider = Provider.of<RealEstateLegalAdviceOnBoardingProvider>(context, listen: false);
    realEstateLegalAdviceOnBoardingProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Methods.getDirection(appProvider.isEnglish),
      child: Selector<RealEstateLegalAdviceOnBoardingProvider, bool>(
        selector: (context, provider) => provider.isLoading,
        builder: (context, isLoading, _) {
          return AbsorbPointerWidget(
            absorbing: isLoading,
            child: Scaffold(
              appBar: AppBar(
                leading: const Padding(
                  padding: EdgeInsets.all(SizeManager.s10),
                  child: PreviousButton(),
                ),
                actions: [
                  if(realEstateLegalAdviceOnBoardingData.length > 1) Padding(
                    padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
                    child: TextButton(
                      onPressed: () async => await realEstateLegalAdviceOnBoardingProvider.skip(context),
                      child: Text(
                        Methods.getText(StringsManager.skip, appProvider.isEnglish).toUpperCase(),
                        style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeightManager.black),
                      ),
                    ),
                  ),
                ],
              ),
              body: const Padding(
                padding: EdgeInsets.all(SizeManager.s16),
                child: RealEstateLegalAdviceBuildPageView(),
              ),
              bottomNavigationBar: Container(
                margin: const EdgeInsets.only(bottom: SizeManager.s16),
                padding: const EdgeInsets.symmetric(horizontal: SizeManager.s32),
                width: double.infinity,
                height: SizeManager.s100,
                child: Selector<RealEstateLegalAdviceOnBoardingProvider, int>(
                  selector: (context, provider) => provider.currentPage,
                  builder: (context, currentPage, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        realEstateLegalAdviceOnBoardingData.length == 1 ? const SizedBox(height: SizeManager.s10) : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(realEstateLegalAdviceOnBoardingData.length, (index) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: ConstantsManager.onBoardingPageViewDuration),
                              margin: const EdgeInsets.only(right: SizeManager.s5),
                              width: currentPage == index ? SizeManager.s40 : SizeManager.s20,
                              height: SizeManager.s10,
                              decoration: BoxDecoration(
                                color: currentPage == index ? ColorsManager.primaryColor : ColorsManager.grey1,
                                borderRadius: BorderRadius.circular(SizeManager.s10),
                              ),
                            );
                          }),
                        ),
                        CustomButton(
                          buttonType: ButtonType.text,
                          onPressed: () async => await realEstateLegalAdviceOnBoardingProvider.next(context),
                          text: Methods.getText(currentPage == realEstateLegalAdviceOnBoardingData.length-1 ? StringsManager.startNow : StringsManager.next, appProvider.isEnglish).toUpperCase(),
                          buttonColor: ColorsManager.primaryColor,
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
    realEstateLegalAdviceOnBoardingProvider.setCurrentPage(0);
    super.dispose();
  }
}