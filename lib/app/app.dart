import 'package:flutter/material.dart';
import 'package:mero_choice_application/core/theme/app_theme.dart';
import '../pages/splash_page.dart';
import '../pages/onboarding_page1.dart';
import '../pages/login_page.dart';
import '../pages/signup_page.dart';
import '../pages/dashboard_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashPage(),
        '/onboarding': (context) => const OnboardingPage1(),
        '/login': (context) => const LoginPage(),
        '/signup': (context) => const SignupPage(),
        '/dashboard': (context) => const DashboardPage(),
      },
    );
  }
}
