import 'package:flutter/material.dart';
import 'package:usfx_asistencia_docentes_movil/core/theme/app_palette.dart';

abstract class AppTextStyles {
  // Base de estilos de texto
  static const TextStyle _baseStyle = TextStyle(
    fontFamily: 'Bahnschrift',
    color: AppPalette.darkTextColor,
  );

  // Título principal
  static TextStyle title({Color? color}) => _baseStyle.copyWith(
    fontSize: 24,
    fontWeight: FontWeight.w600, // Semi-bold
    color: color ?? AppPalette.darkTextColor,
  );

  // Subtítulo
  static TextStyle subtitle({Color? color}) => _baseStyle.copyWith(
    fontSize: 20,
    fontWeight: FontWeight.normal,
    color: color ?? AppPalette.darkTextColor,
  );

  // Texto normal para cuerpo
  static TextStyle body({Color? color}) => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: color ?? AppPalette.darkTextColor,
  );

  // Texto en negrilla para énfasis
  static TextStyle bodyBold({Color? color}) => _baseStyle.copyWith(
    fontSize: 16,
    fontWeight: FontWeight.bold, // Bold
    color: color ?? AppPalette.darkTextColor,
  );
}
