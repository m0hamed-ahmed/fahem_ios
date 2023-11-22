import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/presentation/features/start/controllers/splash_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late AppProvider appProvider;
  late SplashProvider splashProvider;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    splashProvider = Provider.of<SplashProvider>(context, listen: false);
    splashProvider.getVersionAndGetData(context);

    _controller = VideoPlayerController.asset(VideosManager.splashScreen)..initialize().then((_) {
      setState(() {
        _controller.play();
        _controller.setLooping(true);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.doYouWantToExitAnApp, appProvider.isEnglish).toCapitalized()),
      child: Scaffold(
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            VideoPlayer(_controller),
            Padding(
              padding: const EdgeInsets.only(bottom: SizeManager.s50),
              child: SizedBox(
                width: SizeManager.s100,
                height: SizeManager.s40,
                child: Selector<SplashProvider, bool>(
                  selector: (context, provider) => provider.isErrorOccurred,
                  builder: (context, isErrorOccurred, child) {
                    return isErrorOccurred ? IconButton(
                      onPressed: () async => await splashProvider.onPressedTryAgain(context),
                      padding: const EdgeInsets.all(SizeManager.s0),
                      color: ColorsManager.red700,
                      iconSize: SizeManager.s40,
                      icon: const Icon(Icons.refresh),
                    ) : Selector<SplashProvider, int>(
                      selector: (context, provider) => provider.loadingCount,
                      builder: (context, loadingCount, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(3, (index) {
                            return Container(
                              margin: const EdgeInsets.all(SizeManager.s3),
                              width: SizeManager.s12,
                              height: SizeManager.s12,
                              decoration: BoxDecoration(
                                color: loadingCount%3 == index ? ColorsManager.white : ColorsManager.black38,
                                shape: BoxShape.circle,
                              ),
                            );
                          }),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}