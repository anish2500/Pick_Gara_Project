import 'package:flutter/material.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';

/// Full-width gradient pill button.
/// Used on: Join With Pin, Create Session, Return Home, Start Swiping, Create a room.
/// Supports optional leading icon (e.g. "+" on Create Session).
class MyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;
  final bool isLoading;
  final IconData? leadingIcon;
  final double? width;
  final double? height;

  const MyButton({
    super.key,
    required this.text,
    this.onTap,
    this.isLoading = false,
    this.leadingIcon,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: width ?? double.infinity,
        height: height ?? AppSpacing.buttonHeightLg,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryShadow,
              blurRadius: 20,
              spreadRadius: 1,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    color: AppColors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (leadingIcon != null) ...[
                      Icon(
                        leadingIcon,
                        color: AppColors.white,
                        size: AppSpacing.iconMd,
                      ),
                      const SizedBox(width: AppSpacing.sm),
                    ],
                    Text(text, style: AppTextStyles.buttonL),
                  ],
                ),
        ),
      ),
    );
  }
}
