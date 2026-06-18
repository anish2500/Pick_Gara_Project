import 'package:flutter/material.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';
import 'package:mero_choice_application/widgets/my_secondary_button.dart';

/// A ranked vote item row inside the active session card.
class VoteItem {
  final int rank;
  final String name;
  final int voteCount;
  final int totalVotes;

  const VoteItem({
    required this.rank,
    required this.name,
    required this.voteCount,
    required this.totalVotes,
  });
}

/// Active session / vote card shown on the Home screen.
/// Shows session name, time, member count, ranked vote list, and Swipe action.
class ActiveSessionCard extends StatelessWidget {
  final String sessionName; // 'Friday Movie Night'
  final String startedTime; // 'Started 10 min ago'
  final int memberCount; // 5
  final int totalMembers; // 7
  final List<VoteItem> voteItems; // ranked options
  final double progress; // 0.0 – 1.0
  final List<String> avatarAssets; // list of image paths for avatar group
  final VoidCallback? onSwipe;
  final String buttonText; // 'Swipe' for members, 'Open' for host

  const ActiveSessionCard({
    super.key,
    required this.sessionName,
    required this.startedTime,
    required this.memberCount,
    required this.totalMembers,
    required this.voteItems,
    required this.progress,
    required this.avatarAssets,
    this.onSwipe,
    this.buttonText = 'Swipe',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Session Header ───────────────────────────────────────
          Row(
            children: [
              const Icon(
                Icons.circle,
                color: AppColors.success,
                size: AppSpacing.iconXS,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(child: Text(sessionName, style: AppTextStyles.titleL)),
            ],
          ),

          const SizedBox(height: AppSpacing.xs),

          // ── Meta — time + members ────────────────────────────────
          Row(
            children: [
              const Icon(
                Icons.access_time_rounded,
                size: AppSpacing.iconXS,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(startedTime, style: AppTextStyles.caption),
              const SizedBox(width: AppSpacing.md),
              const Icon(
                Icons.people_outline,
                size: AppSpacing.iconXS,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: AppSpacing.xs),
              Text(
                '$memberCount / $totalMembers',
                style: AppTextStyles.caption,
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // ── Vote Leaderboard ─────────────────────────────────────
          for (final item in voteItems)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: _VoteRow(item: item),
            ),

          const SizedBox(height: AppSpacing.sm),

          // ── Footer: avatars + progress + Swipe ──────────────────
          Row(
            children: [
              // Avatar overlap (simplified — use AppAvatarGroup widget)
              // Show real assets if provided, else colored circles for real members
              if (avatarAssets.isNotEmpty)
                ...avatarAssets
                    .take(3)
                    .map(
                      (a) => Align(
                        widthFactor: 0.65,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundImage: AssetImage(a),
                        ),
                      ),
                    )
              else
                ...List.generate(memberCount.clamp(0, 3), (i) {
                  const avatarColors = [
                    Color(0xFF453CE1),
                    Color(0xFF6C63FF),
                    Color(0xFF8E85FF),
                  ];
                  return Align(
                    widthFactor: 0.65,
                    child: CircleAvatar(
                      radius: 14,
                      backgroundColor: avatarColors[i % avatarColors.length],
                      child: const Icon(
                        Icons.person_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                  );
                }),

              const SizedBox(width: AppSpacing.md),

              // Progress bar
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: AppColors.progressBg,
                    valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                  ),
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              MySecondaryButton(
                text: buttonText,
                onTap: onSwipe,
                variant: AppSecondaryButtonVariant.darkPill,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Single ranked vote row inside the active session card.
class _VoteRow extends StatelessWidget {
  final VoteItem item;
  const _VoteRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final frac = item.totalVotes > 0 ? item.voteCount / item.totalVotes : 0.0;

    return Row(
      children: [
        // Rank number
        SizedBox(
          width: 18,
          child: Text(
            '${item.rank}',
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),

        // Option name
        Expanded(flex: 3, child: Text(item.name, style: AppTextStyles.bodyM)),

        // Progress bar
        Expanded(
          flex: 4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: LinearProgressIndicator(
              value: frac,
              minHeight: 5,
              backgroundColor: AppColors.progressBg,
              valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ),

        const SizedBox(width: AppSpacing.sm),

        // Vote count
        Text(
          '${item.voteCount}',
          style: AppTextStyles.bodyM.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
