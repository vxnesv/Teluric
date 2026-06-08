import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background  = Color(0xFF060B14);
  static const Color surface     = Color(0xFF0D1520);
  static const Color card        = Color(0xFF111C2C);
  static const Color cardLight   = Color(0xFF1A2638);

  // Cores
  static const Color primary     = Color(0xFF99FF00);
  static const Color primaryDark = Color(0xFF78CC00);
  static const Color secondary   = Color(0xFF00C8FF);
  static const Color amber       = Color(0xFFA444F6);
  static const Color danger      = Color(0xFFFF5252);

  // Texto
  static const Color textPrimary   = Color(0xFFF0F4F8);
  static const Color textSecondary = Color(0xFF7A8FA6);
  static const Color textMuted     = Color(0xFF3A4A5C);

  // Gradientes
  static const LinearGradient brandGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient brandGradientVertical = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient bgGradient = LinearGradient(
    colors: [Color(0xFF060B14), Color(0xFF0A1628)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF131E2D), Color(0xFF0D1520)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
