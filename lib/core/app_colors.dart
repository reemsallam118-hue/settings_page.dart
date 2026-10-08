import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFA8434B);
  static const Color background = Color(0xFFF5EDE4);
  static const Color darkBackground = Color(0xFF1C1714);
  static const Color text = Color(0xFF2D2420);
  static const Color muted = Color(0xFF776B65);
  static const Color card = Color(0xFFFFFBF7);
}

extension AppThemeColors on BuildContext {
  Color get bg {
    return Theme.of(this).brightness == Brightness.dark
        ? AppColors.darkBackground
        : AppColors.background;
  }

  Color get card {
    return Theme.of(this).brightness == Brightness.dark
        ? const Color(0xFF2A2421)
        : AppColors.card;
  }

  Color get textColor {
    return Theme.of(this).brightness == Brightness.dark
        ? Colors.white
        : AppColors.text;
  }

  Color get mutedColor {
    return Theme.of(this).brightness == Brightness.dark
        ? Colors.white70
        : AppColors.muted;
  }
}
