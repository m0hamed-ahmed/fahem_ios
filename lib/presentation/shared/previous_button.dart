import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:flutter/material.dart';

class PreviousButton extends StatelessWidget {
  final void Function()? onBackPressed;
  final bool isDark;
  final Color buttonColor;
  final Color iconColor;

  const PreviousButton({
    super.key,
    this.onBackPressed,
    this.isDark = false,
    this.buttonColor = ColorsManager.primaryColor,
    this.iconColor = ColorsManager.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeManager.s35,
      height: SizeManager.s35,
      decoration: BoxDecoration(
        color: isDark ? ColorsManager.white : buttonColor,
        shape: BoxShape.circle,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onBackPressed ?? () => Navigator.pop(context),
          borderRadius: BorderRadius.circular(SizeManager.s35),
          child: Icon(
            Icons.arrow_back_ios_rounded,
            color: isDark ? ColorsManager.black : iconColor,
            size: SizeManager.s20,
          ),
        ),
      ),
    );
  }
}