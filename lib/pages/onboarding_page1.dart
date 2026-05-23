import 'package:flutter/material.dart';
import 'package:mero_choice_application/pages/dashboard_page.dart';
import 'package:mero_choice_application/pages/signup_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingPage1 extends StatefulWidget {
  const OnboardingPage1({super.key});

  @override
  State<OnboardingPage1> createState() => _OnboardingPage1State();
}

class _OnboardingPage1State extends State<OnboardingPage1> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            SizedBox(height: 80),
            Expanded(
              child: PageView(
                controller: _pageController,
                children: [_buildPage1(), _buildPage2()],
              ),
            ),
            _buildBottom(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
      child: Row(
        children: [
          Icon(Icons.arrow_back_outlined, size: 28, color: Color(0xFF453CE1)),
          SizedBox(width: 15),
          Text(
            'PickGara',
            style: TextStyle(
              fontFamily: 'SF',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF453CE1),
            ),
          ),
          Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignupPage()),
              );
            },
            child: Text(
              'Skip',
              style: TextStyle(
                fontFamily: 'SF',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage1() {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.35,
          width: double.infinity,
          alignment: Alignment.center,
          child: Image.asset(
            'assets/images/onboard1.png',
            width: 330,
            fit: BoxFit.contain,
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              'Decision Fatigue?',
              style: TextStyle(
                fontFamily: 'SF',
                fontSize: 30,
                color: Color(0xFF453CE1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 2),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              'Stop the endless back-and-\nforth. PickGara helps your group\ndecide faster',
              style: TextStyle(
                fontFamily: 'SF',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPage2() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: 280,
            height: 250,
            // transform: Matrix4.rotationZ(-2 * 0.03),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 190, 190, 190),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                  child: Image.asset(
                    'assets/images/cafe.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'RoadHouse Cafe ',
                        style: TextStyle(
                          fontFamily: 'SF',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: const Color.fromARGB(255, 36, 97, 64),
                            size: 16,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '4.9',
                            style: TextStyle(
                              fontFamily: 'SF',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 36, 97, 64),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      Text(
                        'Cafe & Restro',
                        style: TextStyle(
                          fontFamily: 'SF',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 10),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Icon(
                          Icons.circle_rounded,
                          size: 6,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        '4.3 Miles',
                        style: TextStyle(
                          fontFamily: 'SF',
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                'Democratic\nDecsions',
                style: TextStyle(
                  fontFamily: 'SF',
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF453CE1),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Text(
                'Every voice counts. Swipe through\noptions and find common ground \ninstantly.',
                style: TextStyle(
                  fontFamily: 'SF',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          SmoothPageIndicator(
            controller: _pageController,
            count: 2,
            effect: const ExpandingDotsEffect(
              activeDotColor: Color(0xFF453CE1),
              dotColor: Colors.grey,
              dotHeight: 10,
              dotWidth: 10,
              expansionFactor: 4,
              spacing: 8,
            ),
          ),
          SizedBox(height: 20),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildButton() {
    final isLastPage = _currentPage == 1;
    return ElevatedButton(
      onPressed: () {
        if (isLastPage) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SignupPage()),
          );
        } else {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: Ink(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF453CE1), Color.fromARGB(255, 108, 100, 216)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Container(
          width: 330,
          height: 50,
          alignment: Alignment.center,
          child: Text(
            isLastPage ? 'GET STARTED' : 'NEXT',
            style: TextStyle(
              fontFamily: 'SF',
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
