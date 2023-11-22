import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/enums.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/playlists/playlists/playlist_model.dart';
import 'package:fahem/presentation/features/playlists/controllers/playlist_details_provider.dart';
import 'package:fahem/presentation/features/playlists/widgets/about_video.dart';
import 'package:fahem/presentation/features/playlists/widgets/playlist_comments.dart';
import 'package:fahem/presentation/features/playlists/widgets/rest_of_the_videos.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PlaylistDetailsScreen extends StatefulWidget {
  final PlaylistModel playlistModel;

  const PlaylistDetailsScreen({super.key, required this.playlistModel});

  @override
  State<PlaylistDetailsScreen> createState() => _PlaylistDetailsScreenState();
}

class _PlaylistDetailsScreenState extends State<PlaylistDetailsScreen> {
  late AppProvider appProvider;
  late PlaylistDetailsProvider playlistDetailsProvider;
  late YoutubePlayerController _youtubePlayerController;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
    playlistDetailsProvider = Provider.of<PlaylistDetailsProvider>(context, listen: false);

    if(widget.playlistModel.videos.isNotEmpty) {
      _youtubePlayerController = YoutubePlayerController(
        initialVideoId: YoutubePlayer.convertUrlToId(widget.playlistModel.videos[playlistDetailsProvider.currentVideoIndex].link)!,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => playlistDetailsProvider.onBackPressed(),
      child: Directionality(
        textDirection: Methods.getDirection(appProvider.isEnglish),
        child: Scaffold(
          appBar: AppBar(
            leading: const Padding(
              padding: EdgeInsets.all(SizeManager.s10),
              child: PreviousButton(),
            ),
            title: Text(
              appProvider.isEnglish ? widget.playlistModel.playlistNameEn : widget.playlistModel.playlistNameAr,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
            ),
          ),
          body: SafeArea(
            child: widget.playlistModel.videos.isEmpty ? Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(SizeManager.s16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Lottie.asset(ImagesManager.notFound, width: SizeManager.s200, height: SizeManager.s200),
                    Text(
                      Methods.getText(StringsManager.noVideosFound, appProvider.isEnglish).toCapitalized(),
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontSize: SizeManager.s20),
                    ),
                  ],
                ),
              ),
            ) : Selector<PlaylistDetailsProvider, int>(
              selector: (context, provider) => provider.currentVideoIndex,
              builder: (context, currentVideoIndex, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      color: ColorsManager.grey1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          YoutubePlayerBuilder(
                            player: YoutubePlayer(controller: _youtubePlayerController),
                            builder: (context, player) => player,
                          ),
                          const SizedBox(height: SizeManager.s10),
                          Padding(
                            padding: const EdgeInsets.all(SizeManager.s16),
                            child: Text(
                              appProvider.isEnglish ? widget.playlistModel.videos[currentVideoIndex].titleEn : widget.playlistModel.videos[currentVideoIndex].titleAr,
                              style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeightManager.bold),
                            ),
                          ),
                          const SizedBox(height: SizeManager.s10),
                          Selector<PlaylistDetailsProvider, PlaylistsMode>(
                            selector: (context, provider) => provider.playlistsMode,
                            builder: (context, playlistsMode, _) {
                              return Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      color: playlistsMode == PlaylistsMode.aboutVideo ? ColorsManager.white : ColorsManager.grey1,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => playlistDetailsProvider.changePlaylistsMode(PlaylistsMode.aboutVideo),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: SizeManager.s10),
                                            child: Text(
                                              Methods.getText(StringsManager.aboutTheVideo, appProvider.isEnglish).toTitleCase(),
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.primaryColor, fontWeight: FontWeightManager.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: playlistsMode == PlaylistsMode.restOfTheVideos ? ColorsManager.white : ColorsManager.grey1,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => playlistDetailsProvider.changePlaylistsMode(PlaylistsMode.restOfTheVideos),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: SizeManager.s10),
                                            child: Text(
                                              Methods.getText(StringsManager.playlist, appProvider.isEnglish).toTitleCase(),
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.primaryColor, fontWeight: FontWeightManager.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      color: playlistsMode == PlaylistsMode.comments ? ColorsManager.white : ColorsManager.grey1,
                                      child: Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                          onTap: () => playlistDetailsProvider.changePlaylistsMode(PlaylistsMode.comments),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: SizeManager.s10),
                                            child: Text(
                                              Methods.getText(StringsManager.comments, appProvider.isEnglish).toTitleCase(),
                                              textAlign: TextAlign.center,
                                              style: Theme.of(context).textTheme.titleLarge!.copyWith(color: ColorsManager.primaryColor, fontWeight: FontWeightManager.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Selector<PlaylistDetailsProvider, PlaylistsMode>(
                        selector: (context, provider) => provider.playlistsMode,
                        builder: (context, playlistsMode, _) {
                          return SingleChildScrollView(
                            child: Column(
                              children: [
                                if(playlistsMode == PlaylistsMode.aboutVideo) AboutVideo(playlistModel: widget.playlistModel),
                                if(playlistsMode == PlaylistsMode.restOfTheVideos) RestOfTheVideos(playlistModel: widget.playlistModel),
                                if(playlistsMode == PlaylistsMode.comments) PlaylistComments(playlistModel: widget.playlistModel),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    if(widget.playlistModel.videos.isNotEmpty) {_youtubePlayerController.dispose();}
    super.dispose();
  }
}