import 'package:flutter/material.dart';

/// Voltify Design System – Color Tokens (Light Theme, Purple Primary)
/// Matched to Figma design.
abstract final class AppColors {
  // ──── Brand ────
  static const Color primary = Color(0xFF5B4FE9);
  static const Color primaryDark = Color(0xFF4F46E5);
  static const Color primaryLight = Color(0xFF7C73F0);

  // ──── Logo Gradient ────
  static const Color logoGradientStart = Color(0xFF1E3A5F);
  static const Color logoGradientEnd = Color(0xFF3B8D8C);

  // ──── Background ────
  static const Color background = Color(0xFFF9FAFB);
  static const Color white = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);

  // ──── Text ────
  static const Color textPrimary = Color(0xFF1A1A2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textLink = Color(0xFF5B4FE9);

  // ──── Input ────
  static const Color inputBackground = Color(0xFFFFFFFF);
  static const Color inputBorder = Color(0xFFD1D5DB);
  static const Color inputFocusBorder = Color(0xFF5B4FE9);

  // ──── Feedback ────
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEE2E2);
  static const Color success = Color(0xFF22C55E);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color warning = Color(0xFFFBBF24);

  // ──── Button ────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ──── Logo ────
  static const LinearGradient logoGradient = LinearGradient(
    colors: [logoGradientStart, logoGradientEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ──── Divider ────
  static const Color divider = Color(0xFFE5E7EB);
}
