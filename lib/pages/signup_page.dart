import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';
import 'package:mero_choice_application/features/auth/presentation/state/auth_state.dart';
import 'package:mero_choice_application/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:mero_choice_application/pages/login_page.dart';
import 'package:mero_choice_application/widgets/app_snackbar.dart';
import 'package:mero_choice_application/widgets/auth_richtext.dart';
import 'package:mero_choice_application/widgets/my_button.dart';
import 'package:mero_choice_application/widgets/my_textfield.dart';


class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isObscure = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthState>(authViewModelProvider, (_, current) {
      if (current.status == AuthStatus.registered) {
        AppSnackBar.showSuccess(context, 'Account Created! Please login.');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
        ref.read(authViewModelProvider.notifier).resetState();
      }
    });

    final isLoading =
        ref.watch(authViewModelProvider).status == AuthStatus.loading;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenH),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: AppSpacing.x8l),
                  Image.asset(
                    'assets/images/logo.png',
                    height: AppSpacing.logoHeightAuth,
                    width: AppSpacing.logoWidthAuth,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'DECIDE TOGETHER, SILENTLY',
                    style: AppTextStyles.tagline,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Create Account',
                    style: AppTextStyles.screenTitle,
                  ),
                  const SizedBox(height: AppSpacing.x4l),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Full Name', style: AppTextStyles.bodyM),
                      const SizedBox(height: AppSpacing.md),
                      MyTextfield(
                        controller: _fullNameController,
                        hintText: 'John Doe',
                        prefixIcon: Icons.person,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text('Email', style: AppTextStyles.bodyM),
                      const SizedBox(height: AppSpacing.md),
                      MyTextfield(
                        controller: _emailController,
                        hintText: 'john@example.com',
                        prefixIcon: Icons.email,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Text('Password', style: AppTextStyles.bodyM),
                      const SizedBox(height: AppSpacing.md),
                      MyTextfield(
                        controller: _passwordController,
                        hintText: '************',
                        prefixIcon: Icons.lock_outline_rounded,
                        obscureText: _isObscure,
                        suffixIcon: _isObscure
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_rounded,
                        onSuffixTap: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        },
                      ),
                      const SizedBox(height: AppSpacing.x5l),
                      isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : MyButton(
                              text: 'Sign Up',
                              onTap: () {
                                ref
                                    .read(authViewModelProvider.notifier)
                                    .register(
                                      _fullNameController.text.trim(),
                                      _emailController.text.trim(),
                                      _passwordController.text.trim(),
                                    );
                              },
                            ),
                      const SizedBox(height: AppSpacing.x3l),
                      Align(
                        alignment: Alignment.center,
                        child: AuthRichtext(
                          leadingtext: 'Already have an account?',
                          actionText: '  Login',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
