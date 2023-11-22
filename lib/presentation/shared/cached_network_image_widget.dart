import 'package:cached_network_image/cached_network_image.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/utils/app_provider.dart';
import 'package:fahem/presentation/shared/default_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class CachedNetworkImageWidget extends StatefulWidget {
  final String image;

  const CachedNetworkImageWidget({Key? key, required this.image}) : super(key: key);

  @override
  State<CachedNetworkImageWidget> createState() => _CachedNetworkImageWidgetState();
}

class _CachedNetworkImageWidgetState extends State<CachedNetworkImageWidget> {
  late AppProvider appProvider;

  @override
  void initState() {
    super.initState();
    appProvider = Provider.of<AppProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.image,
      placeholder: (context, url) {
        return Shimmer.fromColors(
          baseColor: ColorsManager.grey300,
          highlightColor: ColorsManager.grey100,
          direction: appProvider.isEnglish ? ShimmerDirection.ltr : ShimmerDirection.rtl,
          child: Container(
            width: double.infinity,
            color: ColorsManager.grey,
          ),
        );
      },
      errorWidget: (context, url, error) {
        return Container(
          width: double.infinity,
          color: ColorsManager.grey,
          child: const DefaultImage(),
        );
      },
      imageBuilder: (context, imageProvider) {
        return Container(
          decoration: BoxDecoration(
            image: DecorationImage(image: imageProvider, fit: BoxFit.fill),
          ),
        );
      },
    );
  }
}