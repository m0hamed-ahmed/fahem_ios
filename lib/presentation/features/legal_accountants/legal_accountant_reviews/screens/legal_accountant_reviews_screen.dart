import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountant_reviews/controllers/legal_accountants_reviews_provider.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountant_reviews/widgets/legal_accountant_review_item.dart';
import 'package:fahem/presentation/shared/background.dart';
import 'package:fahem/presentation/shared/not_found_widget.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LegalAccountantReviewsScreen extends StatefulWidget {

  const LegalAccountantReviewsScreen({super.key});

  @override
  State<LegalAccountantReviewsScreen> createState() => _LegalAccountantsReviewsScreenState();
}

class _LegalAccountantsReviewsScreenState extends State<LegalAccountantReviewsScreen> {
  late AppProvider appProvider;
  late LegalAccountantsReviewsProvider legalAccountantsReviewsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    legalAccountantsReviewsProvider = Provider.of<LegalAccountantsReviewsProvider>(context, listen: false);

    legalAccountantsReviewsProvider.initScrollController();
    legalAccountantsReviewsProvider.showDataInList(isResetData: true, isRefresh: false, isScrollUp: false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Methods.getDirection(appProvider.isEnglish),
      child: Scaffold(
        body: Background(
          child: SafeArea(
            child: Consumer<LegalAccountantsReviewsProvider>(
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
                          Expanded(
                            child: Text(
                              Methods.getText(StringsManager.reviews, appProvider.isEnglish).toTitleCase(),
                              style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: SizeManager.s25, fontWeight: FontWeightManager.black),
                            ),
                          ),
                        ],
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
                            '${provider.legalAccountantsReviews.length} ${Methods.getText(StringsManager.result, appProvider.isEnglish)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: SizeManager.s8),
                      Expanded(
                        child: provider.legalAccountantsReviews.isEmpty ? const NotFoundWidget(text: StringsManager.thereAreNoReviews) : ListView.separated(
                          controller: provider.scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(top: SizeManager.s8, bottom: SizeManager.s16),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                LegalAccountantReviewItem(legalAccountantReviewModel: provider.legalAccountantsReviews[index], index: index),
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
                                      if(!provider.hasMoreData && provider.legalAccountantsReviews.length > provider.limit) Text(
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
    );
  }

  @override
  void dispose() {
    legalAccountantsReviewsProvider.disposeScrollController();
    super.dispose();
  }
}