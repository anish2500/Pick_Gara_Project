import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';
import 'package:mero_choice_application/features/auth/presentation/state/auth_state.dart';
import 'package:mero_choice_application/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:mero_choice_application/features/bookmark/presentation/page/bookmarks_page.dart';
import 'package:mero_choice_application/pages/my_activity_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (ref.read(authViewModelProvider).authEntity == null) {
        ref.read(authViewModelProvider.notifier).getCurrentUser();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final entity = ref.watch(authViewModelProvider).authEntity;

    ref.listen<AuthState>(authViewModelProvider, (_, current) {
      if (current.status == AuthStatus.unauthenticated) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      }
    });

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBg,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'Profile',
          style: AppTextStyles.headingM.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
        child: Column(
          children: [
            const SizedBox(height: AppSpacing.xl),

            // ── Avatar card ───────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.x3l),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
                border: Border.all(color: AppColors.primary, width: 1.5),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: _isUploading ? null : _pickImage,
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        CircleAvatar(
                          key: ValueKey(entity?.profileImage),
                          radius: 46,
                          backgroundColor: AppColors.primaryBg,
                          backgroundImage: entity?.profileImage != null
                              ? CachedNetworkImageProvider(
                                  entity!.profileImage!,
                                )
                              : const AssetImage('assets/images/avatar.png')
                                    as ImageProvider,
                        ),
                        if (_isUploading)
                          Positioned.fill(
                            child: ClipOval(
                              child: Container(
                                color: Colors.black38,
                                child: const Center(
                                  child: SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              size: 16,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(entity?.fullName ?? '', style: AppTextStyles.titleL),
                  const SizedBox(height: 4),
                  Text(
                    entity?.email ?? '',
                    style: AppTextStyles.bodyM.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppSpacing.x3l),

            // ── Menu items ────────────────────────────────────
            _MenuItem(
              icon: Icons.access_time_rounded,
              label: 'My Activity',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MyActivityPage()),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _MenuItem(
              icon: Icons.bookmark_border_rounded,
              label: 'My Bookmarks',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const BookmarksPage()),
                );
              },
            ),
            const SizedBox(height: AppSpacing.md),
            _MenuItem(
              icon: Icons.group_outlined,
              label: 'Friends List',
              onTap: () {},
            ),
            const SizedBox(height: AppSpacing.md),

            // ── Logout ────────────────────────────────────────
            _MenuItem(
              icon: Icons.logout_rounded,
              label: 'Logout',
              isDestructive: true,
              trailingIcon: Icons.power_settings_new_rounded,
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (_) => _LogoutDialog(
                    onConfirm: () {
                      Navigator.pop(context);
                      ref.read(authViewModelProvider.notifier).logout();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();

    // On web the browser only opens a file picker from a synchronous user
    // gesture. Awaiting a bottom sheet first consumes that gesture, so the
    // subsequent pickImage call gets silently blocked. Skip the sheet on web
    // and go straight to the file picker.
    if (kIsWeb) {
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 600,
      );
      if (picked == null || !mounted) return;
      setState(() => _isUploading = true);
      await ref.read(authViewModelProvider.notifier).uploadAvatar(picked);
      await ref.read(authViewModelProvider.notifier).getCurrentUser();
      if (mounted) setState(() => _isUploading = false);
      return;
    }

    // Mobile: show bottom sheet, then pick from the chosen source.
    final source = await showModalBottomSheet<ImageSource>(
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
          children: [
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
            Text('Change Profile Photo', style: AppTextStyles.headingM),
            const SizedBox(height: AppSpacing.x3l),
            ListTile(
              leading: Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: AppColors.primaryBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.photo_library_rounded,
                  color: AppColors.primary,
                ),
              ),
              title: Text(
                'Choose from Gallery',
                style: AppTextStyles.bodyM.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
            const SizedBox(height: AppSpacing.sm),
            ListTile(
              leading: Container(
                width: 42,
                height: 42,
                decoration: const BoxDecoration(
                  color: AppColors.primaryBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: AppColors.primary,
                ),
              ),
              title: Text(
                'Take a Photo',
                style: AppTextStyles.bodyM.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
          ],
        ),
      ),
    );

    if (source == null || !mounted) return;

    final picked = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 600,
    );

    if (picked == null || !mounted) return;

    setState(() => _isUploading = true);
    await ref.read(authViewModelProvider.notifier).uploadAvatar(picked);
    await ref.read(authViewModelProvider.notifier).getCurrentUser();
    if (mounted) setState(() => _isUploading = false);
  }
}

class _LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirm;

  const _LogoutDialog({required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(28, 32, 28, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.white,
                size: 32,
              ),
            ),
            const SizedBox(height: 20),
            const Text('Are you sure?', style: AppTextStyles.headingM),
            const SizedBox(height: 8),
            Text(
              'You agree to logging\nout of session.',
              style: AppTextStyles.bodyM.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      'No',
                      style: AppTextStyles.buttonM.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onConfirm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text(
                      'Yes',
                      style: AppTextStyles.buttonM.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isDestructive;
  final IconData? trailingIcon;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isDestructive = false,
    this.trailingIcon,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.error : AppColors.primary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.lg,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: AppSpacing.iconLg),
            const SizedBox(width: AppSpacing.lg),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodyM.copyWith(
                  color: isDestructive
                      ? AppColors.error
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              trailingIcon ?? Icons.chevron_right_rounded,
              color: isDestructive ? AppColors.error : AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
