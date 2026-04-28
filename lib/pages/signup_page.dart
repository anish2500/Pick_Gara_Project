import 'package:flutter/material.dart';
import 'package:mero_choice_application/pages/login_page.dart';
import 'package:mero_choice_application/widgets/auth_richtext.dart';
import 'package:mero_choice_application/widgets/my_button.dart';
import 'package:mero_choice_application/widgets/my_textfield.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool _isObscure = true;
  @override
  Widget build(BuildContext context) {
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

                      MyButton(text: 'Sign Up', onTap: () {}),
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
