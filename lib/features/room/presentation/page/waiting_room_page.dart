import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_detail_entity.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_entity.dart';
import 'package:mero_choice_application/features/room/domain/usecases/get_room_detail_usecase.dart';
import 'package:mero_choice_application/features/room/presentation/page/results_page.dart';
import 'package:mero_choice_application/features/vote/domain/entities/vote_entity.dart';

class WaitingRoomPage extends ConsumerStatefulWidget {
  final RoomEntity room;
  final RoomDetailEntity detail;
  final VoteStatsEntity? voteStats;

  const WaitingRoomPage({
    super.key,
    required this.room,
    required this.detail,
    this.voteStats,
  });

  @override
  ConsumerState<WaitingRoomPage> createState() => _WaitingRoomPageState();
}

class _WaitingRoomPageState extends ConsumerState<WaitingRoomPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  Timer? _pollingTimer;

  int _membersVoted = 0;
  int _totalMembers = 0;

  @override
  void initState() {
    super.initState();

    _totalMembers = widget.detail.memberCount;
    _membersVoted = widget.voteStats?.membersVoted ?? 0;

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _pollVoteStatus();
    _pollingTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _pollVoteStatus(),
    );
  }

  Future<void> _pollVoteStatus() async {
    final result = await ref
        .read(getRoomDetailUsecaseProvider)
        .call(GetRoomDetailParams(roomId: widget.room.roomId!));

    result.fold(
      (_) {},
      (detail) {
        if (!mounted) return;

        final voted = detail.voteStats?.membersVoted ?? _membersVoted;
        final total = detail.memberCount;

        setState(() {
          _membersVoted = voted;
          _totalMembers = total;
        });

        if (voted >= total && total > 0) {
          _pollingTimer?.cancel();
          _navigateToResults(detail);
        }
      },
    );
  }

  void _navigateToResults(RoomDetailEntity detail) {
    final tallies = List<PlaceTallyEntity>.from(
      detail.voteStats?.placeTallies ?? [],
    );
    tallies.sort((a, b) => b.likes.compareTo(a.likes));

    PlaceEntity? winner;
    if (tallies.isNotEmpty) {
      winner = detail.places.cast<PlaceEntity?>().firstWhere(
            (p) => p?.placeId == tallies.first.placeId,
            orElse: () => null,
          );
    }
    winner ??= detail.places.isNotEmpty ? detail.places.first : null;

    if (winner == null || !mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ResultsPage(
          winner: winner!,
          totalVotes: tallies.isNotEmpty ? tallies.first.likes : 0,
          roomName: detail.room.name,
          memberCount: detail.memberCount,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final allDone = _totalMembers > 0 && _membersVoted >= _totalMembers;
    final progress = _totalMembers > 0
        ? (_membersVoted / _totalMembers).clamp(0.0, 1.0)
        : 0.0;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Waiting Room',
          style: AppTextStyles.headingM.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
        child: Column(
          children: [
            const Spacer(),

            // ── Pulsing icon ──────────────────────────────────
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (_, child) => Transform.scale(
                scale: _pulseAnimation.value,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 128,
                      height: 128,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBg,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                          width: 2,
                        ),
                      ),
                    ),
                    Container(
                      width: 92,
                      height: 92,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        allDone
                            ? Icons.check_rounded
                            : Icons.hourglass_top_rounded,
                        color: AppColors.white,
                        size: 42,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: AppSpacing.x3l),

            // ── Title ─────────────────────────────────────────
            Text(
              allDone ? 'All votes are in!' : 'Waiting for others...',
              style: AppTextStyles.headingL,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              allDone
                  ? 'Finding your perfect match...'
                  : 'You\'ve finished voting.\nSit tight while others finish!',
              style: AppTextStyles.bodyM
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppSpacing.x3l),

            // ── Progress card ─────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.primaryBg,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.15),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Members Voted',
                        style: AppTextStyles.bodyM
                            .copyWith(color: AppColors.textSecondary),
                      ),
                      Text(
                        '$_membersVoted / $_totalMembers',
                        style: AppTextStyles.headingM
                            .copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.radiusFull),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor:
                          AppColors.primary.withValues(alpha: 0.12),
                      color: AppColors.primary,
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.xl),

            // ── Session label ─────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.meeting_room_outlined,
                  size: 15,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: AppSpacing.xs),
                Text(
                  widget.detail.room.name,
                  style: AppTextStyles.bodyM
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),

            const Spacer(),

            // ── Polling hint ──────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(
                    strokeWidth: 1.5,
                    color: AppColors.primary.withValues(alpha: 0.45),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Checking every 5 seconds...',
                  style: AppTextStyles.caption
                      .copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),

            const SizedBox(height: AppSpacing.x3l),
          ],
        ),
      ),
    );
  }
}
