import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String _sf       = 'SF';
  static const String _sfMedium = 'SF-Medium';

  // ─── Display ─────────────────────────────────────────────────────────────
  /// 30px bold primary — onboarding section headings
  static const TextStyle displayXL = TextStyle(
    fontFamily: _sf,
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  /// 24px bold dark — matched place name, large card headings
  static const TextStyle displayL = TextStyle(
    fontFamily: _sf,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// 22px bold dark — swipe card / place names
  static const TextStyle displayM = TextStyle(
    fontFamily: _sf,
    fontSize: 22,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // ─── Headings ────────────────────────────────────────────────────────────
  /// 28px bold primary — app name in top bar (onboarding)
  static const TextStyle headingXL = TextStyle(
    fontFamily: _sf,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  /// 20px bold dark — home greeting "Namaste"
  static const TextStyle headingL = TextStyle(
    fontFamily: _sf,
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// 18px bold dark — section titles "Active Votes", "Recent Matches"
  static const TextStyle headingM = TextStyle(
    fontFamily: _sf,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  /// 18px bold primary — AppBar centered title
  static const TextStyle appBarTitle = TextStyle(
    fontFamily: _sf,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  /// 25px w600 primary — "Welcome Back" / "Create Account" screen title
  static const TextStyle screenTitle = TextStyle(
    fontFamily: _sf,
    fontSize: 25,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  // ─── Title / Subtitle ────────────────────────────────────────────────────
  /// 16px SemiBold dark — card session names, list items
  static const TextStyle titleL = TextStyle(
    fontFamily: _sf,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
  );

  /// 16px bold black — place card names
  static const TextStyle titleM = TextStyle(
    fontFamily: _sf,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.black,
  );

  // ─── Body ────────────────────────────────────────────────────────────────
  /// 16px medium gray — onboarding body paragraphs
  static const TextStyle bodyL = TextStyle(
    fontFamily: _sf,
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  /// 14px medium dark — field labels, default body
  static const TextStyle bodyM = TextStyle(
    fontFamily: _sf,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
  );

  /// 13px regular gray — location, meta info below card titles
  static const TextStyle bodyS = TextStyle(
    fontFamily: _sf,
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// 12px regular gray — timestamps, small captions
  static const TextStyle caption = TextStyle(
    fontFamily: _sf,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// 11px medium gray uppercase letter-spaced — "ACTIVE MEMBERS"
  static const TextStyle overline = TextStyle(
    fontFamily: _sf,
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    letterSpacing: 1.2,
  );

  // ─── Price ───────────────────────────────────────────────────────────────
  /// 16px SemiBold primary — "Rs 250"
  static const TextStyle price = TextStyle(
    fontFamily: _sf,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrice,
  );

  // ─── Rating ──────────────────────────────────────────────────────────────
  /// 14px bold green — "4.5" beside star icon
  static const TextStyle rating = TextStyle(
    fontFamily: _sf,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.ratingGreen,
  );

  // ─── Buttons ─────────────────────────────────────────────────────────────
  /// 16px bold white — primary/gradient button label
  static const TextStyle buttonL = TextStyle(
    fontFamily: _sf,
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  /// 14px w600 white — small button label
  static const TextStyle buttonM = TextStyle(
    fontFamily: _sf,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  /// 14px bold black — dark pill "Swipe" button on home
  static const TextStyle buttonDark = TextStyle(
    fontFamily: _sf,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.white,
  );

  // ─── Numeric Keypad ──────────────────────────────────────────────────────
  /// 30px bold dark — keypad digit numbers
  static const TextStyle keypadNum = TextStyle(
    fontFamily: _sf,
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  // ─── Auth ────────────────────────────────────────────────────────────────
  /// 14px w500 gray — leading part of auth rich text
  static const TextStyle authLeading = TextStyle(
    fontFamily: _sf,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textTagline,
  );

  /// 14px bold primary — actionable part of auth rich text
  static const TextStyle authAction = TextStyle(
    fontFamily: _sf,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
  );

  // ─── Tagline ─────────────────────────────────────────────────────────────
  /// 14px w600 SF-Medium — "DECIDE TOGETHER, SILENTLY"
  static const TextStyle tagline = TextStyle(
    fontFamily: _sfMedium,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textTagline,
  );

  /// 18px w500 gray — "Skip" navigation text
  static const TextStyle skip = TextStyle(
    fontFamily: _sf,
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  /// 14px w500 gray — "Welcome back, Anish"
  static const TextStyle subGreeting = TextStyle(
    fontFamily: _sf,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
  );

  // ─── Hint ────────────────────────────────────────────────────────────────
  static const TextStyle hint = TextStyle(
    fontFamily: _sf,
    fontSize: 14,
    color: AppColors.iconHint,
  );
}
