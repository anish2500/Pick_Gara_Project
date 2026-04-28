import 'package:flutter/material.dart';
import 'package:mero_choice_application/pages/login_page.dart';
import 'package:mero_choice_application/pages/onboarding_page1.dart';
import 'package:mero_choice_application/pages/signup_page.dart';
import 'package:mero_choice_application/pages/splash_page.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    
    );
  }
}