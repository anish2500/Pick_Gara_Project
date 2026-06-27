import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';
import 'package:mero_choice_application/features/bookmark/presentation/view_model/bookmark_view_model.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';
import 'package:mero_choice_application/features/place/presentation/page/place_detail_page.dart';
import 'package:mero_choice_application/features/place/presentation/state/explore_state.dart';
import 'package:mero_choice_application/features/place/presentation/view_model/explore_view_model.dart';
import 'package:mero_choice_application/widgets/app_snackbar.dart';

class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(exploreViewModelProvider.notifier).loadPlaces();
      ref.read(bookmarkViewModelProvider.notifier).loadBookmarks();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(exploreViewModelProvider);

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Explore',
          style: AppTextStyles.headingM.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        color: AppColors.primary,
        onRefresh: () =>
            ref.read(exploreViewModelProvider.notifier).loadPlaces(),
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(child: _buildSearchBar()),
            SliverToBoxAdapter(child: _buildCategoryChips(state)),
            _buildBody(state),
          ],
        ),
      ),
    );
  }

  // ── Search bar ────────────────────────────────────────────
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.md,
        AppSpacing.screenH,
        AppSpacing.lg,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withValues(alpha: 0.10),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: TextField(
          controller: _searchController,
          onChanged: (v) =>
              ref.read(exploreViewModelProvider.notifier).updateSearch(v),
          decoration: InputDecoration(
            hintText: 'Search places, cafes, hikes...',
            hintStyle: AppTextStyles.bodyM.copyWith(
              color: AppColors.textSecondary,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppColors.textSecondary,
            ),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(
              vertical: AppSpacing.md,
            ),
          ),
        ),
      ),
    );
  }

  // ── Category chips ────────────────────────────────────────
  Widget _buildCategoryChips(ExploreState state) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
        itemCount: state.categories.length,
        separatorBuilder: (_, i) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (_, i) {
          final cat = state.categories[i];
          final selected = cat == state.selectedCategory;
          return _CategoryChip(
            label: _categoryLabel(cat),
            icon: _categoryIcon(cat),
            selected: selected,
            onTap: () =>
                ref.read(exploreViewModelProvider.notifier).selectCategory(cat),
          );
        },
      ),
    );
  }

  // ── Main body ─────────────────────────────────────────────
  Widget _buildBody(ExploreState state) {
    if (state.status == ExploreStatus.loading) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      );
    }

    if (state.status == ExploreStatus.error) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.error_outline_rounded,
                  size: 48, color: AppColors.textSecondary),
              const SizedBox(height: AppSpacing.md),
              Text(
                state.errorMessage ?? 'Something went wrong',
                style: AppTextStyles.bodyM
                    .copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                ),
                onPressed: () =>
                    ref.read(exploreViewModelProvider.notifier).loadPlaces(),
                child: Text(
                  'Retry',
                  style: AppTextStyles.buttonM
                      .copyWith(color: AppColors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    final places = state.filteredPlaces;

    if (places.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off_rounded,
                  size: 48, color: AppColors.textSecondary),
              const SizedBox(height: AppSpacing.md),
              Text(
                'No places found',
                style: AppTextStyles.bodyM
                    .copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenH,
        AppSpacing.xl,
        AppSpacing.screenH,
        AppSpacing.x3l,
      ),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (_, i) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: _PlaceCard(
              place: places[i],
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlaceDetailPage(place: places[i]),
                ),
              ),
            ),
          ),
          childCount: places.length,
        ),
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────
  String _categoryLabel(String cat) {
    switch (cat.toLowerCase()) {
      case 'all':
        return 'All';
      case 'momo':
        return 'Momo';
      case 'cafe':
        return 'Cafes';
      case 'hiking':
        return 'Hiking';
      case 'restaurant':
        return 'Restaurant';
      default:
        return cat[0].toUpperCase() + cat.substring(1);
    }
  }

  IconData? _categoryIcon(String cat) {
    switch (cat.toLowerCase()) {
      case 'all':
        return null;
      case 'momo':
        return Icons.set_meal_outlined;
      case 'cafe':
        return Icons.coffee_outlined;
      case 'hiking':
        return Icons.terrain_outlined;
      case 'restaurant':
        return Icons.restaurant_outlined;
      default:
        return Icons.place_outlined;
    }
  }
}

// ── Category chip widget ──────────────────────────────────────
class _CategoryChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.progressBg,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: selected ? AppColors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                fontWeight: FontWeight.w600,
                color: selected ? AppColors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Place card widget ─────────────────────────────────────────
class _PlaceCard extends ConsumerWidget {
  final PlaceEntity place;
  final VoidCallback onTap;

  const _PlaceCard({required this.place, required this.onTap});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isBookmarked = ref.watch(
      bookmarkViewModelProvider.select((s) => s.isBookmarked(place.placeId)),
    );
    return GestureDetector(
      onTap: onTap,
      child: Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.10),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Image with overlays ──────────────────────────
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppSpacing.radiusXl),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Place image
                  CachedNetworkImage(
                    imageUrl: place.image,
                    fit: BoxFit.cover,
                    placeholder: (ctx, url) => Container(
                      color: AppColors.primaryBg,
                      child: const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.primary,
                          strokeWidth: 2,
                        ),
                      ),
                    ),
                    errorWidget: (ctx, url, err) => Container(
                      color: AppColors.primaryBg,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: AppColors.textSecondary,
                        size: 40,
                      ),
                    ),
                  ),

                  // Rating badge — top left
                  Positioned(
                    top: AppSpacing.md,
                    left: AppSpacing.md,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star_rounded,
                              color: Color(0xFFFFB800), size: 14),
                          const SizedBox(width: 3),
                          Text(
                            place.rating.toStringAsFixed(1),
                            style: AppTextStyles.caption.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bookmark — top right
                  Positioned(
                    top: AppSpacing.md,
                    right: AppSpacing.md,
                    child: GestureDetector(
                      onTap: () async {
                        final added = await ref
                            .read(bookmarkViewModelProvider.notifier)
                            .toggle(place.placeId);
                        if (!context.mounted) return;
                        if (added == null) {
                          AppSnackBar.showError(
                              context, 'Failed to update bookmark');
                        } else if (added) {
                          AppSnackBar.showSuccess(
                              context, 'Added to Bookmarks');
                        } else {
                          AppSnackBar.showSuccess(
                              context, 'Removed from Bookmarks');
                        }
                      },
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: isBookmarked
                              ? AppColors.primary
                              : AppColors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isBookmarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          color: isBookmarked
                              ? AppColors.white
                              : AppColors.textSecondary,
                          size: 18,
                        ),
                      ),
                    ),
                  ),

                  // Category badge — bottom right
                  Positioned(
                    bottom: AppSpacing.md,
                    right: AppSpacing.md,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Text(
                        _capitalise(place.category),
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Info row ─────────────────────────────────────
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                // Name + location
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        place.name,
                        style: AppTextStyles.titleL,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 14,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 3),
                          Expanded(
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
                    ],
                  ),
                ),

                const SizedBox(width: AppSpacing.md),

                // Price range pill
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBg,
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusFull),
                  ),
                  child: Text(
                    place.priceRange,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      ),
    );
  }

  String _capitalise(String s) =>
      s.isEmpty ? s : s[0].toUpperCase() + s.substring(1);
}
