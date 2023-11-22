import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants_reviews/legal_accountant_review_model.dart';
import 'package:fahem/presentation/shared/rating_bar.dart';
import 'package:flutter/material.dart';

class LegalAccountantReviewItem extends StatefulWidget {
  final List<LegalAccountantReviewModel> legalAccountantsReviews;
  final int index;

  const LegalAccountantReviewItem({super.key, required this.legalAccountantsReviews, required this.index});

  @override
  State<LegalAccountantReviewItem> createState() => _LegalAccountantReviewItemState();
}

class _LegalAccountantReviewItemState extends State<LegalAccountantReviewItem> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SizeManager.s16),
      decoration: BoxDecoration(
        color: widget.index % 2 == 0 ? ColorsManager.reviewColor : ColorsManager.white,
        border: widget.index % 2 == 0 ? const Border(
          top: BorderSide(color: ColorsManager.grey),
          bottom: BorderSide(color: ColorsManager.grey),
        ) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.legalAccountantsReviews[widget.index].firstName} ${widget.legalAccountantsReviews[widget.index].familyName}',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
          ),
          const SizedBox(height: SizeManager.s5),
          Row(
            children: [
              RatingBar(numberOfStars: widget.legalAccountantsReviews[widget.index].rating),
              const SizedBox(width: SizeManager.s5),
              Text(
                widget.legalAccountantsReviews[widget.index].rating.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Text(
                Methods.formatDate(context: context, milliseconds: widget.legalAccountantsReviews[widget.index].createdAt.millisecondsSinceEpoch),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: SizeManager.s10),
          Text(
            widget.legalAccountantsReviews[widget.index].comment,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}