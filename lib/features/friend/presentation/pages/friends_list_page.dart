import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';
import 'package:mero_choice_application/features/friend/domain/entities/friend_entity.dart';
import 'package:mero_choice_application/features/friend/presentation/state/friend_state.dart';
import 'package:mero_choice_application/features/friend/presentation/view_model/friend_view_model.dart';

class FriendsListPage extends ConsumerStatefulWidget {
  const FriendsListPage({super.key});

  @override
  ConsumerState<FriendsListPage> createState() => _FriendsListPageState();
}

class _FriendsListPageState extends ConsumerState<FriendsListPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(friendViewModelProvider.notifier).loadFriends(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(friendViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.primary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Friends List',
          style: AppTextStyles.headingM.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () =>
            ref.read(friendViewModelProvider.notifier).loadFriends(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenH,
            AppSpacing.xl,
            AppSpacing.screenH,
            AppSpacing.x3l,
          ),
          child: Column(
            children: [
              // ── Stats card ──────────────────────────────────
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.x3l,
                  horizontal: AppSpacing.xl,
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
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${state.totalFriends}',
                            style: AppTextStyles.headingL.copyWith(
                              color: AppColors.primary,
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'FRIENDS',
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 1,
                      height: 48,
                      color: AppColors.divider,
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            '${state.totalSharedActivities}',
                            style: AppTextStyles.headingL.copyWith(
                              color: AppColors.primary,
                              fontSize: 32,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'SHARED\nACTIVITIES',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.caption.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppSpacing.x3l),

              // ── Friends list ────────────────────────────────
              if (state.status == FriendStatus.loading)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              else if (state.status == FriendStatus.error)
                Center(
                  child: Text(
                    state.errorMessage ?? 'Something went wrong',
                    style: AppTextStyles.bodyM
                        .copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                )
              else if (state.friends.isEmpty)
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),
                    Icon(Icons.group_outlined,
                        size: 56, color: AppColors.textSecondary),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      'No friends yet',
                      style: AppTextStyles.bodyM
                          .copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Complete a session with others to see them here',
                      style: AppTextStyles.caption
                          .copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                  ],
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: state.friends.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (_, i) =>
                      _FriendCard(friend: state.friends[i]),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FriendCard extends StatelessWidget {
  final FriendEntity friend;
  const _FriendCard({required this.friend});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar with primary ring
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.primary, width: 2.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(2),
              child: ClipOval(
                child: friend.profileImage != null
                    ? CachedNetworkImage(
                        imageUrl: friend.profileImage!,
                        fit: BoxFit.cover,
                        placeholder: (ctx, url) => Container(
                          color: AppColors.primaryBg,
                        ),
                        errorWidget: (ctx, url, err) => Container(
                          color: AppColors.primaryBg,
                          child: const Icon(Icons.person_rounded,
                              color: AppColors.primary),
                        ),
                      )
                    : Container(
                        color: AppColors.primaryBg,
                        child: const Icon(Icons.person_rounded,
                            color: AppColors.primary),
                      ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Name + shared activities
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  friend.fullName,
                  style: AppTextStyles.titleL,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${friend.sharedActivities} shared '
                  '${friend.sharedActivities == 1 ? 'activity' : 'activities'}',
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
