import 'package:flutter/material.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';
import 'package:mero_choice_application/widgets/active_session_card.dart';
import 'package:mero_choice_application/widgets/match_card.dart';
import 'package:mero_choice_application/widgets/my_button.dart';
import 'package:mero_choice_application/widgets/my_secondary_button.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Sticky header ─────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
              child: _buildHeader(),
            ),

            // ── Scrollable content ────────────────────────
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildActionCard(),
                    const SizedBox(height: AppSpacing.xxl),
                    _buildActiveVotesSection(),
                    const SizedBox(height: AppSpacing.xxl),
                    _buildRecentMatchesSection(),
                    const SizedBox(height: AppSpacing.x3l),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────
  Widget _buildHeader() {
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
              Text('Welcome back, Anish', style: AppTextStyles.subGreeting),
            ],
          ),
          CircleAvatar(
            radius: 26,
            backgroundColor: AppColors.primaryBg,
            backgroundImage: const AssetImage('assets/images/avatar.png'),
          ),
        ],
      ),
    );
  }

  // ── Create Session / Join Room card ───────────────────────
  Widget _buildActionCard() {
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
              color: AppColors.cardShadow.withOpacity(0.15),
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

  // ── Active Votes ──────────────────────────────────────────
  Widget _buildActiveVotesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Active Votes', 2),
        const SizedBox(height: AppSpacing.md),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
          child: ActiveSessionCard(
            sessionName: 'Friday Movie Night',
            startedTime: 'Started 10 min ago',
            memberCount: 5,
            totalMembers: 7,
            voteItems: const [
              VoteItem(
                rank: 1,
                name: 'Dune: Part Two',
                voteCount: 3,
                totalVotes: 5,
              ),
              VoteItem(rank: 2, name: 'Michael', voteCount: 2, totalVotes: 5),
            ],
            progress: 0.6,
            avatarAssets: const [
              'assets/images/male1.png',
              'assets/images/male2.png',
              'assets/images/male3.png',
            ],
            onSwipe: () {},
          ),
        ),
      ],
    );
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
