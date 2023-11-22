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
import 'package:fahem/data/models/legal_accountants/legal_accountants/legal_accountant_model.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants_reviews/legal_accountant_review_model.dart';
import 'package:fahem/presentation/features/legal_accountants/legal_accountant_reviews/controllers/legal_accountants_reviews_provider.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:fahem/presentation/shared/rating_bar.dart';
import 'package:fahem/presentation/shared/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LegalAccountantItem extends StatefulWidget {
  final LegalAccountantModel legalAccountantModel;
  final int index;

  const LegalAccountantItem({super.key, required this.legalAccountantModel, required this.index});

  @override
  State<LegalAccountantItem> createState() => _LegalAccountantItemState();
}

class _LegalAccountantItemState extends State<LegalAccountantItem> {
  late AppProvider appProvider;
  late LegalAccountantsReviewsProvider legalAccountantsReviewsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    legalAccountantsReviewsProvider = Provider.of<LegalAccountantsReviewsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LegalAccountantsReviewsProvider>(
      builder: (context, provider, _) {
        List<LegalAccountantReviewModel> legalAccountantsReviews = legalAccountantsReviewsProvider.legalAccountantsReviews.where((element) => element.legalAccountantId == widget.legalAccountantModel.legalAccountantId).toList();
        int totalReviews = legalAccountantsReviews.length;

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
                        Navigator.pushNamed(context, Routes.legalAccountantDetailsRoute, arguments: {ConstantsManager.legalAccountantModelArgument: widget.legalAccountantModel});
                      },
                      child: SizedBox(
                        width: SizeManager.s50,
                        height: SizeManager.s50,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(SizeManager.s25),
                          child: CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${ApiConstants.legalAccountantsDirectory}/${widget.legalAccountantModel.personalImage}')),
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
                                    widget.legalAccountantModel.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.bold),
                                  ),
                                ),
                                if(widget.legalAccountantModel.isVerified) ...[
                                  const SizedBox(width: SizeManager.s5),
                                  const Icon(Icons.verified, color: ColorsManager.white, size: SizeManager.s20),
                                ],
                              ],
                            ),
                            const SizedBox(height: SizeManager.s5),
                            Text(
                              widget.legalAccountantModel.jobTitle,
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
                        children: List.generate(widget.legalAccountantModel.tasks.length, (index) {
                          return Text(
                            '${widget.legalAccountantModel.tasks[index]} ${index == widget.legalAccountantModel.tasks.length-1 ? '' : '-'} ',
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
                        widget.legalAccountantModel.address,
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
                      '${Methods.getText(StringsManager.consultationPrice, appProvider.isEnglish).toCapitalized()}: ${widget.legalAccountantModel.consultationPrice} ${Methods.getText(StringsManager.egyptianPound, appProvider.isEnglish).toUpperCase()}',
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
                        children: List.generate(widget.legalAccountantModel.features.length, (index) {
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: SizeManager.s1, horizontal: SizeManager.s10),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(SizeManager.s10),
                              border: Border.all(color: ColorsManager.white),
                            ),
                            child: Text(
                              widget.legalAccountantModel.features[index],
                              style: Theme.of(context).textTheme.displaySmall!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.black),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(width: SizeManager.s50),
                    Column(
                      children: [
                        RatingBar(numberOfStars: widget.legalAccountantModel.rating),
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
                    Navigator.pushNamed(context, Routes.legalAccountantDetailsRoute, arguments: {ConstantsManager.legalAccountantModelArgument: widget.legalAccountantModel});
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
      },
    );
  }
}