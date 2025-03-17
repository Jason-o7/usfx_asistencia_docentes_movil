import 'package:flutter/material.dart';
import 'package:usfx_asistencia_docentes_movil/core/theme/app_palette.dart';
import 'package:usfx_asistencia_docentes_movil/core/theme/app_shadows.dart';

// Siempre se pasa un contenido del tipo "Widget" a esta card
// el ancho y alto es opcional y cuando no se pasa se ajusta al contenido del hijo o a tamaño del padre
// margin es opcional
// padding es opcional y por defecto es 10
// centerContent es opcional y por defecto es true
class CustomCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry? margin;
  final bool centerContent;
  final double? width;
  final double? height;

  const CustomCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(10),
    this.margin,
    this.centerContent = true,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: _buildCardDecoration(),
      child: Padding(
        padding: padding,
        child: centerContent ? Center(child: child) : child,
      ),
    );
  }

  BoxDecoration _buildCardDecoration() => BoxDecoration(
    color: AppPalette.lightBackgroundColor,
    border: Border.all(
      color: AppPalette.darkEdgeColor,
      width: 1,
      style: BorderStyle.solid,
    ),
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    boxShadow: AppShadows.generalShadow,
  );
}
