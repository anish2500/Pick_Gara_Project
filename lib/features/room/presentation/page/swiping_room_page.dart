import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_entity.dart';
import 'package:mero_choice_application/features/room/presentation/page/waiting_room_page.dart';
import 'package:mero_choice_application/features/room/presentation/state/swipe_session_state.dart';
import 'package:mero_choice_application/features/room/presentation/view_model/swipe_session_view_model.dart';
import 'package:mero_choice_application/widgets/app_snackbar.dart';

const _kSuperVoteColors = Color(0xFF7C3AED);

class SwipingRoomPage extends ConsumerStatefulWidget {
  final RoomEntity room;

  const SwipingRoomPage({super.key, required this.room});

  @override
  ConsumerState<SwipingRoomPage> createState() => _SwipingRoomPageState();
}

class _SwipingRoomPageState extends ConsumerState<SwipingRoomPage> {
  bool _showSuperVoteBanner = false;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref
          .read(swipeSessionViewModelProvider.notifier)
          .loadRoom(widget.room.roomId!);
    });
  }

  Future<void> _onSuperVoteTap() async {
    setState(() => _showSuperVoteBanner = true);
    ref
        .read(swipeSessionViewModelProvider.notifier)
        .superVote(widget.room.roomId!);
    await Future.delayed(const Duration(milliseconds: 1600));
    if (mounted) setState(() => _showSuperVoteBanner = false);
  }

  @override
  Widget build(BuildContext context) {
    final swipeState = ref.watch(swipeSessionViewModelProvider);

    ref.listen<SwipeSessionState>(swipeSessionViewModelProvider, (_, current) {
      if (current.status == SwipeStatus.error) {
        AppSnackBar.showError(
          context,
          current.errorMessage ?? 'Failed to load session',
        );
      } else if (current.status == SwipeStatus.completed &&
          current.detail != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => WaitingRoomPage(
              room: widget.room,
              detail: current.detail!,
              voteStats: current.voteStats,
            ),
          ),
        );
      }
    });

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
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/dashboard',
            (route) => false,
          ),
        ),
        title: Text(
          'Swiping Room',
          style: AppTextStyles.headingM.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: Stack(
  children: [
    _buildBody(swipeState),
    if (_showSuperVoteBanner)
      const Positioned(
        top: 80,
        left: 24,
        right: 24,
        child: _SuperVoteBanner(),
      ),
  ],
),

    );
  }

  Widget _buildBody(SwipeSessionState swipeState) {
    switch (swipeState.status) {
      case SwipeStatus.initial:
      case SwipeStatus.loading:
        return const Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        );
      case SwipeStatus.error:
        return Center(
          child: Text(
            swipeState.errorMessage ?? 'Something went wrong',
            style: AppTextStyles.bodyM,
          ),
        );
      case SwipeStatus.completed:
        return _buildCompletedView(swipeState);
      case SwipeStatus.loaded:
        return _buildSwipeView(swipeState);
    }
  }

  Widget _buildSwipeView(SwipeSessionState swipeState) {
    final detail = swipeState.detail!;
    final totalCards = detail.places.length;
    final votedCount = swipeState.currentIndex;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.lg),

          // ── Votes row ─────────────────────────────────────
          Row(
            children: [
              Text(
                'Votes: ',
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                swipeState.voteStats?.display ?? '$votedCount/$totalCards',
                style: AppTextStyles.bodyM.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.people_rounded,
                      size: 14,
                      color: AppColors.primary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${detail.memberCount}',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),

          // ── Progress bar ───────────────────────────────────
          ClipRRect(
            borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            child: LinearProgressIndicator(
              value: totalCards > 0 ? votedCount / totalCards : 0,
              backgroundColor: AppColors.progressBg,
              color: AppColors.primary,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Category pill ──────────────────────────────────
          Center(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.restaurant_menu_rounded,
                    color: AppColors.white,
                    size: 16,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Voting: ${detail.room.name}',
                    style: AppTextStyles.bodyM.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // ── Card stack ─────────────────────────────────────
          SizedBox(
            height: 360,
            child: _SwipeCardStack(
              places: detail.places,
              currentIndex: swipeState.currentIndex,
              showSuperVoteGlow: _showSuperVoteBanner,
              onLike: () => ref
                  .read(swipeSessionViewModelProvider.notifier)
                  .swipeLike(widget.room.roomId!),
              onDislike: () => ref
                  .read(swipeSessionViewModelProvider.notifier)
                  .swipeDislike(widget.room.roomId!),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),

          // ── Action buttons ─────────────────────────────────
          _buildActionButtons(swipeState.hasSuperVote),
          const SizedBox(height: AppSpacing.x3l),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool hasSuperVote) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ActionButton(
          icon: Icons.close_rounded,
          color: AppColors.error,
          backgroundColor: AppColors.white,
          size: 52,
          onTap: () => ref
              .read(swipeSessionViewModelProvider.notifier)
              .swipeDislike(widget.room.roomId!),
        ),
        const SizedBox(width: AppSpacing.xl),
        _ActionButton(
          icon: Icons.favorite_rounded,
          color: AppColors.white,
          backgroundColor: AppColors.primary,
          size: 64,
          onTap: () => ref
              .read(swipeSessionViewModelProvider.notifier)
              .swipeLike(widget.room.roomId!),
        ),
        const SizedBox(width: AppSpacing.xl),
        _SuperVoteButton(
          isUsed: hasSuperVote,
          onTap: hasSuperVote ? null : _onSuperVoteTap,
        ),
      ],
    );
  }

  Widget _buildCompletedView(SwipeSessionState swipeState) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.primaryBg,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.primary,
                size: 40,
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('All Done!', style: AppTextStyles.headingL),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'You liked ${swipeState.likedPlaceIds.length} places.',
              style: AppTextStyles.bodyM.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.x3l),
            ElevatedButton(
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                context,
                '/dashboard',
                (route) => false,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.x3l,
                  vertical: 14,
                ),
              ),
              child: Text(
                'Back to Home',
                style: AppTextStyles.buttonM.copyWith(color: AppColors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwipeCardStack extends StatefulWidget {
  final List<PlaceEntity> places;
  final int currentIndex;
  final bool showSuperVoteGlow;
  final VoidCallback onLike;
  final VoidCallback onDislike;

  const _SwipeCardStack({
    required this.places,
    required this.currentIndex,
    required this.showSuperVoteGlow,
    required this.onLike,
    required this.onDislike,
  });

  @override
  State<_SwipeCardStack> createState() => _SwipeCardStackState();
}

class _SwipeCardStackState extends State<_SwipeCardStack> {
  double _offsetX = 0;
  double _offsetY = 0;

  static const double _swipeThreshold = 100.0;

  @override
  void didUpdateWidget(_SwipeCardStack old) {
    super.didUpdateWidget(old);
    if (old.currentIndex != widget.currentIndex) {
      _offsetX = 0;
      _offsetY = 0;
    }
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() {
      _offsetX += d.delta.dx;
      _offsetY += d.delta.dy;
    });
  }

  void _onPanEnd(DragEndDetails _) {
    if (_offsetX > _swipeThreshold) {
      widget.onLike();
    } else if (_offsetX < -_swipeThreshold) {
      widget.onDislike();
    } else {
      setState(() {
        _offsetX = 0;
        _offsetY = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final places = widget.places;
    final idx = widget.currentIndex;
    final showLike = _offsetX > 30;
    final showDislike = _offsetX < -30;

    return Stack(
      alignment: Alignment.center,
      children: [
        // 3rd card — furthest back
        if (idx + 2 < places.length)
          Positioned.fill(
            child: Transform.translate(
              offset: const Offset(0, 20),
              child: Transform.scale(
                scale: 0.90,
                child: _SwipeCard(place: places[idx + 2]),
              ),
            ),
          ),
        // 2nd card — middle
        if (idx + 1 < places.length)
          Positioned.fill(
            child: Transform.translate(
              offset: const Offset(0, 10),
              child: Transform.scale(
                scale: 0.95,
                child: _SwipeCard(place: places[idx + 1]),
              ),
            ),
          ),
        // Top card — draggable
        Positioned.fill(
          child: GestureDetector(
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: Transform.translate(
              offset: Offset(_offsetX, _offsetY),
              child: Transform.rotate(
                angle: _offsetX / 900,
                child: Stack(
                  children: [
                    _SwipeCard(
                      place: places[idx],
                      showSuperVoteGlow: widget.showSuperVoteGlow,
                    ),
                    if (showLike)
                      Positioned(
                        top: 24,
                        left: 20,
                        child: _OverlayLabel(
                          text: 'LIKE',
                          color: AppColors.success,
                        ),
                      ),
                    if (showDislike)
                      Positioned(
                        top: 24,
                        right: 20,
                        child: _OverlayLabel(
                          text: 'NOPE',
                          color: AppColors.error,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _OverlayLabel extends StatelessWidget {
  final String text;
  final Color color;

  const _OverlayLabel({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: color, width: 3),
        borderRadius: BorderRadius.circular(8),
        color: color.withValues(alpha: 0.1),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          letterSpacing: 2,
        ),
      ),
    );
  }
}

class _SwipeCard extends StatelessWidget {
  final PlaceEntity place;
  final bool showSuperVoteGlow;

  const _SwipeCard({
    required this.place,
    this.showSuperVoteGlow = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
        border: showSuperVoteGlow
            ? Border.all(color: _kSuperVoteColors, width: 3)
            : null,
        boxShadow: [
          if (showSuperVoteGlow)
            BoxShadow(
              color: _kSuperVoteColors.withValues(alpha: 0.5),
              blurRadius: 24,
              spreadRadius: 4,
            ),
          BoxShadow(
            color: AppColors.cardShadow.withValues(alpha: 0.15),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(AppSpacing.radiusXl),
              ),
              child: Image.network(
                place.image,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  color: AppColors.primaryBg,
                  child: const Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.primary,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(place.name, style: AppTextStyles.headingM),
                    ),
                    const Icon(
                      Icons.star_rounded,
                      color: Colors.amber,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      place.rating.toStringAsFixed(1),
                      style: AppTextStyles.bodyM.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  place.location,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  place.priceRange,
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
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final Color backgroundColor;
  final double size;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.color,
    required this.backgroundColor,
    required this.size,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: color, size: size * 0.42),
      ),
    );
  }
}

class _SuperVoteButton extends StatelessWidget {
  final bool isUsed;
  final VoidCallback? onTap;

  const _SuperVoteButton({required this.isUsed, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isUsed ? AppColors.progressBg : _kSuperVoteColors,
              shape: BoxShape.circle,
              boxShadow: isUsed
                  ? []
                  : [
                      BoxShadow(
                        color: _kSuperVoteColors.withValues(alpha: 0.4),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: Icon(
              Icons.bolt_rounded,
              color: isUsed ? AppColors.textSecondary : AppColors.white,
              size: 26,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          isUsed ? '0/1 left' : 'Super',
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isUsed ? AppColors.textSecondary : _kSuperVoteColors,
          ),
        ),
      ],
    );
  }
}

class _SuperVoteBanner extends StatelessWidget {
  const _SuperVoteBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: _kSuperVoteColors,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _kSuperVoteColors.withValues(alpha: 0.4),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.bolt_rounded, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Super Vote Cast! Card pushed to your group.',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
