import 'package:fahem/core/network/api_constants.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/transactions/instant_consultations_comments/instant_consultation_comment_model.dart';
import 'package:fahem/data/models/lawyers/lawyers/lawyer_model.dart';
import 'package:fahem/presentation/features/lawyers/lawyers/controllers/lawyers_provider.dart';
import 'package:fahem/presentation/shared/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InstantConsultationCommentItem extends StatefulWidget {
  final InstantConsultationCommentModel instantConsultationCommentModel;
  final int index;
  final bool? isSupportOnTap;
  final Color? boxColor;

  const InstantConsultationCommentItem({
    super.key,
    required this.instantConsultationCommentModel,
    required this.index,
    this.isSupportOnTap = true,
    this.boxColor,
  });

  @override
  State<InstantConsultationCommentItem> createState() => _InstantConsultationCommentItemState();
}

class _InstantConsultationCommentItemState extends State<InstantConsultationCommentItem> {
  late LawyerModel lawyerModel;

  @override
  void initState() {
    super.initState();
    LawyersProvider lawyersProvider = Provider.of<LawyersProvider>(context, listen: false);
    lawyerModel = lawyersProvider.getLawyerWithId(widget.instantConsultationCommentModel.lawyerId)!;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.boxColor ?? (widget.index % 2 == 0 ? ColorsManager.comment1 : ColorsManager.comment2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isSupportOnTap! ? () => Navigator.pushNamed(context, Routes.lawyerDetailsRoute, arguments: {ConstantsManager.lawyerModelArgument: lawyerModel}) : null,
          child: Padding(
            padding: const EdgeInsets.all(SizeManager.s16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: widget.isSupportOnTap! ? () => Navigator.pushNamed(context, Routes.lawyerDetailsRoute, arguments: {ConstantsManager.lawyerModelArgument: lawyerModel}) : null,
                  child: SizedBox(
                    width: SizeManager.s60,
                    height: SizeManager.s60,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(SizeManager.s30),
                      child: CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${ApiConstants.lawyersDirectory}/${lawyerModel.personalImage}')),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: SizeManager.s10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                lawyerModel.name,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.bold),
                              ),
                            ),
                            const SizedBox(width: SizeManager.s5),
                            Text(
                              Methods.formatDate(context: context, milliseconds: widget.instantConsultationCommentModel.createdAt.millisecondsSinceEpoch),
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: SizeManager.s5),
                        Text(
                          widget.instantConsultationCommentModel.comment,
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.medium),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}