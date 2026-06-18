import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_entity.dart';
import 'package:mero_choice_application/features/room/presentation/page/swiping_room_page.dart';
import 'package:mero_choice_application/features/room/presentation/state/room_state.dart';
import 'package:mero_choice_application/features/room/presentation/view_model/room_view_model.dart';
import 'package:mero_choice_application/widgets/app_snackbar.dart';
import 'package:mero_choice_application/widgets/my_button.dart';

class SessionRoomPage extends ConsumerStatefulWidget {
  final RoomEntity room;

  const SessionRoomPage({super.key, required this.room});

  @override
  ConsumerState<SessionRoomPage> createState() => _SessionRoomPageState();
}

class _SessionRoomPageState extends ConsumerState<SessionRoomPage> {
  @override
  Widget build(BuildContext context) {
    ref.listen<RoomState>(roomViewModelProvider, (_, current) {
      if (current.status == RoomStatus.deleted) {
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/dashboard',
          (route) => false,
        );
      } else if (current.status == RoomStatus.error) {
        AppSnackBar.showError(
          context,
          current.errorMessage ?? 'Failed to delete room',
        );
      }
    });

    final isLoading =
        ref.watch(roomViewModelProvider).status == RoomStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        leading: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              )
            : IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.primary),
                onPressed: _showBackOptions,
              ),
        title: Text(
          'Session Room',
          style: AppTextStyles.headingM.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.x3l),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.x3l),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
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
                  const Icon(
                    Icons.motion_photos_on_outlined,
                    size: 40,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '${widget.room.name.toUpperCase()}: WAITING LOBBY',
                    style: AppTextStyles.headingM,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: widget.room.pin));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('PIN copied!')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.x3l,
                        vertical: AppSpacing.md,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusFull),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ROOM PIN: ${widget.room.pin}',
                            style: AppTextStyles.headingM.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const Icon(Icons.copy,
                              color: Colors.white, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.x3l),
                  Text('ACTIVE MEMBERS', style: AppTextStyles.caption),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage:
                            AssetImage('assets/images/avatar.png'),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.textSecondary,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add,
                                size: 14,
                                color: AppColors.textSecondary),
                            Text(
                              'INVITE',
                              style: TextStyle(
                                fontSize: 7,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.x3l),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Ready to roll',
                  style: AppTextStyles.bodyM.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  '${(widget.room.members.length / 6 * 100).toInt()}% full',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              child: LinearProgressIndicator(
                value: widget.room.members.length / 6,
                backgroundColor: AppColors.textSecondary.withValues(alpha: 0.3),
                color: AppColors.primary,
                minHeight: 6,
              ),
            ),
            const Spacer(),
            MyButton(
              text: 'Start Swiping',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => SwipingRoomPage(room: widget.room),
                  ),
                );
              },
            ),
            const SizedBox(height: AppSpacing.x3l),
          ],
        ),
      ),
    );
  }

  Future<void> _showBackOptions() async {
    final choice = await showModalBottomSheet<String>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSpacing.radiusXl),
        ),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.screenH,
          AppSpacing.xl,
          AppSpacing.screenH,
          AppSpacing.x3l,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Handle bar ────────────────────────────────
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.progressBg,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('Leave Session', style: AppTextStyles.headingM),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'What would you like to do with "${widget.room.name}"?',
              style: AppTextStyles.bodyM
                  .copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: AppSpacing.x3l),

            // ── Keep Room option ──────────────────────────
            _OptionTile(
              icon: Icons.bookmark_outline_rounded,
              iconColor: AppColors.primary,
              title: 'Keep Room & Go Back',
              subtitle: 'Room stays active — members can still join and vote.',
              onTap: () => Navigator.pop(context, 'keep'),
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Delete Room option ────────────────────────
            _OptionTile(
              icon: Icons.delete_outline_rounded,
              iconColor: AppColors.error,
              title: 'Delete Room',
              subtitle: 'Permanently removes the room for everyone.',
              onTap: () => Navigator.pop(context, 'delete'),
            ),
          ],
        ),
      ),
    );

    if (!mounted) return;

    if (choice == 'keep') {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/dashboard',
        (route) => false,
      );
    } else if (choice == 'delete' && widget.room.roomId != null) {
      ref
          .read(roomViewModelProvider.notifier)
          .deleteRoom(widget.room.roomId!);
    }
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _OptionTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.scaffoldBg,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          border: Border.all(color: AppColors.progressBg),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodyM.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                  )),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded,
                color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
