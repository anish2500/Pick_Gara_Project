import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';
import 'package:mero_choice_application/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:mero_choice_application/features/match/domain/entities/match_entity.dart';
import 'package:mero_choice_application/features/match/presentation/state/match_state.dart';
import 'package:mero_choice_application/features/match/presentation/view_model/match_view_model.dart';

class MyActivityPage extends ConsumerStatefulWidget {
  const MyActivityPage({super.key});

  @override
  ConsumerState<MyActivityPage> createState() => _MyActivityPageState();
}

class _MyActivityPageState extends ConsumerState<MyActivityPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(matchViewModelProvider.notifier).loadMatches(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final matchState = ref.watch(matchViewModelProvider);
    final currentUserId = ref.watch(
      authViewModelProvider.select((s) => s.authEntity?.authId),
    );

    final hosted = matchState.matches
        .where((m) => m.hostId == currentUserId)
        .toList();
    final joined = matchState.matches
        .where((m) => m.hostId != currentUserId)
        .toList();
    final all = matchState.matches;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Profile',
          style: AppTextStyles.headingM.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () =>
            ref.read(matchViewModelProvider.notifier).loadMatches(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            AppSpacing.xl,
            AppSpacing.screenH,
            AppSpacing.x3l,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Activity',
                style: AppTextStyles.headingL.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Activities you hosted or joined',
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.x3l),

              // ── Stats card ────────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.xl,
                  vertical: AppSpacing.x3l,
                ),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.cardShadow.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _StatItem(
                      count: all.length,
                      label: 'ACTIVITIES',
                      isLarge: true,
                    ),
                    Container(
                      width: 1,
                      height: 40,
                      color: AppColors.divider,
                    ),
                    _StatItem(count: hosted.length, label: 'HOSTED'),
                    _StatItem(count: joined.length, label: 'JOINED'),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.x3l),

              // ── Activity list ─────────────────────────────────
              if (matchState.status == MatchStatus.loading)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              else if (all.isEmpty)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 40),
                      Icon(Icons.history_rounded,
                          size: 56, color: AppColors.textSecondary),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'No activities yet',
                        style: AppTextStyles.bodyM.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: all.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.xl),
                  itemBuilder: (_, i) => _ActivityItem(
                    match: all[i],
                    isHosted: all[i].hostId == currentUserId,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Stat number + label ───────────────────────────────────────
class _StatItem extends StatelessWidget {
  final int count;
  final String label;
  final bool isLarge;

  const _StatItem({
    required this.count,
    required this.label,
    this.isLarge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$count',
          style: isLarge
              ? AppTextStyles.headingL.copyWith(
                  color: AppColors.primary,
                  fontSize: 36,
                )
              : AppTextStyles.headingM,
        ),
        Text(
          label,
          style: AppTextStyles.caption.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

// ── Single activity row ───────────────────────────────────────
class _ActivityItem extends StatelessWidget {
  final MatchEntity match;
  final bool isHosted;

  const _ActivityItem({required this.match, required this.isHosted});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // Circular place image
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              child: CachedNetworkImage(
                imageUrl: match.winner.image,
                width: 56,
                height: 56,
                fit: BoxFit.cover,
                placeholder: (ctx, url) => Container(
                  width: 56,
                  height: 56,
                  color: AppColors.primaryBg,
                ),
                errorWidget: (ctx, url, err) => Container(
                  width: 56,
                  height: 56,
                  color: AppColors.primaryBg,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),

            // Room name + winner place
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    match.roomName,
                    style: AppTextStyles.titleL,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        size: 13,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 2),
                      Flexible(
                        child: Text(
                          match.winner.name,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: AppSpacing.sm),

            // Hosted / Joined badge
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isHosted ? AppColors.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                border: isHosted
                    ? null
                    : Border.all(color: AppColors.primary, width: 1.5),
              ),
              child: Text(
                isHosted ? 'Hosted' : 'Joined',
                style: AppTextStyles.caption.copyWith(
                  color: isHosted ? AppColors.white : AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),

        // Time ago below each item
        const SizedBox(height: AppSpacing.sm),
        Padding(
          padding: const EdgeInsets.only(left: 4),
          child: Text(
            _timeAgo(match.completedAt),
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes} minutes ago';
    if (diff.inHours < 24) return '${diff.inHours} hours ago';
    if (diff.inDays == 1) return '1 day ago';
    if (diff.inDays < 7) return '${diff.inDays} days ago';
    final weeks = (diff.inDays / 7).floor();
    return weeks == 1 ? '1 week ago' : '$weeks weeks ago';
  }
}
