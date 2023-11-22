import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/presentation/features/jobs/controllers/jobs_provider.dart';
import 'package:fahem/presentation/features/jobs/widgets/job_item.dart';
import 'package:fahem/presentation/shared/background.dart';
import 'package:fahem/presentation/shared/custom_text_form_field.dart';
import 'package:fahem/presentation/shared/not_found_widget.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobsScreen extends StatefulWidget {

  const JobsScreen({super.key});

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  late AppProvider appProvider;
  late JobsProvider jobsProvider;
  final TextEditingController _textEditingControllerSearch = TextEditingController();

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    jobsProvider = Provider.of<JobsProvider>(context, listen: false);

    jobsProvider.setSelectedJobs(jobsProvider.jobs);
    jobsProvider.initScrollController();
    jobsProvider.showDataInList(isResetData: true, isRefresh: false, isScrollUp: false);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Directionality(
        textDirection: Methods.getDirection(appProvider.isEnglish),
        child: Scaffold(
          body: Background(
            child: SafeArea(
              child: Consumer<JobsProvider>(
                builder: (context, provider, _) {
                  return Padding(
                    padding: const EdgeInsets.only(top: SizeManager.s16, left: SizeManager.s16, right: SizeManager.s16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const PreviousButton(),
                            const SizedBox(width: SizeManager.s20),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    Methods.getText(StringsManager.atYourService, appProvider.isEnglish).toTitleCase(),
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeightManager.black),
                                  ),
                                  Text(
                                    Methods.getText(StringsManager.availableJobs, appProvider.isEnglish).toTitleCase(),
                                    style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: SizeManager.s16),
                        CustomTextFormField(
                          controller: _textEditingControllerSearch,
                          textInputAction: TextInputAction.search,
                          textDirection: Methods.getDirection(appProvider.isEnglish),
                          labelText: Methods.getText(StringsManager.searchForAJob, appProvider.isEnglish).toCapitalized(),
                          onChanged: (val) => jobsProvider.onChangeSearch(context, val),
                          prefixIcon: Image.asset(ImagesManager.searchOutlineIc, color: ColorsManager.primaryColor, width: SizeManager.s20, height: SizeManager.s20),
                          suffixIcon: IconButton(
                            onPressed: () {
                              _textEditingControllerSearch.clear();
                              jobsProvider.changeSelectedJobs(jobsProvider.jobs);
                            },
                            icon: const Icon(Icons.clear, color: ColorsManager.primaryColor),
                          ),
                        ),
                        const SizedBox(height: SizeManager.s16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              Methods.getText(StringsManager.results, appProvider.isEnglish).toCapitalized(),
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Text(
                              '${jobsProvider.selectedJobs.length} ${Methods.getText(StringsManager.result, appProvider.isEnglish)}',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ],
                        ),
                        const SizedBox(height: SizeManager.s8),
                        Expanded(
                          child: provider.selectedJobs.isEmpty ? const NotFoundWidget(text: StringsManager.thereAreNoJobs) : ListView.separated(
                            controller: provider.scrollController,
                            physics: const BouncingScrollPhysics(),
                            padding: const EdgeInsets.only(top: SizeManager.s8, bottom: SizeManager.s16),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  JobItem(jobModel: provider.selectedJobs[index], index: index),
                                  if(index == provider.numberOfItems-1) Padding(
                                    padding: const EdgeInsets.only(top: SizeManager.s16),
                                    child: Column(
                                      children: [
                                        if(provider.hasMoreData) const Center(
                                          child: SizedBox(
                                            width: SizeManager.s20,
                                            height: SizeManager.s20,
                                            child: CircularProgressIndicator(strokeWidth: SizeManager.s3, color: ColorsManager.primaryColor),
                                          ),
                                        ),
                                        if(!provider.hasMoreData && provider.selectedJobs.length > provider.limit) Text(
                                          Methods.getText(StringsManager.thereAreNoOtherResults, appProvider.isEnglish).toCapitalized(),
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeightManager.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) => const SizedBox(height: SizeManager.s10),
                            itemCount: provider.numberOfItems,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingControllerSearch.dispose();
    jobsProvider.disposeScrollController();
    super.dispose();
  }
}