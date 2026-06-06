import 'package:flutter/material.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';

/// Text-only / icon + text button — no fill.
/// Used on: "JOIN ROOM" on the home screen.
/// Can also render as a small dark pill ("Swipe" button on active vote cards).
enum AppSecondaryButtonVariant { text, darkPill }

class MySecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final IconData? leadingIcon;
  final AppSecondaryButtonVariant variant;
  final Color? textColor; 
  final Color ? iconColor; 
  final Color ? backgroundColor; 

  const MySecondaryButton({
    super.key,
    required this.text,
    this.onTap,
    this.leadingIcon,
    this.variant = AppSecondaryButtonVariant.text,
    this.textColor, 
    this.iconColor, 
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    if (variant == AppSecondaryButtonVariant.darkPill) {
      return _buildDarkPill();
    }
    return _buildTextButton();
  }

  /// "JOIN ROOM" style — primary-coloured text + icon, transparent bg
  Widget _buildTextButton() {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leadingIcon != null) ...[
              Icon(leadingIcon, color: AppColors.primary, size: AppSpacing.iconMd),
              const SizedBox(width: AppSpacing.sm),
            ],
            Text(
              text,
              style: AppTextStyles.buttonL.copyWith(color: textColor?? AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }

  /// Small black rounded pill — "Swipe" button on home active-vote card
  Widget _buildDarkPill() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: AppColors.blackSoft,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        ),
        child: Text(text, style: AppTextStyles.buttonDark),
      ),
    );
  }
}
