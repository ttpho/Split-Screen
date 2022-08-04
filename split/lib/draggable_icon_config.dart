import 'package:flutter/material.dart';

class DraggableIconConfig {
  static final double kTapSize = 20.0;
  static final double kMinTop = 56.0;
  static final double kMinLeft = 56.0;

  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;

  DraggableIconConfig({
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
  });
}
