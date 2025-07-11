import 'package:flutter/material.dart';

class AppShadows {
  static List<BoxShadow> get generalShadow => [
    BoxShadow(
      color: Color(0x40000000),
      offset: Offset(1, 1),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  static List<BoxShadow> get strongShadow => [
    BoxShadow(
      color: Color(0x40000000),
      offset: Offset(2, 2),
      blurRadius: 4,
      spreadRadius: 4,
    ),
  ];
}
