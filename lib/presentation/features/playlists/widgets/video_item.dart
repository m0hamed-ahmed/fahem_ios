import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/playlists/playlists/playlist_model.dart';
import 'package:fahem/data/models/playlists/videos/video_model.dart';
import 'package:fahem/presentation/features/playlists/controllers/playlist_details_provider.dart';
import 'package:fahem/presentation/shared/cached_network_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class VideoItem extends StatefulWidget {
  final VideoModel videoModel;
  final PlaylistModel playlistModel;
  final int index;

  const VideoItem({Key? key, required this.videoModel, required this.playlistModel, required this.index}) : super(key: key);

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late AppProvider appProvider;
  late PlaylistDetailsProvider playlistDetailsProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    playlistDetailsProvider = Provider.of<PlaylistDetailsProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: playlistDetailsProvider.currentVideoIndex == widget.index ? ColorsManager.grey300 : ColorsManager.grey100,
      child: InkWell(
        onTap: () {
          playlistDetailsProvider.changeCurrentVideoIndex(widget.index);
          Navigator.pushReplacementNamed(context, Routes.playlistDetailsRoute, arguments: {ConstantsManager.playlistModelArgument: widget.playlistModel});
        },
        child: Container(
          padding: const EdgeInsets.all(SizeManager.s10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.antiAlias,
                width: SizeManager.s100,
                height: SizeManager.s100,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(SizeManager.s10),
                ),
                child: CachedNetworkImageWidget(image: Methods.getYoutubeThumbnail(YoutubePlayer.convertUrlToId(widget.videoModel.link)!)),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(SizeManager.s8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        appProvider.isEnglish ? widget.videoModel.titleEn : widget.videoModel.titleAr,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeightManager.bold),
                      ),
                      const SizedBox(height: SizeManager.s10),
                      Text(
                        Methods.formatDate(context: context, milliseconds: widget.videoModel.createdAt.millisecondsSinceEpoch),
                        style: Theme.of(context).textTheme.bodySmall
                      ),
                    ],
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}