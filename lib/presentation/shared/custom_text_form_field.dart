import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final bool? enabled;
  final TextEditingController? controller;
  final TextDirection textDirection;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final Color? cursorColor;
  final bool autofocus;
  final int? maxLength;
  final int? maxLines;
  final bool obscureText;
  final TextStyle? style;
  final TextAlign textAlign;
  final Color? textColor;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  final void Function(String?)? onSaved;
  final double borderRadius;
  final Color? borderColor;
  final Color errorBorderColor;
  final String? labelText;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final TextStyle? errorStyle;
  final double? errorHeight;
  final EdgeInsetsGeometry? contentPadding;
  final double verticalPadding;
  final Color? fillColor;
  final Color? hintColor;
  final Color? labelColor;
  final FontWeight? labelFontWeight;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final EdgeInsetsGeometry? suffixIconPadding;
  final double prefixPadding;

  const CustomTextFormField({
    Key? key,
    this.enabled = true,
    this.controller,
    this.textDirection = TextDirection.ltr,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.cursorColor,
    this.autofocus = false,
    this.maxLength,
    this.maxLines = 1,
    this.obscureText = false,
    this.style,
    this.textAlign = TextAlign.start,
    this.textColor,
    this.onChanged,
    this.validator,
    this.onSaved,
    this.borderRadius = SizeManager.s15,
    this.borderColor,
    this.errorBorderColor = ColorsManager.red700,
    this.labelText,
    this.hintText,
    this.hintStyle,
    this.labelStyle,
    this.errorStyle,
    this.errorHeight,
    this.contentPadding,
    this.verticalPadding = SizeManager.s0,
    this.fillColor,
    this.hintColor = ColorsManager.grey,
    this.labelColor = ColorsManager.primaryColor,
    this.labelFontWeight,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixIconPadding,
    this.prefixPadding = SizeManager.s10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      controller: controller,
      textDirection: textDirection,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      cursorColor: cursorColor ?? (ColorsManager.black),
      autofocus: autofocus,
      maxLength: maxLength,
      maxLines: maxLines,
      obscureText: obscureText ? true : false,
      style: style ?? Theme.of(context).textTheme.titleMedium!.copyWith(color: textColor ?? (ColorsManager.black), fontWeight: FontWeightManager.bold),
      textAlign: textAlign,
      onChanged: onChanged,
      validator: validator,
      onSaved: onSaved,
      onTap: controller == null ? null : () {
        if(controller!.selection == TextSelection.fromPosition(TextPosition(offset: controller!.text.length -1))) {
          controller!.selection = TextSelection.fromPosition(TextPosition(offset: controller!.text.length));
        }
      },
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: borderColor ?? (ColorsManager.primaryColor), width: SizeManager.s1)),
        disabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: borderColor ?? (ColorsManager.primaryColor), width: SizeManager.s1)),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: borderColor ?? (ColorsManager.primaryColor), width: SizeManager.s1)),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: borderColor ?? (ColorsManager.primaryColor), width: SizeManager.s1)),
        errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: errorBorderColor, width: SizeManager.s1)),
        focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(borderRadius), borderSide: BorderSide(color: errorBorderColor, width: SizeManager.s1)),
        contentPadding: contentPadding ?? EdgeInsets.symmetric(horizontal: suffixIcon != null ? SizeManager.s0 : SizeManager.s10, vertical: verticalPadding),
        filled: true,
        fillColor: fillColor ?? (ColorsManager.white),
        hintText: hintText,
        labelText: labelText,
        hintStyle: hintStyle ?? Theme.of(context).textTheme.titleSmall!.copyWith(color: hintColor),
        labelStyle: labelStyle ?? Theme.of(context).textTheme.titleSmall!.copyWith(color: labelColor, fontWeight: labelFontWeight),
        errorStyle: errorStyle ?? Theme.of(context).textTheme.titleSmall!.copyWith(color: ColorsManager.red700, height: errorHeight),
        prefixIcon: prefixIcon != null ? Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(SizeManager.s20, SizeManager.s0, SizeManager.s10, SizeManager.s0),
          child: prefixIcon,
        ) : null,
        suffixIcon: suffixIcon != null ? Padding(
          padding: suffixIconPadding ?? const EdgeInsetsDirectional.fromSTEB(SizeManager.s0, SizeManager.s0, SizeManager.s10, SizeManager.s0),
          child: suffixIcon,
        ) : null,
        prefix: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(prefixPadding, SizeManager.s0, SizeManager.s0, SizeManager.s0),
        ),
      ),
    );
  }
}