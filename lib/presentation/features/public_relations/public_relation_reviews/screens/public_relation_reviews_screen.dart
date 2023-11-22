import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/presentation/features/public_relations/public_relation_reviews/controllers/public_relations_reviews_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relation_reviews/widgets/public_relation_review_item.dart';
import 'package:fahem/presentation/shared/background.dart';
import 'package:fahem/presentation/shared/not_found_widget.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PublicRelationReviewsScreen extends StatefulWidget {

  const PublicRelationReviewsScreen({Key? key}) : super(key: key);

  @override
  State<PublicRelationReviewsScreen> createState() => _PublicRelationsReviewsScreenState();
}

class _PublicRelationsReviewsScreenState extends State<PublicRelationReviewsScreen> {
  late AppProvider appProvider;
  late PublicRelationsReviewsProvider publicRelationsReviewsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    publicRelationsReviewsProvider = Provider.of<PublicRelationsReviewsProvider>(context, listen: false);

    publicRelationsReviewsProvider.initScrollController();
    publicRelationsReviewsProvider.showDataInList(isResetData: true, isRefresh: false, isScrollUp: false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Methods.getDirection(appProvider.isEnglish),
      child: Scaffold(
        body: Background(
          child: SafeArea(
            child: Consumer<PublicRelationsReviewsProvider>(
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
                            '${provider.publicRelationsReviews.length} ${Methods.getText(StringsManager.result, appProvider.isEnglish)}',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: SizeManager.s8),
                      Expanded(
                        child: provider.publicRelationsReviews.isEmpty ? const NotFoundWidget(text: StringsManager.thereAreNoReviews) : ListView.separated(
                          controller: provider.scrollController,
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.only(top: SizeManager.s8, bottom: SizeManager.s16),
                          itemBuilder: (context, index) {
                            return Column(
                              children: [
                                PublicRelationReviewItem(publicRelationReviewModel: provider.publicRelationsReviews[index], index: index),
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
                                      if(!provider.hasMoreData && provider.publicRelationsReviews.length > provider.limit) Text(
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
    publicRelationsReviewsProvider.disposeScrollController();
    super.dispose();
  }
}