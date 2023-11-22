import 'package:fahem/core/network/api_constants.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/core/utils/validator.dart';
import 'package:fahem/data/models/jobs/employment_applications/employment_application_model.dart';
import 'package:fahem/data/models/jobs/jobs/job_model.dart';
import 'package:fahem/presentation/features/jobs/controllers/job_apply_provider.dart';
import 'package:fahem/presentation/features/profile/controllers/user_account_provider.dart';
import 'package:fahem/presentation/shared/absorb_pointer_widget.dart';
import 'package:fahem/presentation/shared/cached_network_image_widget.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/custom_text_form_field.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobApplyScreen extends StatefulWidget {
  final JobModel jobModel;
  final String tag;

  const JobApplyScreen({super.key, required this.jobModel, required this.tag});

  @override
  State<JobApplyScreen> createState() => _JobApplyScreenState();
}

class _JobApplyScreenState extends State<JobApplyScreen> {
  late AppProvider appProvider;
  late JobApplyProvider jobApplyProvider;
  late UserAccountProvider userAccountProvider;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _textEditingControllerName = TextEditingController();
  final TextEditingController _textEditingControllerPhoneNumber = TextEditingController();

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    jobApplyProvider = Provider.of<JobApplyProvider>(context, listen: false);
    userAccountProvider = Provider.of<UserAccountProvider>(context, listen: false);

    _textEditingControllerName.text = '${userAccountProvider.userAccount!.firstName} ${userAccountProvider.userAccount!.familyName}';
    _textEditingControllerPhoneNumber.text = userAccountProvider.userAccount!.phoneNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Selector<JobApplyProvider, bool>(
      selector: (context, provider) => provider.isLoading,
      builder: (context, isLoading, _) {
        return AbsorbPointerWidget(
          absorbing: isLoading,
          alignment: Alignment.topCenter,
          child: IgnorePointer(
            ignoring: isLoading,
            child: Directionality(
              textDirection: Methods.getDirection(appProvider.isEnglish),
              child: Scaffold(
                body: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(SizeManager.s16),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const PreviousButton(),
                              const SizedBox(width: SizeManager.s20),
                              Expanded(
                                child: Text(
                                  Methods.getText(StringsManager.apply, appProvider.isEnglish).toTitleCase(),
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
                          Text(
                            Methods.getText(StringsManager.personalInformation, appProvider.isEnglish).toCapitalized(),
                            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.black),
                          ),
                          const SizedBox(height: SizeManager.s10),
                          Text(
                            '${Methods.getText(StringsManager.name, appProvider.isEnglish).toCapitalized()} *',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: SizeManager.s5),
                          CustomTextFormField(
                            controller: _textEditingControllerName,
                            textInputAction: TextInputAction.next,
                            textDirection: Methods.getDirection(appProvider.isEnglish),
                            fillColor: ColorsManager.grey1,
                            borderColor: ColorsManager.grey1,
                            prefixIcon: const Icon(Icons.person_outlined, color: ColorsManager.grey),
                            suffixIcon: IconButton(
                              onPressed: () => _textEditingControllerName.clear(),
                              icon: const Icon(Icons.clear, color: ColorsManager.grey),
                            ),
                            validator: (val) {
                              if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                              return null;
                            },
                          ),
                          const SizedBox(height: SizeManager.s10),
                          Text(
                            '${Methods.getText(StringsManager.mobileNumber, appProvider.isEnglish).toCapitalized()} *',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: SizeManager.s5),
                          CustomTextFormField(
                            controller: _textEditingControllerPhoneNumber,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.phone,
                            maxLength: 11,
                            fillColor: ColorsManager.grey1,
                            borderColor: ColorsManager.grey1,
                            prefixIcon: const Icon(Icons.phone, color: ColorsManager.grey),
                            suffixIcon: IconButton(
                              onPressed: () => _textEditingControllerPhoneNumber.clear(),
                              icon: const Icon(Icons.clear, color: ColorsManager.grey),
                            ),
                            validator: (val) {
                              if(Validator.isEmpty(val!)) {return Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized();}
                              else if(!Validator.isPhoneNumberValid(val)) {return Methods.getText(StringsManager.phoneNumberIsIncorrect, appProvider.isEnglish).toCapitalized();}
                              return null;
                            },
                          ),
                          const SizedBox(height: SizeManager.s10),
                          Text(
                            '${Methods.getText(StringsManager.cv, appProvider.isEnglish).toUpperCase()} *',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: SizeManager.s5),
                          Selector<JobApplyProvider, FilePickerResult?>(
                            selector: (context, provider) => provider.cvFile,
                            builder: (context, cvFile, child) {
                              return Selector<JobApplyProvider, bool>(
                                selector: (context, provider) => provider.isButtonClicked,
                                builder: (context, isButtonClicked, _) {
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsetsDirectional.fromSTEB(SizeManager.s0, SizeManager.s0, SizeManager.s10, SizeManager.s0),
                                        decoration: BoxDecoration(
                                          color: ColorsManager.grey1,
                                          borderRadius: BorderRadius.circular(SizeManager.s10),
                                          border: cvFile == null && isButtonClicked ? Border.all(color: ColorsManager.red700) : null,
                                        ),
                                        height: SizeManager.s45,
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: ColorsManager.secondaryColor,
                                                  borderRadius: BorderRadius.circular(SizeManager.s10),
                                                ),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    onTap: () async {
                                                      FilePickerResult? filePickerResult = await FilePicker.platform.pickFiles();
                                                      if (filePickerResult != null) {jobApplyProvider.changeCvFile(filePickerResult);}
                                                    },
                                                    borderRadius: BorderRadius.circular(SizeManager.s10),
                                                    child: Center(
                                                      child: Text(
                                                        Methods.getText(StringsManager.attachAFile, appProvider.isEnglish).toTitleCase(),
                                                        style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.black),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: Center(
                                                child: Text(
                                                  cvFile == null ? ConstantsManager.empty : cvFile.files.single.name,
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis,
                                                  style: Theme.of(context).textTheme.bodySmall,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      cvFile == null && isButtonClicked ? Column(
                                        children: [
                                          const SizedBox(height: SizeManager.s8),
                                          Text(
                                            Methods.getText(StringsManager.required, appProvider.isEnglish).toCapitalized(),
                                            style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.red700),
                                          ),
                                        ],
                                      ) : Container(),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                bottomNavigationBar: Container(
                  margin: const EdgeInsets.all(SizeManager.s16),
                  child: CustomButton(
                    buttonType: ButtonType.text,
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      jobApplyProvider.changeIsButtonClicked(true);
                      if(_formKey.currentState!.validate() && jobApplyProvider.isDataValid(context)) {
                        FocusScope.of(context).unfocus();
                        EmploymentApplicationModel employmentApplicationModel = EmploymentApplicationModel(
                          employmentApplicationId: 0,
                          userAccountId: userAccountProvider.userAccount!.userAccountId,
                          jobId: widget.jobModel.jobId,
                          targetId: widget.jobModel.targetId,
                          targetName: widget.jobModel.targetName,
                          name: _textEditingControllerName.text.trim(),
                          phoneNumber: _textEditingControllerPhoneNumber.text.trim(),
                          cv: jobApplyProvider.cvFile!.files.single.name,
                          createdAt: DateTime.now(),
                        );
                        jobApplyProvider.onPressedSendEmploymentApplication(context: context, employmentApplicationModel: employmentApplicationModel, jobTitle: widget.jobModel.jobTitle);
                      }
                    },
                    text: Methods.getText(StringsManager.sendInformation, appProvider.isEnglish).toTitleCase(),
                    borderRadius: SizeManager.s10,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _textEditingControllerName.dispose();
    _textEditingControllerPhoneNumber.dispose();
    jobApplyProvider.resetAllData();
    super.dispose();
  }
}