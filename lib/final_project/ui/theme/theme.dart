import 'package:flutter/material.dart';

/// COLORS
class AppColors {
  // PRIMARY COLORS
  static const Color primary = Color(0xFF7FBF3F);
  static const Color primaryDark = Color(0xFF4A8D17); 
  static const Color primaryLight = Color(0xFFA8E063);

  // BACKGROUND
  static const Color background = Color(0xFFF9FBF7);

  // TEXT (neutral, not blue!)
  static const Color textDark = Color(0xFF1B2B1B); 
  static const Color textLight = Color(0xFF6B7D6B); 

  // GREY
  static const Color greyLight = Color(0xFFE2E2E2);
}

/// TEXT STYLES
class AppTextStyles {
  static const TextStyle heading = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle title = TextStyle(
    fontSize: 18,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static TextStyle body = const TextStyle(
    fontSize: 14,
  ).copyWith(color: AppColors.textDark);
}

/// GLOBAL THEME
ThemeData appTheme = ThemeData(
  fontFamily: 'Eesti',
  scaffoldBackgroundColor: AppColors.background,

  colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary,
    primary: AppColors.primary,
    secondary: AppColors.primaryLight,
  ),

  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryDark,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  ),
);
