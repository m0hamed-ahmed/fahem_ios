import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/data_source/static/instant_lawyer_on_boarding_data.dart';
import 'package:fahem/presentation/features/fahem_services/instant_lawyers/controllers/instant_lawyers_on_boarding_provider.dart';
import 'package:fahem/presentation/features/fahem_services/instant_lawyers/widgets/instant_lawyer_build_page_view.dart';
import 'package:fahem/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstantLawyersOnBoardingScreen extends StatefulWidget {

  const InstantLawyersOnBoardingScreen({super.key});

  @override
  State<InstantLawyersOnBoardingScreen> createState() => _InstantLawyersOnBoardingScreenState();
}

class _InstantLawyersOnBoardingScreenState extends State<InstantLawyersOnBoardingScreen> {
  late AppProvider appProvider;
  late InstantLawyersOnBoardingProvider instantLawyersOnBoardingProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    instantLawyersOnBoardingProvider = Provider.of<InstantLawyersOnBoardingProvider>(context, listen: false);
    instantLawyersOnBoardingProvider.init();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Methods.getDirection(appProvider.isEnglish),
      child: Selector<InstantLawyersOnBoardingProvider, bool>(
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
                  if(instantLawyerOnBoardingData.length > 1) Padding(
                    padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
                    child: TextButton(
                      onPressed: () async => await instantLawyersOnBoardingProvider.skip(context),
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
                child: InstantLawyerBuildPageView(),
              ),
              bottomNavigationBar: Container(
                margin: const EdgeInsets.only(bottom: SizeManager.s16),
                padding: const EdgeInsets.symmetric(horizontal: SizeManager.s32),
                width: double.infinity,
                height: SizeManager.s100,
                child: Selector<InstantLawyersOnBoardingProvider, int>(
                  selector: (context, provider) => provider.currentPage,
                  builder: (context, currentPage, child) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        instantLawyerOnBoardingData.length == 1 ? const SizedBox(height: SizeManager.s10) : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(instantLawyerOnBoardingData.length, (index) {
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
                          onPressed: () async => await instantLawyersOnBoardingProvider.next(context),
                          text: Methods.getText(currentPage == instantLawyerOnBoardingData.length-1 ? StringsManager.startNow : StringsManager.next, appProvider.isEnglish).toUpperCase(),
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
    instantLawyersOnBoardingProvider.setCurrentPage(0);
    super.dispose();
  }
}