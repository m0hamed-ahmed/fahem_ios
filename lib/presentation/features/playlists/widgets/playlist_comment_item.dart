import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/playlists/playlist_comments/playlist_comment_model.dart';
import 'package:flutter/material.dart';

class PlaylistCommentItem extends StatefulWidget {
  final PlaylistCommentModel playlistCommentModel;

  const PlaylistCommentItem({super.key, required this.playlistCommentModel});

  @override
  State<PlaylistCommentItem> createState() => _PlaylistCommentItemState();
}

class _PlaylistCommentItemState extends State<PlaylistCommentItem> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(SizeManager.s10),
      decoration: BoxDecoration(
        color: ColorsManager.grey100,
        borderRadius: BorderRadius.circular(SizeManager.s10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${widget.playlistCommentModel.firstName} ${widget.playlistCommentModel.familyName}',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.bold),
                ),
              ),
              Text(
                Methods.formatDate(context: context, milliseconds: widget.playlistCommentModel.createdAt.millisecondsSinceEpoch),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          Text(
            widget.playlistCommentModel.comment,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      )
    );
  }
}