import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/public_relations/public_relations_reviews/public_relation_review_model.dart';
import 'package:fahem/presentation/shared/rating_bar.dart';
import 'package:flutter/material.dart';

class ReviewItem extends StatefulWidget {
  final List<PublicRelationReviewModel> publicRelationsReviews;
  final int index;

  const ReviewItem({Key? key, required this.publicRelationsReviews, required this.index}) : super(key: key);

  @override
  State<ReviewItem> createState() => _ReviewItemState();
}

class _ReviewItemState extends State<ReviewItem> {

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
            '${widget.publicRelationsReviews[widget.index].firstName} ${widget.publicRelationsReviews[widget.index].familyName}',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
          ),
          const SizedBox(height: SizeManager.s5),
          Row(
            children: [
              RatingBar(numberOfStars: widget.publicRelationsReviews[widget.index].rating),
              const SizedBox(width: SizeManager.s5),
              Text(
                widget.publicRelationsReviews[widget.index].rating.toString(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Spacer(),
              Text(
                Methods.formatDate(context: context, milliseconds: widget.publicRelationsReviews[widget.index].createdAt.millisecondsSinceEpoch),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: SizeManager.s10),
          Text(
            widget.publicRelationsReviews[widget.index].comment,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}