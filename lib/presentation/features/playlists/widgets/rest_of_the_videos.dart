import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/data/models/playlists/playlists/playlist_model.dart';
import 'package:fahem/presentation/features/playlists/widgets/video_item.dart';
import 'package:flutter/material.dart';

class RestOfTheVideos extends StatefulWidget {
  final PlaylistModel playlistModel;

  const RestOfTheVideos({super.key, required this.playlistModel});

  @override
  State<RestOfTheVideos> createState() => _RestOfTheVideosState();
}

class _RestOfTheVideosState extends State<RestOfTheVideos> {

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: SizeManager.s16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => VideoItem(videoModel: widget.playlistModel.videos[index], playlistModel: widget.playlistModel, index: index),
      separatorBuilder: (context, index) => const Divider(color: ColorsManager.grey, height: SizeManager.s0),
      itemCount: widget.playlistModel.videos.length,
    );
  }
}