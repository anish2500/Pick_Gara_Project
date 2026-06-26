import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';
import 'package:mero_choice_application/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:mero_choice_application/features/place/domain/entities/place_entity.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_detail_entity.dart';
import 'package:mero_choice_application/features/room/presentation/page/session_room_page.dart';
import 'package:mero_choice_application/features/room/presentation/page/swiping_room_page.dart';
import 'package:mero_choice_application/features/room/presentation/state/active_rooms_state.dart';
import 'package:mero_choice_application/features/room/presentation/view_model/active_rooms_view_model.dart';
import 'package:mero_choice_application/features/vote/domain/entities/vote_entity.dart';
import 'package:mero_choice_application/widgets/active_session_card.dart';
import 'package:mero_choice_application/widgets/match_card.dart';
import 'package:mero_choice_application/widgets/my_button.dart';
import 'package:mero_choice_application/widgets/my_secondary_button.dart';

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
      () => ref.read(activeRoomsViewModelProvider.notifier).loadActiveRooms(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);
    final activeRoomsState = ref.watch(activeRoomsViewModelProvider);
    final firstName =
        authState.authEntity?.fullName.split(' ').first ?? 'there';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Sticky header ─────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: _buildHeader(firstName, authState.authEntity?.profileImage),
            ),

            // ── Scrollable content ────────────────────────
            Expanded(
              child: RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () => ref
                    .read(activeRoomsViewModelProvider.notifier)
                    .loadActiveRooms(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildActionCard(activeRoomsState),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildHostRoomsSection(activeRoomsState),
                      _buildActiveVotesSection(activeRoomsState),
                      const SizedBox(height: AppSpacing.xxl),
                      _buildRecentMatchesSection(),
                      const SizedBox(height: AppSpacing.x3l),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader(String firstName, String? profileImage) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Namaste', style: AppTextStyles.headingL),
              const SizedBox(height: 2),
              Text('Welcome back, $firstName',
                  style: AppTextStyles.subGreeting),
            ],
          ),
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primaryBg,
            backgroundImage: profileImage != null
                ? CachedNetworkImageProvider(profileImage)
                : const AssetImage('assets/images/avatar.png')
                    as ImageProvider,
          ),
        ],
      ),
    );
  }

  // ── Create Session / Join Room card ───────────────────────
  Widget _buildActionCard(ActiveRoomsState activeRoomsState) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withValues(alpha: 0.15),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            MyButton(
              text: 'CREATE SESSION',
              leadingIcon: Icons.add_circle_outline_rounded,
              onTap: () {
                if (activeRoomsState.hostRooms.isNotEmpty) {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      backgroundColor: AppColors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      title: Text(
                        'Active Room Exists',
                        style: AppTextStyles.headingM,
                      ),
                      content: Text(
                        'Delete your current room before creating a new session.',
                        style: AppTextStyles.bodyM.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: Text(
                            'OK',
                            style: AppTextStyles.buttonM.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                  return;
                }
                Navigator.pushNamed(context, '/create-room');
              },
            ),
            const SizedBox(height: 18),
            MySecondaryButton(
              text: 'JOIN ROOM',
              leadingIcon: Icons.login_rounded,
              variant: AppSecondaryButtonVariant.text,
              onTap: () {
                Navigator.pushNamed(context, '/join-room');
              },
            ),
          ],
        ),
      ),
    );
  }

  // ── Reusable section header with count badge ──────────────
  Widget _buildSectionHeader(String title, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
      child: Row(
        children: [
          Text(title, style: AppTextStyles.headingM),
          const SizedBox(width: AppSpacing.sm),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: AppColors.primaryBg,
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Text(
              '$count',
              style: AppTextStyles.caption.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Your Rooms (host rooms only) ─────────────────────────
  Widget _buildHostRoomsSection(ActiveRoomsState state) {
    if (state.hostRooms.isEmpty) {
      return const SizedBox.shrink();
    }

    final displayRooms = state.hostRooms.take(1).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Your Rooms', displayRooms.length),
        const SizedBox(height: AppSpacing.md),
        ...displayRooms.map(
          (detail) => Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              0,
              AppSpacing.screenH,
              AppSpacing.md,
            ),
            child: ActiveSessionCard(
              sessionName: detail.room.name,
              startedTime: _formatTime(detail.room.createdAt),
              memberCount: detail.memberCount,
              totalMembers: detail.memberCount,
              voteItems: _buildVoteItems(detail),
              progress: detail.memberCount > 0
                  ? ((detail.voteStats?.membersVoted ?? 0) /
                          detail.memberCount)
                      .clamp(0.0, 1.0)
                  : 0.0,
              avatarAssets: const [],
              buttonText: 'Open',
              onSwipe: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SessionRoomPage(room: detail.room),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }

  // ── Active Votes (member rooms only) ──────────────────────
  Widget _buildActiveVotesSection(ActiveRoomsState state) {
    if (state.memberRooms.isEmpty) {
      if (state.status == ActiveRoomsStatus.loading) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionHeader('Active Votes', 0),
              const SizedBox(height: AppSpacing.md),
              const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              ),
            ],
          ),
        );
      }
      return const SizedBox.shrink();
    }

    final displayMemberRooms = state.memberRooms.take(2).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Active Votes', displayMemberRooms.length),
        const SizedBox(height: AppSpacing.md),
        ...displayMemberRooms.map(
          (detail) => Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.screenH,
              0,
              AppSpacing.screenH,
              AppSpacing.md,
            ),
            child: ActiveSessionCard(
              sessionName: detail.room.name,
              startedTime: _formatTime(detail.room.createdAt),
              memberCount: detail.voteStats?.membersVoted ?? 0,
              totalMembers: detail.memberCount,
              voteItems: _buildVoteItems(detail),
              progress: detail.memberCount > 0
                  ? ((detail.voteStats?.membersVoted ?? 0) /
                          detail.memberCount)
                      .clamp(0.0, 1.0)
                  : 0.0,
              avatarAssets: const [],
              onSwipe: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SwipingRoomPage(room: detail.room),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── Map placeTallies + places → VoteItem list ─────────────
  List<VoteItem> _buildVoteItems(RoomDetailEntity detail) {
    final tallies = List<PlaceTallyEntity>.from(
      detail.voteStats?.placeTallies ?? [],
    )..sort((a, b) => b.likes.compareTo(a.likes));

    return tallies.take(2).toList().asMap().entries.map((entry) {
      final tally = entry.value;
      final place = detail.places.cast<PlaceEntity?>().firstWhere(
            (p) => p?.placeId == tally.placeId,
            orElse: () => null,
          );
      return VoteItem(
        rank: entry.key + 1,
        name: place?.name ?? 'Unknown',
        voteCount: tally.likes,
        totalVotes: detail.memberCount,
      );
    }).toList();
  }

  // ── Format createdAt → "Started X min ago" ────────────────
  String _formatTime(DateTime? time) {
    if (time == null) return 'Recently started';
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just started';
    if (diff.inMinutes < 60) return 'Started ${diff.inMinutes} min ago';
    if (diff.inHours < 24) return 'Started ${diff.inHours}h ago';
    return 'Started ${diff.inDays}d ago';
  }

  // ── Recent Matches ────────────────────────────────────────
  Widget _buildRecentMatchesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Recent Matches', 2),
        const SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 190,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
            children: [
              MatchCard(
                imageAsset: 'assets/images/cafe.jpg',
                name: 'Roadhouse Cafe',
                location: 'Baudha, Kathmandu • 2.3 miles',
                onTap: () {},
              ),
              const SizedBox(width: AppSpacing.md),
              MatchCard(
                imageAsset: 'assets/images/pizza.jpg',
                name: 'Pizza Nation',
                location: 'Jhamsikhel, Kathmandu • 3.9 miles',
                onTap: () {},
              ),
              const SizedBox(width: AppSpacing.md),
              MatchCard(
                imageAsset: 'assets/images/hiking.jpg',
                name: 'Shivapuri Hiking',
                location: 'Gokarneshowr, Kathmandu • 4.9 miles',
                onTap: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }
}
