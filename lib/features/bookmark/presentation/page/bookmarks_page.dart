import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';
import 'package:mero_choice_application/features/bookmark/presentation/view_model/bookmark_view_model.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';
import 'package:mero_choice_application/features/place/presentation/page/place_detail_page.dart';
import 'package:mero_choice_application/widgets/app_snackbar.dart';

class BookmarksPage extends ConsumerStatefulWidget {
  const BookmarksPage({super.key});

  @override
  ConsumerState<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends ConsumerState<BookmarksPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(bookmarkViewModelProvider.notifier).loadBookmarkedPlaces(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookmarkViewModelProvider);
    final displayPlaces = state.bookmarkedPlaces
        .where((p) => state.bookmarkedIds.contains(p.placeId))
        .toList();

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
          'Profile',
          style: AppTextStyles.headingM.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () => ref
            .read(bookmarkViewModelProvider.notifier)
            .loadBookmarkedPlaces(),
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
                'My Bookmarks',
                style: AppTextStyles.headingL.copyWith(
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Cards that you added to your bookmarks.',
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.x3l),
              if (state.isLoading)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                )
              else if (displayPlaces.isEmpty)
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 60),
                      Icon(Icons.bookmark_border_rounded,
                          size: 56, color: AppColors.textSecondary),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'No bookmarks yet',
                        style: AppTextStyles.bodyM
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: displayPlaces.length,
                  separatorBuilder: (_, __) =>
                      const SizedBox(height: AppSpacing.md),
                  itemBuilder: (_, i) => _BookmarkCard(
                    place: displayPlaces[i],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookmarkCard extends ConsumerWidget {
  final PlaceEntity place;
  const _BookmarkCard({required this.place});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PlaceDetailPage(place: place)),
      ),
      child: Container(
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
          // Circular image
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: CachedNetworkImage(
              imageUrl: place.image,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              placeholder: (ctx, url) => Container(
                width: 70,
                height: 70,
                color: AppColors.primaryBg,
              ),
              errorWidget: (ctx, url, err) => Container(
                width: 70,
                height: 70,
                color: AppColors.primaryBg,
                child: const Icon(Icons.image_not_supported_outlined,
                    color: AppColors.textSecondary),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category badge
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBg,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    place.category.toUpperCase(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  place.name,
                  style: AppTextStyles.titleL,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        size: 13, color: AppColors.textSecondary),
                    const SizedBox(width: 2),
                    Flexible(
                      child: Text(
                        place.location,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded,
                        size: 14, color: Color(0xFFFFC107)),
                    const SizedBox(width: 2),
                    Text(
                      place.rating.toStringAsFixed(1),
                      style: AppTextStyles.caption.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bookmark remove button
          GestureDetector(
            onTap: () async {
              final result = await ref
                  .read(bookmarkViewModelProvider.notifier)
                  .toggle(place.placeId);
              if (!context.mounted) return;
              if (result == false) {
                AppSnackBar.showSuccess(context, 'Removed from Bookmarks');
              } else if (result == null) {
                AppSnackBar.showError(context, 'Failed to update bookmark');
              }
            },
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AppColors.primaryBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.bookmark_rounded,
                color: AppColors.primary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}
