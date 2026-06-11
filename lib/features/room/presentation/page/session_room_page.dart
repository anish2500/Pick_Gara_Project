import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';
import 'package:mero_choice_application/features/room/domain/entities/room_entity.dart';
import 'package:mero_choice_application/features/room/presentation/page/swiping_room_page.dart';

import 'package:mero_choice_application/widgets/my_button.dart';

class SessionRoomPage extends StatelessWidget {
  final RoomEntity room;

  const SessionRoomPage({super.key, required this.room});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/create-room',
            (route) => false,
          ),
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
                    color: AppColors.cardShadow.withOpacity(0.15),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.motion_photos_on_outlined,
                    size: 40,
                    color: AppColors.primary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    '${room.name.toUpperCase()}: WAITING LOBBY',
                    style: AppTextStyles.headingM,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: room.pin));
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
                        borderRadius: BorderRadius.circular(
                          AppSpacing.radiusFull,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'ROOM PIN: ${room.pin}',
                            style: AppTextStyles.headingM.copyWith(
                              color: AppColors.white,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          const Icon(Icons.copy, color: Colors.white, size: 18),
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
                        backgroundImage: AssetImage('assets/images/avatar.png'),
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
                            Icon(
                              Icons.add,
                              size: 14,
                              color: AppColors.textSecondary,
                            ),
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
                  '${(room.members.length / 6 * 100).toInt()}% full',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              child: LinearProgressIndicator(
                value: room.members.length / 6,
                backgroundColor: AppColors.textSecondary.withOpacity(0.3),
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
                    builder: (_) => SwipingRoomPage(room: room),
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
}
