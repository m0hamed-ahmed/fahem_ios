import 'package:fahem/core/resources/assets_manager.dart';
import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:flutter/material.dart';

class DefaultImage extends StatelessWidget {
  final BoxShape? shape;
  final double size;
  
  const DefaultImage({Key? key, this.shape, this.size = SizeManager.s100}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(SizeManager.s10),
      decoration: BoxDecoration(
        color: ColorsManager.secondaryDarkColor,
        borderRadius: shape == null ? BorderRadius.circular(SizeManager.s10) : null,
        shape: shape??BoxShape.rectangle,
      ),
      child: Image.asset(
        ImagesManager.logo,
        width: SizeManager.s100,
        height: SizeManager.s100,
        color: ColorsManager.black,
      ),
    );
  }
}