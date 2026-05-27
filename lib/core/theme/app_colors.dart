import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // ─── Primary Brand ────────────────────────────────────────────────────────
  static const Color primary       = Color(0xFF453CE1);
  static const Color primaryDark   = Color(0xFF3530C4);
  static const Color primaryLight  = Color(0xFF6C64D8);
  static const Color primaryShadow = Color(0x4D453CE1);
  static const Color primaryBg     = Color(0xFFF3F5FF);
  static const Color primaryPaleBg = Color(0xFFEEEDFF);

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // ─── Background & Surface ────────────────────────────────────────────────
  static const Color scaffoldBg = Color(0xFFFFFFFF);
  static const Color surface    = Color(0xFFFFFFFF);

  // ─── Text ────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFF1C1B2E);
  static const Color textDark      = Color(0xFF464555);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textTagline   = Color(0xFF60606A);
  static const Color textDisabled  = Color(0xFFC4C4C4);
  static const Color textWhite     = Color(0xFFFFFFFF);
  static const Color textPrice     = Color(0xFF453CE1);

  // ─── Icons & Hints ───────────────────────────────────────────────────────
  static const Color iconHint     = Color(0xFFC7C9D9);
  static const Color iconInactive = Color(0xFFB0B0B0);

  // ─── Semantic — Success ──────────────────────────────────────────────────
  static const Color success      = Color(0xFF22C759);
  static const Color successLight = Color(0xFFE6F9EE);

  // ─── Semantic — Error / Delete ───────────────────────────────────────────
  static const Color error        = Color(0xFFFF3B30);
  static const Color errorLight   = Color(0xFFFFEBEB);

  // ─── Semantic — Warning / Lightning ─────────────────────────────────────
  static const Color warning      = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFFF3E0);

  // ─── Accent ──────────────────────────────────────────────────────────────
  static const Color ratingGreen  = Color(0xFF246140);

  // ─── Neutrals ────────────────────────────────────────────────────────────
  static const Color black      = Color(0xFF000000);
  static const Color blackSoft  = Color(0xFF1C1C1E);
  static const Color white      = Color(0xFFFFFFFF);
  static const Color divider    = Color(0xFFE5E7EB);
  static const Color cardShadow = Color(0xFFBEBEBE);
  static const Color progressBg = Color(0xFFE5E7EB);

  // ─── Overlay / Scrim ─────────────────────────────────────────────────────
  static const Color overlay = Color(0x80000000);
}
