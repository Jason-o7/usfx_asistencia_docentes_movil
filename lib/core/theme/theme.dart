import 'package:flutter/material.dart';
import 'package:usfx_asistencia_docentes_movil/core/theme/app_palette.dart';
import 'package:usfx_asistencia_docentes_movil/core/theme/app_text_styles.dart';

class AppTheme {
  static final lightThemeMode = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppPalette.backgroundColor,
  );

  static ThemeData get lightTheme => ThemeData(
    fontFamily: 'Bahnschrift',
    textTheme: TextTheme(
      headlineLarge: AppTextStyles.title(color: AppPalette.darkTextColor),
      titleMedium: AppTextStyles.subtitle(color: AppPalette.darkTextColor),
      bodyMedium: AppTextStyles.body(color: AppPalette.darkTextColor),
      bodyLarge: AppTextStyles.bodyBold(color: AppPalette.darkTextColor),
    ),
  );
}
