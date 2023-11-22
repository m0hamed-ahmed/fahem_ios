import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/constants_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:flutter/material.dart';

enum ButtonType {
  text, icon, image, preIcon, postIcon, preSpacerIcon, postSpacerIcon, preImage, postImage, preSpacerImage, postSpacerImage
}

class CustomButton extends StatelessWidget {
  final ButtonType buttonType;
  final Function()? onPressed;
  final double? width;
  final double? height;
  final Color buttonColor;
  final Color borderColor;
  final double borderRadius;
  final double borderWidth;
  final double elevation;
  final String text;
  final TextStyle? textStyle;
  final Color textColor;
  final double fontSize;
  final FontWeight textFontWeight;
  final IconData? iconData;
  final Color iconColor;
  final double iconSize;
  final String? imageName;
  final Color? imageColor;
  final double imageSize;

  const CustomButton({
    Key? key,
    required this.buttonType,
    this.onPressed,
    this.width = double.infinity,
    this.height = SizeManager.s45,
    this.buttonColor = ColorsManager.secondaryColor,
    this.borderColor = Colors.transparent,
    this.borderRadius = SizeManager.s15,
    this.borderWidth = SizeManager.s1,
    this.elevation = SizeManager.s0,
    this.text = ConstantsManager.empty,
    this.textStyle,
    this.textColor = ColorsManager.white,
    this.fontSize = SizeManager.s14,
    this.textFontWeight= FontWeightManager.black,
    this.iconData,
    this.iconColor = ColorsManager.white,
    this.iconSize = SizeManager.s16,
    this.imageName,
    this.imageColor,
    this.imageSize = SizeManager.s16,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed ?? () {},
      minWidth: width,
      height: height,
      color: buttonColor,
      elevation: elevation,
      hoverElevation: elevation,
      focusElevation: elevation,
      highlightElevation: elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(color: borderColor, width: borderWidth),
      ),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: _getButton(context),
    );
  }

  Widget _getButton(BuildContext context) {
    switch(buttonType) {
      case ButtonType.text: return _textButton(context);
      case ButtonType.icon: return _iconButton(context);
      case ButtonType.image: return _imageButton(context);
      case ButtonType.preIcon: return _preIconButton(context);
      case ButtonType.postIcon: return _postIconButton(context);
      case ButtonType.preSpacerIcon: return _preSpacerIconButton(context);
      case ButtonType.postSpacerIcon: return _postSpacerIconButton(context);
      case ButtonType.preImage: return _preImageButton(context);
      case ButtonType.postImage: return _postImageButton(context);
      case ButtonType.preSpacerImage: return _preSpacerImageButton(context);
      case ButtonType.postSpacerImage: return _postSpacerImageButton(context);
      default: return Container();
    }
  }

  Widget _textButton(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: textStyle ?? Theme.of(context).textTheme.displayMedium!.copyWith(color: textColor, fontSize: fontSize, fontWeight: textFontWeight),
    );
  }

  Widget _iconButton(BuildContext context) {
    return Icon(iconData, color: iconColor, size: iconSize);
  }

  Widget _imageButton(BuildContext context) {
    return Image.asset(imageName!, color: imageColor, width: imageSize, height: imageSize);
  }

  Widget _preIconButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(iconData, color: iconColor, size: iconSize),
        const SizedBox(width: SizeManager.s10),
        Flexible(
          child: FittedBox(
            child: Text(
              text,
              style: textStyle ?? Theme.of(context).textTheme.displayLarge!.copyWith(color: textColor, fontSize: fontSize, fontWeight: textFontWeight),
            ),
          ),
        ),
      ],
    );
  }

  Widget _postIconButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: FittedBox(
            child: Text(
              text,
              style: textStyle ?? Theme.of(context).textTheme.displayLarge!.copyWith(color: textColor, fontSize: fontSize, fontWeight: textFontWeight),
            ),
          ),
        ),
        const SizedBox(width: SizeManager.s10),
        Icon(iconData, color: iconColor, size: iconSize),
      ],
    );
  }

  Widget _preSpacerIconButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Icon(iconData, color: iconColor, size: iconSize),
        const SizedBox(width: SizeManager.s10),
        Flexible(
          child: FittedBox(
            child: Text(
              text,
              style: textStyle ?? Theme.of(context).textTheme.displayLarge!.copyWith(color: textColor, fontSize: fontSize, fontWeight: textFontWeight),
            ),
          ),
        ),
      ],
    );
  }

  Widget _postSpacerIconButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: FittedBox(
            child: Text(
              text,
              style: textStyle ?? Theme.of(context).textTheme.displayLarge!.copyWith(color: textColor, fontSize: fontSize, fontWeight: textFontWeight),
            ),
          ),
        ),
        const SizedBox(width: SizeManager.s10),
        Icon(iconData, color: iconColor, size: iconSize),
      ],
    );
  }

  Widget _preImageButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(imageName!, color: imageColor, width: imageSize, height: imageSize),
        const SizedBox(width: SizeManager.s10),
        Flexible(
          child: FittedBox(
            child: Text(
              text,
              style: textStyle ?? Theme.of(context).textTheme.displayLarge!.copyWith(color: textColor, fontSize: fontSize, fontWeight: textFontWeight),
            ),
          ),
        ),
      ],
    );
  }

  Widget _postImageButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Flexible(
          child: FittedBox(
            child: Text(
              text,
              style: textStyle ?? Theme.of(context).textTheme.displayLarge!.copyWith(color: textColor, fontSize: fontSize, fontWeight: textFontWeight),
            ),
          ),
        ),
        const SizedBox(width: SizeManager.s10),
        Image.asset(imageName!, color: imageColor, width: imageSize, height: imageSize),
      ],
    );
  }

  Widget _preSpacerImageButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Image.asset(imageName!, color: imageColor, width: imageSize, height: imageSize),
        const SizedBox(width: SizeManager.s10),
        Flexible(
          child: FittedBox(
            child: Text(
              text,
              style: textStyle ?? Theme.of(context).textTheme.displayLarge!.copyWith(color: textColor, fontSize: fontSize, fontWeight: textFontWeight),
            ),
          ),
        ),
      ],
    );
  }

  Widget _postSpacerImageButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: FittedBox(
            child: Text(
              text,
              style: textStyle ?? Theme.of(context).textTheme.displayLarge!.copyWith(color: textColor, fontSize: fontSize, fontWeight: textFontWeight),
            ),
          ),
        ),
        const SizedBox(width: SizeManager.s10),
        Image.asset(imageName!, color: imageColor, width: imageSize, height: imageSize),
      ],
    );
  }
}