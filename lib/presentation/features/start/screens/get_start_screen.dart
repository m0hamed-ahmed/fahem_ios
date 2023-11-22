import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/presentation/features/start/controllers/get_start_provider.dart';
import 'package:fahem/presentation/shared/background.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GetStartScreen extends StatefulWidget {

  const GetStartScreen({Key? key}) : super(key: key);

  @override
  State<GetStartScreen> createState() => _GetStartScreenState();
}

class _GetStartScreenState extends State<GetStartScreen> {
  late AppProvider appProvider;
  late GetStartProvider getStartProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    getStartProvider = Provider.of<GetStartProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.doYouWantToExitAnApp, appProvider.isEnglish).toCapitalized()),
      child: Directionality(
        textDirection: Methods.getDirection(appProvider.isEnglish),
        child: Scaffold(
          body: Background(
            child: SafeArea(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        ImagesManager.logo,
                        width: SizeManager.s40,
                        height: SizeManager.s40,
                      ),
                      const SizedBox(width: SizeManager.s5),
                      Text(
                        Methods.getText(StringsManager.appName, appProvider.isEnglish).toTitleCase(),
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontSize: SizeManager.s40,
                          fontWeight: FontWeightManager.bold,
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: Transform.translate(
                      offset: const Offset(SizeManager.s0, SizeManager.s50),
                      child: Image.asset(ImagesManager.politicalCandidate, fit: BoxFit.fill),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      color: ColorsManager.primaryColor,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(SizeManager.s20),
                        topRight: Radius.circular(SizeManager.s20),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Image.asset(
                          ImagesManager.lines3,
                          width: double.infinity,
                          fit: BoxFit.fill,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: SizeManager.s16,
                            right: SizeManager.s16,
                            top: SizeManager.s16,
                            bottom: SizeManager.s32,
                          ),
                          child: Column(
                            children: [
                              Text(
                                Methods.getText(StringsManager.theEasiestWayToSolveAllYourProblems, appProvider.isEnglish).toCapitalized(),
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.white, fontSize: SizeManager.s50, fontWeight: FontWeightManager.bold),
                              ),
                              Text(
                                Methods.getText(StringsManager.chooseFromTheBestLawyersAndConsultantsInAllDisciplines, appProvider.isEnglish).toCapitalized(),
                                style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.white),
                              ),
                              const SizedBox(height: SizeManager.s32),
                              CustomButton(
                                buttonType: ButtonType.text,
                                onPressed: () => getStartProvider.startNow(context),
                                text: Methods.getText(StringsManager.startNow, appProvider.isEnglish).toUpperCase(),
                                buttonColor: ColorsManager.white,
                                textColor: ColorsManager.primaryColor,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}