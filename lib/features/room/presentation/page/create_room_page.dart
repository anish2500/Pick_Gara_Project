import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';
import 'package:mero_choice_application/features/room/presentation/page/session_room_page.dart';
import 'package:mero_choice_application/features/room/presentation/state/room_state.dart';
import 'package:mero_choice_application/features/room/presentation/view_model/room_view_model.dart';
import 'package:mero_choice_application/widgets/app_snackbar.dart';
import 'package:mero_choice_application/widgets/my_button.dart';

class CreateRoomPage extends ConsumerStatefulWidget {
  const CreateRoomPage({super.key});

  @override
  ConsumerState<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends ConsumerState<CreateRoomPage> {
  String? _selectedCategory;

  final List<Map<String, String>> _decks = [
    {'label': 'Momo',   'category': 'momo',   'image': 'assets/images/momooo.png'},
    {'label': 'Cafes',  'category': 'cafe',   'image': 'assets/images/cafee.png'},
    {'label': 'Hiking', 'category': 'hiking', 'image': 'assets/images/hiking.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    ref.listen<RoomState>(roomViewModelProvider, (_, current) {
      if (current.status == RoomStatus.success && current.room != null) {
        ref.read(roomViewModelProvider.notifier).resetState();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SessionRoomPage(room: current.room!),
          ),
        );
      } else if (current.status == RoomStatus.error) {
        AppSnackBar.showError(
          context,
          current.errorMessage ?? 'Failed to create room',
        );
        ref.read(roomViewModelProvider.notifier).resetState();
      }
    });

    final isLoading =
        ref.watch(roomViewModelProvider).status == RoomStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route)=> false),
        ),
        title: Text(
          'Create a room',
          style: AppTextStyles.headingM.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xl),
            Text(
              'Vote together and decide\nyour next plan.',
              style: AppTextStyles.bodyL,
            ),
            const SizedBox(height: AppSpacing.x3l),
            Text('Select a deck...', style: AppTextStyles.headingM),
            const SizedBox(height: AppSpacing.xl),
            SizedBox(
              height: 140,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _decks.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: AppSpacing.md),
                itemBuilder: (context, index) {
                  final deck = _decks[index];
                  final isSelected = _selectedCategory == deck['category'];
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedCategory = deck['category']),
                    child: Container(
                      width: 110,
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(AppSpacing.radiusLg),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 2.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius:
                                BorderRadius.circular(AppSpacing.radiusMd),
                            child: Image.asset(
                              deck['image']!,
                              height: 100,
                              width: 110,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(deck['label']!, style: AppTextStyles.bodyM),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const Spacer(),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : MyButton(
                    text: 'Create a room',
                    onTap: () {
                      if (_selectedCategory == null) {
                        AppSnackBar.showError(
                            context, 'Please select a deck first');
                        return;
                      }
                      final label = _decks.firstWhere(
                        (d) => d['category'] == _selectedCategory,
                      )['label']!;
                      ref
                          .read(roomViewModelProvider.notifier)
                          .createRoom('$label Night', _selectedCategory!);
                    },
                  ),
            const SizedBox(height: AppSpacing.x3l),
          ],
        ),
      ),
    );
  }
}
