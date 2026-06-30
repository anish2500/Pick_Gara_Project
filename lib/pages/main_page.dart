import 'package:flutter/material.dart';
import 'package:mero_choice_application/features/match/presentation/page/matches_page.dart';
import 'package:mero_choice_application/features/place/presentation/page/explore_page.dart';
import 'package:mero_choice_application/pages/dashboard_page.dart';
import 'package:mero_choice_application/pages/profile_page.dart';
import 'package:mero_choice_application/widgets/app_bottom_nav_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = [
    DashboardPage(),
    ExplorePage(),
    MatchesPage(), 
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: AppBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}
