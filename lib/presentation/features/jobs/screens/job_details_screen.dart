import 'package:fahem/core/network/api_constants.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/dialogs.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/jobs/jobs/job_model.dart';
import 'package:fahem/presentation/features/jobs/controllers/job_details_provider.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/shared/cached_network_image_widget.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobDetailsScreen extends StatefulWidget {
  final JobModel jobModel;
  final String tag;
  
  const JobDetailsScreen({super.key, required this.jobModel, required this.tag});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  late AppProvider appProvider;
  late JobDetailsProvider jobDetailsProvider;
  late UserAccountProvider userAccountProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    jobDetailsProvider = Provider.of<JobDetailsProvider>(context, listen: false);
    userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);
  }
  
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Methods.getDirection(appProvider.isEnglish),
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(SizeManager.s16),
            child: Selector<JobDetailsProvider, JobDetailsMode>(
              selector: (context, provider) => provider.jobDetailsMode,
              builder: (context, jobDetailsMode, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const PreviousButton(),
                        const SizedBox(width: SizeManager.s20),
                        Expanded(
                          child: Text(
                            Methods.getText(StringsManager.jobDetails, appProvider.isEnglish).toTitleCase(),
                            style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: SizeManager.s20),
                    Center(
                      child: GestureDetector(
                        onTap: () => Navigator.pushNamed(context, Routes.showFullImageRoute, arguments: {ConstantsManager.imageArgument: widget.jobModel.image, ConstantsManager.directoryArgument: ApiConstants.jobsDirectory}),
                        child: SizedBox(
                          // tag: widget.jobModel.image + widget.tag,
                          child: Container(
                            clipBehavior: Clip.antiAlias,
                            width: SizeManager.s100,
                            height: SizeManager.s100,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${ApiConstants.jobsDirectory}/${widget.jobModel.image}')),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: SizeManager.s10),
                    Center(
                      child: Text(
                        widget.jobModel.jobTitle,
                        style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.black),
                      ),
                    ),
                    Center(
                      child: Text(
                        widget.jobModel.companyName,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Center(
                      child: Text(
                        widget.jobModel.jobLocation,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: SizeManager.s10),
                    Center(
                      child: Wrap(
                        spacing: SizeManager.s5,
                        runSpacing: SizeManager.s5,
                        alignment: WrapAlignment.center,
                        children: List.generate(widget.jobModel.features.length, (index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: SizeManager.s1, horizontal: SizeManager.s10),
                            decoration: BoxDecoration(
                              color: ColorsManager.white,
                              borderRadius: BorderRadius.circular(SizeManager.s10),
                              border: Border.all(color: ColorsManager.primaryColor),
                            ),
                            child: Text(
                              widget.jobModel.features[index],
                              style: Theme.of(context).textTheme.displaySmall!.copyWith(
                                color: ColorsManager.primaryColor,
                                fontWeight: FontWeightManager.bold,
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: SizeManager.s10),
                    const Divider(color: ColorsManager.grey),
                    const SizedBox(height: SizeManager.s10),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            buttonType: ButtonType.text,
                            onPressed: () => jobDetailsProvider.changeJobDetailsMode(JobDetailsMode.jobDetails),
                            text: Methods.getText(StringsManager.jobDetails, appProvider.isEnglish).toTitleCase(),
                            height: SizeManager.s35,
                            textFontWeight: FontWeightManager.medium,
                            buttonColor: jobDetailsMode == JobDetailsMode.jobDetails ? ColorsManager.secondaryColor : ColorsManager.white,
                            borderColor: jobDetailsMode == JobDetailsMode.jobDetails ? ColorsManager.secondaryColor : ColorsManager.primaryColor,
                            textColor: jobDetailsMode == JobDetailsMode.jobDetails ? ColorsManager.white : ColorsManager.primaryColor,
                            borderRadius: SizeManager.s10,
                          ),
                        ),
                        const SizedBox(width: SizeManager.s10),
                        Expanded(
                          child: CustomButton(
                            buttonType: ButtonType.text,
                            onPressed: () => jobDetailsProvider.changeJobDetailsMode(JobDetailsMode.aboutCompany),
                            text: Methods.getText(StringsManager.aboutCompany, appProvider.isEnglish).toTitleCase(),
                            height: SizeManager.s35,
                            textFontWeight: FontWeightManager.medium,
                            buttonColor: jobDetailsMode == JobDetailsMode.aboutCompany ? ColorsManager.secondaryColor : ColorsManager.white,
                            borderColor: jobDetailsMode == JobDetailsMode.aboutCompany ? ColorsManager.secondaryColor : ColorsManager.primaryColor,
                            textColor: jobDetailsMode == JobDetailsMode.aboutCompany ? ColorsManager.white : ColorsManager.primaryColor,
                            borderRadius: SizeManager.s10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: SizeManager.s20),
                    Text(
                      Methods.getText(jobDetailsMode == JobDetailsMode.jobDetails ? StringsManager.jobDetails : StringsManager.aboutCompany, appProvider.isEnglish).toCapitalized(),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.black),
                    ),
                    const SizedBox(height: SizeManager.s10),
                    Text(
                      jobDetailsMode == JobDetailsMode.jobDetails
                          ? (widget.jobModel.details)
                          : (widget.jobModel.aboutCompany),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),

                    if(jobDetailsMode == JobDetailsMode.jobDetails) Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: SizeManager.s20),
                        Text(
                          Methods.getText(StringsManager.salary, appProvider.isEnglish).toCapitalized(),
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.black),
                        ),
                        const SizedBox(height: SizeManager.s10),
                        Text(
                          '${widget.jobModel.minSalary} - ${widget.jobModel.maxSalary} ${Methods.getText(StringsManager.egyptianPound, appProvider.isEnglish).toUpperCase()}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.all(SizeManager.s16),
          child: CustomButton(
            buttonType: ButtonType.text,
            onPressed: () {
              if(userAccountProvider.userAccount == null) {
                Dialogs.showBottomSheetConfirmation(context: context, message: Methods.getText(StringsManager.youMustLoginFirstToAccessTheService, appProvider.isEnglish).toCapitalized()).then((value) async {
                  if(value) {Navigator.pushNamed(context, Routes.signInWithPhoneNumberRoute);}
                });
              }
              else {
                Navigator.pushNamed(context, Routes.jobApplyRoute, arguments: {ConstantsManager.jobModelArgument: widget.jobModel, ConstantsManager.tagArgument: ConstantsManager.jobDetailsTag});
              }
            },
            text: Methods.getText(StringsManager.apply, appProvider.isEnglish).toUpperCase(),
            borderRadius: SizeManager.s10,
          ),
        ),
      ),
    );
  }
}