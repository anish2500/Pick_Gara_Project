import 'package:flutter/material.dart';
import 'package:mero_choice_application/core/theme/app_theme.dart';
import 'package:mero_choice_application/features/room/presentation/page/create_room_page.dart';
import 'package:mero_choice_application/features/room/presentation/page/join_room_page.dart';
import 'package:mero_choice_application/pages/login_page.dart';
import 'package:mero_choice_application/pages/main_page.dart';
import 'package:mero_choice_application/pages/onboarding_page1.dart';
import 'package:mero_choice_application/pages/signup_page.dart';
import 'package:mero_choice_application/pages/splash_page.dart';

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
        '/signup': (context) => const SignupPage(),
        '/login': (context) => const LoginPage(),
        '/dashboard': (context) => const MainPage(),
        '/create-room': (context) => const CreateRoomPage(),
        '/join-room': (context)=> const JoinRoomPage()
      },
    );
  }
}
