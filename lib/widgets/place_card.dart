import 'package:flutter/material.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';

/// Place/restaurant card — image at top, details below.
/// Used on: Swiping Room (large swipe card), Match Found screen, Recent Matches list.
class PlaceCard extends StatelessWidget {
  final String imageAsset;   // 'assets/images/cafe.jpg'
  final String name;         // 'Momo Nation'
  final String location;     // 'Jhamsikhel, Kathmandu'
  final String price;        // 'Rs 250'
  final double rating;       // 4.5
  final double? width;
  final double? imageHeight;
  final VoidCallback? onTap;

  const PlaceCard({
    super.key,
    required this.imageAsset,
    required this.name,
    required this.location,
    required this.price,
    required this.rating,
    this.width,
    this.imageHeight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image ───────────────────────────────────────────────
            ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppSpacing.radiusLg),
                topRight: Radius.circular(AppSpacing.radiusLg),
              ),
              child: Image.asset(
                imageAsset,
                width: double.infinity,
                height: imageHeight ?? AppSpacing.cardImageHeight,
                fit: BoxFit.cover,
              ),
            ),

            // ── Details ─────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name + Rating
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(name, style: AppTextStyles.displayM),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppColors.ratingGreen,
                              size: AppSpacing.iconSm),
                          const SizedBox(width: AppSpacing.xs),
                          Text(rating.toStringAsFixed(1),
                              style: AppTextStyles.rating),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),

                  // Location
                  Text(location, style: AppTextStyles.bodyS),
                  const SizedBox(height: AppSpacing.xs),

                  // Price
                  Text(price, style: AppTextStyles.price),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
