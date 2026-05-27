import 'package:flutter/material.dart';
import 'package:mero_choice_application/core/theme/app_colors.dart';
import 'package:mero_choice_application/core/theme/app_spacing.dart';
import 'package:mero_choice_application/core/theme/app_text_styles.dart';
import 'package:mero_choice_application/pages/signup_page.dart';
import 'package:mero_choice_application/widgets/my_button.dart';
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
      backgroundColor: AppColors.scaffoldBg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 80),
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
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenH,
        vertical: AppSpacing.screenV,
      ),
      child: Row(
        children: [
          Icon(
            Icons.arrow_back_outlined,
            size: AppSpacing.iconLg,
            color: AppColors.primary,
          ),
          const SizedBox(width: 15),
          Text('PickGara', style: AppTextStyles.headingXL),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const SignupPage()),
              );
            },
            child: Text('Skip', style: AppTextStyles.skip),
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
            padding: const EdgeInsets.only(left: AppSpacing.screenH),
            child: Text(
              'Decision Fatigue?',
              style: AppTextStyles.displayXL,
            ),
          ),
        ),
        const SizedBox(height: 2),
        Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.only(left: AppSpacing.screenH),
            child: Text(
              'Stop the endless back-and-\nforth. PickGara helps your group\ndecide faster',
              style: AppTextStyles.bodyL,
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
          // ── Preview place card ───────────────────────────────
          Container(
            width: 280,
            height: 250,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.cardShadow,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppSpacing.radiusXl),
                    topRight: Radius.circular(AppSpacing.radiusXl),
                  ),
                  child: Image.asset(
                    'assets/images/cafe.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('RoadHouse Cafe', style: AppTextStyles.titleM),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            color: AppColors.ratingGreen,
                            size: AppSpacing.iconSm,
                          ),
                          const SizedBox(width: AppSpacing.xs),
                          Text('4.9', style: AppTextStyles.rating),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 6),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                  child: Row(
                    children: const [
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
                        padding: EdgeInsets.only(top: 3),
                        child: Icon(
                          Icons.circle_rounded,
                          size: 6,
                          color: AppColors.black,
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

          const SizedBox(height: AppSpacing.xl),

          // ── Section heading ──────────────────────────────────
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.screenH),
              child: Text(
                'Democratic\nDecsions',
                style: AppTextStyles.displayXL,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: AppSpacing.screenH),
              child: Text(
                'Every voice counts. Swipe through\noptions and find common ground \ninstantly.',
                style: AppTextStyles.bodyL,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        children: [
          SmoothPageIndicator(
            controller: _pageController,
            count: 2,
            effect: const ExpandingDotsEffect(
              activeDotColor: AppColors.primary,
              dotColor: AppColors.textSecondary,
              dotHeight: 10,
              dotWidth: 10,
              expansionFactor: 4,
              spacing: 8,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildButton() {
    final isLastPage = _currentPage == 1;
    return MyButton(
      text: isLastPage ? 'GET STARTED' : 'NEXT',
      width: AppSpacing.buttonWidthMd,
      height: AppSpacing.buttonHeightMd,
      onTap: () {
        if (isLastPage) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const SignupPage()),
          );
        } else {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      },
    );
  }
}
