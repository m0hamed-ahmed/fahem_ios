import 'dart:math';
import 'package:animate_do/animate_do.dart';
import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/data_source/static/fahem_services_data.dart';
import 'package:fahem/data/data_source/static/main_category_data.dart';
import 'package:fahem/data/models/users/users_accounts/user_account_model.dart';
import 'package:fahem/presentation/btm_nav_bar/home/controllers/home_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/home/controllers/sliders_provider.dart';
import 'package:fahem/presentation/btm_nav_bar/home/widgets/carousel_slider_widget.dart';
import 'package:fahem/presentation/btm_nav_bar/home/widgets/fahem_service_home_item.dart';
import 'package:fahem/presentation/btm_nav_bar/home/widgets/job_home_item.dart';
import 'package:fahem/presentation/btm_nav_bar/home/widgets/seminar_home_item.dart';
import 'package:fahem/presentation/features/jobs/controllers/jobs_provider.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/features/playlists/controllers/playlists_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AppProvider appProvider;
  late HomeProvider homeProvider;
  late SlidersProvider slidersProvider;
  late JobsProvider jobsProvider;
  late PlaylistsProvider playlistsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    homeProvider = Provider.of<HomeProvider>(context, listen: false);
    slidersProvider = Provider.of<SlidersProvider>(context, listen: false);
    jobsProvider = Provider.of<JobsProvider>(context, listen: false);
    playlistsProvider = Provider.of<PlaylistsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FlipInY(
      duration: const Duration(seconds: 1),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome
            Padding(
              padding: const EdgeInsets.only(left: SizeManager.s16, right: SizeManager.s16, top: SizeManager.s16),
              child: BounceInDown(
                duration: const Duration(seconds: 1),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      Methods.getText(StringsManager.hello, appProvider.isEnglish).toTitleCase(),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.black),
                    ),
                    Selector<UserAccountProvider, UserAccountModel?>(
                      selector: (context, provider) => provider.userAccount,
                      builder: (context, account, _) {
                        return Text(
                          account == null ? Methods.getText(StringsManager.guest, appProvider.isEnglish).toCapitalized() : '${account.firstName} ${account.familyName}',
                          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Main Categories
            Padding(
              padding: const EdgeInsets.all(SizeManager.s16),
              child: SizedBox(
                height: SizeManager.s150,
                child: Row(
                  children: List.generate(mainCategoryData.length, (index) => Expanded(
                    child: BounceInDown(
                      duration: const Duration(seconds: 1),
                      child: Container(
                        margin: const EdgeInsets.all(SizeManager.s5),
                        constraints: const BoxConstraints(
                          minWidth: SizeManager.s130,
                        ),
                        decoration: BoxDecoration(
                          color: ColorsManager.primaryColor,
                          borderRadius: BorderRadius.circular(SizeManager.s10),
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => homeProvider.onTapMainCategory(context: context, index: index),
                            borderRadius: BorderRadius.circular(SizeManager.s10),
                            child: Padding(
                              padding: const EdgeInsets.all(SizeManager.s10),
                              child: Column(
                                children: [
                                  Image.asset(mainCategoryData[index].image, height: SizeManager.s80),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        (appProvider.isEnglish ? mainCategoryData[index].nameEn : mainCategoryData[index].nameAr).toTitleCase(),
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.bold),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
                ),
              ),
            ),

            // Sliders
            if(slidersProvider.sliders.isNotEmpty) const Padding(
              padding: EdgeInsets.symmetric(vertical: SizeManager.s16),
              child: CarouselSliderWidget(),
            ),

            // Fahem Services
            Padding(
              padding: const EdgeInsets.symmetric(vertical: SizeManager.s16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: SizeManager.s16, right: SizeManager.s16, bottom: SizeManager.s8),
                    child: Row(
                      children: [
                        Text(
                          Methods.getText(StringsManager.fahemServices, appProvider.isEnglish).toTitleCase(),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s20, fontWeight: FontWeightManager.black),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => Navigator.pushNamed(context, Routes.fahemServicesRoute),
                          child: Row(
                            children: [
                              Text(
                                Methods.getText(StringsManager.more, appProvider.isEnglish).toCapitalized(),
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeightManager.bold),
                              ),
                              const SizedBox(width: SizeManager.s5),
                              Transform(
                                alignment: FractionalOffset.center,
                                transform: Matrix4.rotationY(appProvider.isEnglish ? pi : 0),
                                child: SvgPicture.asset(ImagesManager.nextArrowIc, width: SizeManager.s20, height: SizeManager.s20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeManager.s100,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => FahemServiceHomeItem(fahemServiceModel: fahemServicesData[index], index: index),
                      separatorBuilder: (context, index) => const SizedBox(width: SizeManager.s10),
                      itemCount: fahemServicesData.length,
                    ),
                  ),
                ],
              ),
            ),

            // Jobs
            if(jobsProvider.jobs.isNotEmpty) Padding(
              padding: const EdgeInsets.symmetric(vertical: SizeManager.s16),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: SizeManager.s16, right: SizeManager.s16, bottom: SizeManager.s8),
                    child: Row(
                      children: [
                        Text(
                          Methods.getText(StringsManager.availableJobs, appProvider.isEnglish).toTitleCase(),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s20, fontWeight: FontWeightManager.black),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => Navigator.pushNamed(context, Routes.jobsRoute),
                          child: Row(
                            children: [
                              Text(
                                Methods.getText(StringsManager.more, appProvider.isEnglish).toCapitalized(),
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeightManager.bold),
                              ),
                              const SizedBox(width: SizeManager.s5),
                              Transform(
                                alignment: FractionalOffset.center,
                                transform: Matrix4.rotationY(appProvider.isEnglish ? pi : 0),
                                child: SvgPicture.asset(ImagesManager.nextArrowIc, width: SizeManager.s20, height: SizeManager.s20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeManager.s195,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => JobHomeItem(jobModel: jobsProvider.jobs[index], index: index),
                      separatorBuilder: (context, index) => const SizedBox(width: SizeManager.s10),
                      itemCount: jobsProvider.jobs.isNotEmpty && jobsProvider.jobs.length >= ConstantsManager.maxNumberToShowJobsInHome
                          ? ConstantsManager.maxNumberToShowJobsInHome
                          : jobsProvider.jobs.length,
                    ),
                  ),
                ],
              ),
            ),

            // Playlists
            if(playlistsProvider.playlists.isNotEmpty)  Padding(
              padding: const EdgeInsets.symmetric(vertical: SizeManager.s16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: SizeManager.s16, right: SizeManager.s16, bottom: SizeManager.s8),
                    child: Row(
                      children: [
                        Text(
                          Methods.getText(StringsManager.playlists, appProvider.isEnglish).toTitleCase(),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s20, fontWeight: FontWeightManager.black),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => Navigator.pushNamed(context, Routes.playlistsRoute),
                          child: Row(
                            children: [
                              Text(
                                Methods.getText(StringsManager.more, appProvider.isEnglish).toCapitalized(),
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeightManager.bold),
                              ),
                              const SizedBox(width: SizeManager.s5),
                              Transform(
                                alignment: FractionalOffset.center,
                                transform: Matrix4.rotationY(appProvider.isEnglish ? pi : 0),
                                child: SvgPicture.asset(ImagesManager.nextArrowIc, width: SizeManager.s20, height: SizeManager.s20),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: SizeManager.s150,
                    child: ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16),
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) => PlaylistHomeItem(playlistModel: playlistsProvider.playlists[index], index: index),
                      separatorBuilder: (context, index) => const SizedBox(width: SizeManager.s10),
                      itemCount: playlistsProvider.playlists.isNotEmpty && playlistsProvider.playlists.length >= ConstantsManager.maxNumberToShowPlaylistsInHome
                          ? ConstantsManager.maxNumberToShowPlaylistsInHome
                          : playlistsProvider.playlists.length,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}