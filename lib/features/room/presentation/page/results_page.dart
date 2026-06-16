import 'package:flutter/material.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';

class ResultsPage extends StatelessWidget {
  final PlaceEntity winner;
  final int totalVotes;
  final String roomName;
  final int memberCount;

  const ResultsPage({
    super.key,
    required this.winner,
    required this.totalVotes,
    required this.roomName,
    this.memberCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primary,
          ),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/dashboard',
            (route) => false,
          ),
        ),
        title: Text(
          'Match Found',
          style: AppTextStyles.headingM.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: AppSpacing.xl),

            // ── Winner place card ─────────────────────────────
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(AppSpacing.radiusXl),
                    ),
                    child: Image.network(
                      winner.image,
                      width: double.infinity,
                      height: 210,
                      fit: BoxFit.cover,
                      errorBuilder: (_, e, trace) => Container(
                        height: 210,
                        color: AppColors.primaryBg,
                        child: const Icon(
                          Icons.image_not_supported_outlined,
                          color: AppColors.primary,
                          size: 40,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.md,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                winner.name,
                                style: AppTextStyles.headingM,
                              ),
                            ),
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              winner.rating.toStringAsFixed(1),
                              style: AppTextStyles.bodyM.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          winner.location,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          winner.priceRange,
                          style: AppTextStyles.bodyM.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.x3l),

            // ── Group ready text ──────────────────────────────
            Text(
              'Your group is ready to go!',
              style: AppTextStyles.headingM,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.xl),

            // ── Overlapping member avatars ─────────────────────
            if (memberCount > 0) _MemberAvatars(count: memberCount),

            const SizedBox(height: AppSpacing.md),

            Text(
              'Session: $roomName',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),

            const Spacer(),

            // ── Return Home button ────────────────────────────
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/dashboard',
                  (route) => false,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  'Return Home',
                  style: AppTextStyles.buttonM.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.x3l),
          ],
        ),
      ),
    );
  }
}

class _MemberAvatars extends StatelessWidget {
  final int count;

  const _MemberAvatars({required this.count});

  static const List<Color> _avatarColors = [
    Color(0xFF453CE1),
    Color(0xFF6C63FF),
    Color(0xFF8E85FF),
    Color(0xFFB3AEFF),
  ];

  @override
  Widget build(BuildContext context) {
    const double avatarSize = 48.0;
    const double overlap = 16.0;
    final displayCount = count.clamp(1, 4);
    final totalWidth =
        avatarSize + (displayCount - 1) * (avatarSize - overlap);

    return SizedBox(
      width: totalWidth,
      height: avatarSize,
      child: Stack(
        children: List.generate(displayCount, (i) {
          return Positioned(
            left: i * (avatarSize - overlap),
            child: Container(
              width: avatarSize,
              height: avatarSize,
              decoration: BoxDecoration(
                color: _avatarColors[i % _avatarColors.length],
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white,
                  width: 2.5,
                ),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppColors.white,
                size: 22,
              ),
            ),
          );
        }),
      ),
    );
  }
}
