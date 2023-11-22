import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/data/models/playlists/playlists/playlist_model.dart';
import 'package:fahem/presentation/features/playlists/controllers/playlist_details_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AboutVideo extends StatefulWidget {
  final PlaylistModel playlistModel;

  const AboutVideo({super.key, required this.playlistModel});

  @override
  State<AboutVideo> createState() => _AboutVideoState();
}

class _AboutVideoState extends State<AboutVideo> {
  late AppProvider appProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(SizeManager.s16),
      child: Selector<PlaylistDetailsProvider, int>(
        selector: (context, provider) => provider.currentVideoIndex,
        builder: (context, currentVideoIndex, _) {
          return Text(
            appProvider.isEnglish ? widget.playlistModel.videos[currentVideoIndex].aboutVideoEn : widget.playlistModel.videos[currentVideoIndex].aboutVideoAr,
            style: Theme.of(context).textTheme.bodyMedium,
          );
        }
      ),
    );
  }
}