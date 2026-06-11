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

class JoinRoomPage extends ConsumerStatefulWidget {
  const JoinRoomPage({super.key});

  @override
  ConsumerState<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends ConsumerState<JoinRoomPage> {
  final _pinController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<RoomState>(roomViewModelProvider, (_, current) {
      if (current.status == RoomStatus.success && current.room != null) {
        ref.read(roomViewModelProvider.notifier).resetState();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => SessionRoomPage(room: current.room!),
          ),
        );
      } else if (current.status == RoomStatus.error) {
        AppSnackBar.showError(
          context,
          current.errorMessage ?? 'Failed to join room',
        );
        ref.read(roomViewModelProvider.notifier).resetState();
      }
    });

    final isLoading =
        ref.watch(roomViewModelProvider).status == RoomStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pushNamedAndRemoveUntil(
            context,
            '/dashboard',
            (route) => false,
          ),
        ),
        title: Text('Join a Room', style: AppTextStyles.headingM),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.x3l),

              // ── Icon ─────────────────────────────────────────
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: const BoxDecoration(
                    color: AppColors.primaryBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.login_rounded,
                    color: AppColors.primary,
                    size: 36,
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.xl),
              Center(
                child: Text('Enter Room PIN', style: AppTextStyles.headingM),
              ),
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: Text(
                  'Ask the host for the 4-digit PIN\nto join their session.',
                  style: AppTextStyles.bodyM.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppSpacing.x3l),

              // ── PIN input ─────────────────────────────────────
              Text('Room PIN', style: AppTextStyles.bodyM),
              const SizedBox(height: AppSpacing.sm),
              TextFormField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                maxLength: 4,
                textAlign: TextAlign.center,
                style: AppTextStyles.headingL.copyWith(letterSpacing: 12),
                decoration: InputDecoration(
                  counterText: '',
                  hintText: '• • • •',
                  hintStyle: AppTextStyles.headingL.copyWith(
                    color: AppColors.textDisabled,
                    letterSpacing: 12,
                  ),
                  filled: true,
                  fillColor: AppColors.primaryBg,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    borderSide: const BorderSide(
                      color: AppColors.primary,
                      width: 1.5,
                    ),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: 1.5,
                    ),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: 1.5,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter the PIN';
                  }
                  if (value.trim().length != 4) {
                    return 'PIN must be exactly 4 digits';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.x3l),

              // ── Join button ────────────────────────────────────
              MyButton(
                text: isLoading ? 'Joining...' : 'JOIN ROOM',
                leadingIcon: Icons.login_rounded,
                onTap: isLoading
                    ? null
                    : () {
                        if (_formKey.currentState!.validate()) {
                          ref
                              .read(roomViewModelProvider.notifier)
                              .joinRoom(_pinController.text.trim());
                        }
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
