import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mero_choice_application/features/auth/presentation/state/auth_state.dart';
import 'package:mero_choice_application/features/auth/presentation/view_model/auth_view_model.dart';
import 'package:mero_choice_application/pages/login_page.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account Created! Please login.')),
        );
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 78),
                  Image.asset(
                    'assets/images/logo.png',
                    height: 108,
                    width: 130,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'DECIDE TOGETHER, SILENTLY',
                    style: TextStyle(
                      fontFamily: 'SF-Medium',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color.fromARGB(255, 96, 95, 106),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Create Account',
                    style: TextStyle(
                      fontFamily: 'SF',
                      fontSize: 25,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF453CE1),
                    ),
                  ),

                  const SizedBox(height: 40),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Full Name',
                        style: TextStyle(
                          fontFamily: 'SF',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF464555),
                        ),
                      ),
                      const SizedBox(height: 12),
                      MyTextfield(
                        controller: _fullNameController,
                        hintText: 'John Doe',
                        prefixIcon: Icons.person,
                      ),

                      SizedBox(height: 20),
                      Text(
                        'Email',
                        style: TextStyle(
                          fontFamily: 'SF',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF464555),
                        ),
                      ),
                      SizedBox(height: 12),
                      MyTextfield(
                        controller: _emailController,
                        hintText: 'john@example.com',
                        prefixIcon: Icons.email,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontFamily: 'SF',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF464555),
                        ),
                      ),
                      SizedBox(height: 12),
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
                      SizedBox(height: 50),

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
                      SizedBox(height: 30),

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
