import 'package:cached_network_image/cached_network_image.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/core/utils/methods.dart';
import 'package:fahem/presentation/shared/previous_button.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:fahem/core/network/api_constants.dart';
import 'package:fahem/core/resources/colors_manager.dart';

class ShowFullImageScreen extends StatefulWidget {
  final String image;
  final String directory;

  const ShowFullImageScreen({super.key, required this.image, required this.directory});

  @override
  State<ShowFullImageScreen> createState() => _ShowFullImageScreenState();
}

class _ShowFullImageScreenState extends State<ShowFullImageScreen> {
  late AppProvider appProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Methods.getDirection(appProvider.isEnglish),
      child: Scaffold(
        backgroundColor: ColorsManager.black,
        appBar: AppBar(
          toolbarHeight: SizeManager.s0,
        ),
        body: Stack(
          children: [
            CachedNetworkImage(
              imageUrl: ApiConstants.fileUrl(fileName: '${widget.directory}/${widget.image}'),
              placeholder: (context, url) {
                return Shimmer.fromColors(
                  baseColor: ColorsManager.grey300,
                  highlightColor: ColorsManager.grey100,
                  direction: appProvider.isEnglish ? ShimmerDirection.ltr : ShimmerDirection.rtl,
                  child: Container(
                    width: double.infinity,
                    height: double.infinity,
                    color: ColorsManager.grey,
                  ),
                );
              },
              errorWidget: (context, url, error) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  color: ColorsManager.grey,
                  child: Container(),
                );
              },
              imageBuilder: (context, imageProvider) {
                return PhotoView(imageProvider: imageProvider);
              },
            ),
            const PositionedDirectional(
              top: SizeManager.s16,
              start: SizeManager.s16,
              child: PreviousButton(),
            ),
          ],
        ),
      ),
    );
  }
}