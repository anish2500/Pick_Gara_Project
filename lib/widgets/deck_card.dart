import 'package:flutter/material.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';

/// Category selection card used on "Create a Room" screen.
/// Shows image + label; selected state shows primary border.
class DeckCard extends StatelessWidget {
  final String imageAsset;  // 'assets/images/momo.jpg'
  final String label;       // 'Momo'
  final bool isSelected;
  final VoidCallback? onTap;

  const DeckCard({
    super.key,
    required this.imageAsset,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Image tile ──────────────────────────────────────────
          AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            width: AppSpacing.deckCardSize,
            height: AppSpacing.deckCardSize,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: isSelected
                  ? Border.all(color: AppColors.primary, width: 2.5)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: AppColors.cardShadow.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              child: Image.asset(
                imageAsset,
                fit: BoxFit.cover,
              ),
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          // ── Label ───────────────────────────────────────────────
          Text(
            label,
            style: AppTextStyles.bodyM.copyWith(
              color: isSelected ? AppColors.primary : AppColors.textDark,
              fontWeight:
                  isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
