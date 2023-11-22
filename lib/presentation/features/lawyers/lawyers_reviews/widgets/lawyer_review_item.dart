import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/lawyers/lawyers_reviews/lawyer_review_model.dart';
import 'package:fahem/presentation/shared/rating_bar.dart';
import 'package:flutter/material.dart';

class LawyerReviewItem extends StatefulWidget {
  final LawyerReviewModel lawyerReviewModel;
  final int index;

  const LawyerReviewItem({super.key, required this.lawyerReviewModel, required this.index});

  @override
  State<LawyerReviewItem> createState() => _LawyerReviewItemState();
}

class _LawyerReviewItemState extends State<LawyerReviewItem> {

  
  
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
            '${widget.lawyerReviewModel.firstName} ${widget.lawyerReviewModel.familyName}',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
          ),
          const SizedBox(height: SizeManager.s5),
          Row(
            children: [
              RatingBar(numberOfStars: widget.lawyerReviewModel.rating),
              const SizedBox(width: SizeManager.s5),
              Text(
                widget.lawyerReviewModel.rating.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Text(
                Methods.formatDate(context: context, milliseconds: widget.lawyerReviewModel.createdAt.millisecondsSinceEpoch),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: SizeManager.s10),
          Text(
            widget.lawyerReviewModel.comment,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}