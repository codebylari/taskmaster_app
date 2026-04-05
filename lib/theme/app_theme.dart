import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {

  // 🌞 LIGHT
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,

      scaffoldBackgroundColor: Colors.white,

      primaryColor: AppColors.primary,

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.button,
          foregroundColor: AppColors.buttonText,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // 🌑 DARK (NOVO E CLEAN 🔥)
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,

      scaffoldBackgroundColor: AppColors.darkBackground,

      primaryColor: AppColors.darkPrimary,

      cardColor: AppColors.darkCard,

      dividerColor: Colors.white.withOpacity(0.1),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
        bodySmall: TextStyle(color: Colors.white54),
      ),

      iconTheme: const IconThemeData(
        color: Colors.white70,
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}