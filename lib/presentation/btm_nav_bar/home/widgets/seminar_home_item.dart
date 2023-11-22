import 'package:fahem/core/network/api_constants.dart';
import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/routes_manager.dart';
import 'package:fahem/core/resources/strings_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/extensions.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/data/models/playlists/playlists/playlist_model.dart';
import 'package:fahem/presentation/shared/cached_network_image_widget.dart';
import 'package:fahem/presentation/shared/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaylistHomeItem extends StatefulWidget {
  final PlaylistModel playlistModel;
  final int index;

  const PlaylistHomeItem({super.key, required this.playlistModel, required this.index});

  @override
  State<PlaylistHomeItem> createState() => _PlaylistHomeItemState();
}

class _PlaylistHomeItemState extends State<PlaylistHomeItem> {
  late AppProvider appProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: MediaQuery.of(context).size.width * 0.7,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(SizeManager.s10),
      ),
      child: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: CachedNetworkImageWidget(image: ApiConstants.fileUrl(fileName: '${ApiConstants.playlistsDirectory}/${widget.playlistModel.image}')),
          ),
          Image.asset(
            ImagesManager.lines3,
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.fill,
            color: widget.index % 2 == 0 ? ColorsManager.primaryColor : ColorsManager.secondaryColor,
          ),
          Container(
            width: double.infinity,
            color: ColorsManager.black.withOpacity(0.5),
            padding: const EdgeInsets.all(SizeManager.s10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  appProvider.isEnglish ? widget.playlistModel.playlistNameEn : widget.playlistModel.playlistNameAr,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(color: ColorsManager.white, fontWeight: FontWeightManager.black),
                ),
                Text(
                  '${widget.playlistModel.videos.length} ${Methods.getText(StringsManager.videos, appProvider.isEnglish).toCapitalized()}',
                  style: Theme.of(context).textTheme.displayMedium!.copyWith(color: ColorsManager.white),
                ),
                Row(
                  children: [
                    CustomButton(
                      buttonType: ButtonType.text,
                      onPressed: () => Navigator.pushNamed(context, Routes.playlistDetailsRoute, arguments: {ConstantsManager.playlistModelArgument: widget.playlistModel}),
                      text: Methods.getText(StringsManager.watch, appProvider.isEnglish).toTitleCase(),
                      width: null,
                      height: SizeManager.s35,
                      borderRadius: SizeManager.s10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}