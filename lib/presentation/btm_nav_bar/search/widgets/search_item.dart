import 'package:animate_do/animate_do.dart';
import 'package:fahem/core/network/api_constants.dart';
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
import 'package:fahem/data/models/lawyers/lawyers/lawyer_model.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants/legal_accountant_model.dart';
import 'package:fahem/data/models/public_relations/public_relations/public_relation_model.dart';
import 'package:fahem/data/models/static/search_model.dart';
import 'package:fahem/presentation/features/lawyers/lawyers_reviews/controllers/lawyers_reviews_provider.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountant_reviews/controllers/legal_accountants_reviews_provider.dart';
import 'package:fahem/presentation/features/public_relations/public_relation_reviews/controllers/public_relations_reviews_provider.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/rating_bar.dart';
import 'package:fahem/presentation/shared/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchItem extends StatefulWidget {
  final SearchModel searchModel;
  final int index;

  const SearchItem({super.key, required this.searchModel, required this.index});

  @override
  State<SearchItem> createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {
  late AppProvider appProvider;
  late LawyersReviewsProvider lawyersReviewsProvider;
  late PublicRelationsReviewsProvider publicRelationsReviewsProvider;
  late LegalAccountantsReviewsProvider legalAccountantsReviewsProvider;

  List getReviews(String mainCategory) {
    if(mainCategory == 'lawyers') {
      return lawyersReviewsProvider.lawyersReviews.where((element) => element.lawyerId == widget.searchModel.lawyerId).toList();
    }
    else if(mainCategory == 'public_relations') {
      return publicRelationsReviewsProvider.publicRelationsReviews.where((element) => element.publicRelationId == widget.searchModel.publicRelationId).toList();
    }
    else if(mainCategory == 'legal_accountants') {
      return legalAccountantsReviewsProvider.legalAccountantsReviews.where((element) => element.legalAccountantId == widget.searchModel.legalAccountantId).toList();
    }
    else {
      return [];
    }
  }

  String getImageDirectory(String mainCategory) {
    if(mainCategory == 'lawyers') {
      return ApiConstants.lawyersDirectory;
    }
    else if(mainCategory == 'public_relations') {
      return ApiConstants.publicRelationsDirectory;
    }
    else if(mainCategory == 'legal_accountants') {
      return ApiConstants.legalAccountantsDirectory;
    }
    else {
      return ConstantsManager.empty;
    }
  }

  String getDetailsRoute(String mainCategory) {
    if(mainCategory == 'lawyers') {
      return Routes.lawyerDetailsRoute;
    }
    else if(mainCategory == 'public_relations') {
      return Routes.publicRelationDetailsRoute;
    }
    else if(mainCategory == 'legal_accountants') {
      return Routes.legalAccountantDetailsRoute;
    }
    else {
      return ConstantsManager.empty;
    }
  }

  String getModelArgument(String mainCategory) {
    if(mainCategory == 'lawyers') {
      return ConstantsManager.lawyerModelArgument;
    }
    else if(mainCategory == 'public_relations') {
      return ConstantsManager.publicRelationModelArgument;
    }
    else if(mainCategory == 'legal_accountants') {
      return ConstantsManager.legalAccountantModelArgument;
    }
    else {
      return ConstantsManager.empty;
    }
  }

  getModel(String mainCategory) {
    if(mainCategory == 'lawyers') {
      return LawyerModel.fromJson(SearchModel.toMap(widget.searchModel));
    }
    else if(mainCategory == 'public_relations') {
      return PublicRelationModel.fromJson(SearchModel.toMap(widget.searchModel));
    }
    else if(mainCategory == 'legal_accountants') {
      return LegalAccountantModel.fromJson(SearchModel.toMap(widget.searchModel));
    }
  }

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    lawyersReviewsProvider = Provider.of<LawyersReviewsProvider>(context, listen: false);
    publicRelationsReviewsProvider = Provider.of<PublicRelationsReviewsProvider>(context, listen: false);
    legalAccountantsReviewsProvider = Provider.of<LegalAccountantsReviewsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> reviews = getReviews(widget.searchModel.mainCategory);
    int totalReviews = reviews.length;

    return ZoomIn(
      duration: const Duration(milliseconds: 500),
      child: Container(
        padding: const EdgeInsets.all(SizeManager.s10),
        decoration: BoxDecoration(
          color: widget.index % 2 == 0 ? ColorsManager.primaryColor : ColorsManager.secondaryColor,
          borderRadius: BorderRadius.circular(SizeManager.s10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    Navigator.pushNamed(context, getDetailsRoute(widget.searchModel.mainCategory), arguments: {getModelArgument(widget.searchModel.mainCategory): getModel(widget.searchModel.mainCategory)});
                  },
                  child: SizedBox(
                    width: SizeManager.s50,
                    height: SizeManager.s50,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(SizeManager.s25),
                      child: CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${getImageDirectory(widget.searchModel.mainCategory)}/${widget.searchModel.personalImage}')),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(SizeManager.s10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                widget.searchModel.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.bold),
                              ),
                            ),
                            if(widget.searchModel.isVerified) ...[
                              const SizedBox(width: SizeManager.s5),
                              const Icon(Icons.verified, color: ColorsManager.white, size: SizeManager.s20),
                            ],
                          ],
                        ),
                        const SizedBox(height: SizeManager.s5),
                        Text(
                          widget.searchModel.jobTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const Divider(color: ColorsManager.white),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(ImagesManager.clipboardIc, color: ColorsManager.white, width: SizeManager.s15, height: SizeManager.s15),
                const SizedBox(width: SizeManager.s5),
                Expanded(
                  child: Wrap(
                    children: List.generate(widget.searchModel.tasks.length, (index) {
                      return Text(
                        '${widget.searchModel.tasks[index]} ${index == widget.searchModel.tasks.length-1 ? '' : '-'} ',
                        style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.white),
                      );
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SizeManager.s5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(ImagesManager.mapIc, color: ColorsManager.white, width: SizeManager.s15, height: SizeManager.s15),
                const SizedBox(width: SizeManager.s5),
                Expanded(
                  child: Text(
                    widget.searchModel.address,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: SizeManager.s5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(ImagesManager.moneyIc, color: ColorsManager.white, width: SizeManager.s15, height: SizeManager.s15),
                const SizedBox(width: SizeManager.s5),
                Text(
                  '${Methods.getText(StringsManager.consultationPrice, appProvider.isEnglish).toCapitalized()}: ${widget.searchModel.consultationPrice} ${Methods.getText(StringsManager.egyptianPound, appProvider.isEnglish).toUpperCase()}',
                  style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.white),
                ),
              ],
            ),
            const SizedBox(height: SizeManager.s10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Wrap(
                    spacing: SizeManager.s5,
                    runSpacing: SizeManager.s5,
                    children: List.generate(widget.searchModel.features.length, (index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(vertical: SizeManager.s1, horizontal: SizeManager.s10),
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(SizeManager.s10),
                          border: Border.all(color: ColorsManager.white),
                        ),
                        child: Text(
                          widget.searchModel.features[index],
                          style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.black),
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: SizeManager.s50),
                Column(
                  children: [
                    RatingBar(numberOfStars: widget.searchModel.rating),
                    Text(
                      '${Methods.getText(StringsManager.overallRatingOf, appProvider.isEnglish).toCapitalized()} $totalReviews ${Methods.getText(StringsManager.user, appProvider.isEnglish)}',
                      style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.white),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: SizeManager.s10),
            CustomButton(
              buttonType: ButtonType.text,
              onPressed: () {
                FocusScope.of(context).unfocus();
                Navigator.pushNamed(context, getDetailsRoute(widget.searchModel.mainCategory), arguments: {getModelArgument(widget.searchModel.mainCategory): getModel(widget.searchModel.mainCategory)});
              },
              text: Methods.getText(StringsManager.details, appProvider.isEnglish).toUpperCase(),
              height: SizeManager.s35,
              buttonColor: ColorsManager.white,
              textColor: widget.index % 2 == 0 ? ColorsManager.secondaryColor : ColorsManager.primaryColor,
              textFontWeight: FontWeightManager.bold,
            ),
          ],
        ),
      ),
    );
  }
}