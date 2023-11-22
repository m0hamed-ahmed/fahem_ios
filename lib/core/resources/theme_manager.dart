import 'package:fahem/core/resources/colors_manager.dart';
import 'package:fahem/core/resources/fonts_manager.dart';
import 'package:fahem/core/resources/values_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

MaterialColor buildMaterialColor(Color color) {
  List<double> strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red;
  final int g = color.green;
  final int b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (int i = 0; i < strengths.length; i++) {
    double strength = strengths[i];
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }
  return MaterialColor(color.value, swatch);
}

ThemeData getApplicationThemeLight() {
  return ThemeData(
    // Main Colors
    primarySwatch: buildMaterialColor(ColorsManager.primaryColor),

    // Default Font Family
    fontFamily: FontFamilyManager.avenirArabic,

    // AppBar Theme
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent, statusBarIconBrightness: Brightness.dark),
      backgroundColor: Colors.transparent,
      elevation: SizeManager.s0,
      titleTextStyle: TextStyle(
        color: ColorsManager.white,
        fontSize: SizeManager.s16,
        fontWeight: FontWeightManager.bold,
        fontFamily: FontFamilyManager.avenirArabic,
      ),
      iconTheme: IconThemeData(color: ColorsManager.white),
    ),

    // Text Theme
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: ColorsManager.primaryColor, fontSize: SizeManager.s16, fontWeight: FontWeightManager.medium),
      titleMedium: TextStyle(color: ColorsManager.primaryColor, fontSize: SizeManager.s14, fontWeight: FontWeightManager.medium),
      titleSmall: TextStyle(color: ColorsManager.primaryColor, fontSize: SizeManager.s12, fontWeight: FontWeightManager.medium),

      bodyLarge: TextStyle(color: ColorsManager.black, fontSize: SizeManager.s16, fontWeight: FontWeightManager.medium),
      bodyMedium: TextStyle(color: ColorsManager.black, fontSize: SizeManager.s14, fontWeight: FontWeightManager.medium),
      bodySmall: TextStyle(color: ColorsManager.black, fontSize: SizeManager.s12, fontWeight: FontWeightManager.medium),

      displayLarge: TextStyle(color: ColorsManager.grey, fontSize: SizeManager.s16, fontWeight: FontWeightManager.medium),
      displayMedium: TextStyle(color: ColorsManager.grey, fontSize: SizeManager.s14, fontWeight: FontWeightManager.medium),
      displaySmall: TextStyle(color: ColorsManager.grey, fontSize: SizeManager.s12, fontWeight: FontWeightManager.medium),
    ),
  );
}