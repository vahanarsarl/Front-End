import 'package:flutter/material.dart';
import 'package:vahanar_front/constants.dart'; // ✅ Correction de l'import

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppConstants.primaryColor,
    scaffoldBackgroundColor: AppConstants.backgroundColor,
    colorScheme: ColorScheme.light(
      primary: AppConstants.primaryColor,
      secondary: AppConstants.secondaryColor,
    ),
    textTheme: TextTheme(
      headlineLarge: TextStyle( //  Mise à jour du nom de la propriété
        fontSize: AppConstants.titleSize,
        fontWeight: FontWeight.bold,
        color: AppConstants.textColor,
        fontFamily: 'LeagueSpartan',
      ),
      bodyLarge: TextStyle( //  Mise à jour du nom de la propriété
        fontSize: AppConstants.bodyTextSize,
        color: AppConstants.textColor,
        fontFamily: 'LeagueSpartan',
      ),
      titleMedium: TextStyle( //  Mise à jour du nom de la propriété
        fontSize: AppConstants.subtitleSize,
        color: AppConstants.textColor,
        fontFamily: 'LeagueSpartan',
      ),
    ),
  );
}
