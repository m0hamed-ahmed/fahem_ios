import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/legal_accountants/legal_accountants_reviews/legal_accountant_review_model.dart';
import 'package:fahem/presentation/shared/rating_bar.dart';
import 'package:flutter/material.dart';

class LegalAccountantReviewItem extends StatefulWidget {
  final LegalAccountantReviewModel legalAccountantReviewModel;
  final int index;
  
  const LegalAccountantReviewItem({super.key, required this.legalAccountantReviewModel, required this.index});

  @override
  State<LegalAccountantReviewItem> createState() => _LegalAccountantReviewItemState();
}

class _LegalAccountantReviewItemState extends State<LegalAccountantReviewItem> {

  
  
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: SizeManager.s16, vertical: SizeManager.s8),
      decoration: BoxDecoration(
        color: widget.index % 2 == 0 ? ColorsManager.secondaryColor.withOpacity(0.5) : ColorsManager.primaryColor.withOpacity(0.5),
        borderRadius: BorderRadius.circular(SizeManager.s10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${widget.legalAccountantReviewModel.firstName} ${widget.legalAccountantReviewModel.familyName}',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
          ),
          const SizedBox(height: SizeManager.s5),
          Row(
            children: [
              RatingBar(numberOfStars: widget.legalAccountantReviewModel.rating),
              const SizedBox(width: SizeManager.s5),
              Text(
                widget.legalAccountantReviewModel.rating.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Text(
                Methods.formatDate(context: context, milliseconds: widget.legalAccountantReviewModel.createdAt.millisecondsSinceEpoch),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: SizeManager.s10),
          Text(
            widget.legalAccountantReviewModel.comment,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}