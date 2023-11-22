import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/public_relations/public_relations_reviews/public_relation_review_model.dart';
import 'package:fahem/presentation/shared/rating_bar.dart';
import 'package:flutter/material.dart';

class PublicRelationReviewItem extends StatefulWidget {
  final PublicRelationReviewModel publicRelationReviewModel;
  final int index;
  
  const PublicRelationReviewItem({Key? key, required this.publicRelationReviewModel, required this.index}) : super(key: key);

  @override
  State<PublicRelationReviewItem> createState() => _PublicRelationReviewItemState();
}

class _PublicRelationReviewItemState extends State<PublicRelationReviewItem> {

  
  
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
            '${widget.publicRelationReviewModel.firstName} ${widget.publicRelationReviewModel.familyName}',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
          ),
          const SizedBox(height: SizeManager.s5),
          Row(
            children: [
              RatingBar(numberOfStars: widget.publicRelationReviewModel.rating),
              const SizedBox(width: SizeManager.s5),
              Text(
                widget.publicRelationReviewModel.rating.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Text(
                Methods.formatDate(context: context, milliseconds: widget.publicRelationReviewModel.createdAt.millisecondsSinceEpoch),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: SizeManager.s10),
          Text(
            widget.publicRelationReviewModel.comment,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}