import 'package:flutter/material.dart';

class DraggableConfig {
  static final double kTapSize = 20.0;
  static final double kMinTop = 56.0;
  static final double kMinLeft = 56.0;

  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;

  DraggableConfig({
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
  });
}

DraggableConfig defaultConfig = DraggableConfig(
  backgroundColor: Colors.black12,
  icon: Icons.more_horiz,
  iconColor: Colors.white,
);
