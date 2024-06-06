import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:wallink_v1/database/app_preferences.dart';
import 'package:wallink_v1/page/onboarding/screen1.dart';
import 'package:wallink_v1/page/onboarding/screen2.dart';
import 'package:wallink_v1/page/onboarding/screen3.dart';
import 'package:wallink_v1/page/onboarding/screen4.dart';
import 'package:wallink_v1/route_page.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({super.key});

  @override
  State<OnBoarding> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  PageController pageController = PageController();
  bool _isLoading = false;
  int _currentIndex = 0;

  void _home() {
    setState(() {
      _isLoading = true;
    });
    AppPreferences.setFirstTime(false);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => RoutePage(
          selectedIndex: 0,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            controller: pageController,
            children: const [Screen1(), Screen2(), Screen3(), Screen4()],
          ),
          if (_currentIndex != 3)
            Align(
              alignment: Alignment.topRight,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0, top: 10.0),
                  child: TextButton(
                    onPressed: () {
                      AppPreferences.setFirstTime(false);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RoutePage(
                            selectedIndex: 0,
                          ),
                        ),
                      );
                    },
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        fontFamily: 'sharp',
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (_currentIndex == 3)
            Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _home,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                        backgroundColor: const Color.fromARGB(255, 5, 105, 220),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                      ),
                      child: _isLoading
                          ? const SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.0,
                              ),
                            )
                          : const Text(
                              'Get Started',
                              style: TextStyle(
                                fontFamily: 'sharp',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ),
          Container(
            alignment: const Alignment(0, 0.8),
            child: SmoothPageIndicator(
              controller: pageController,
              count: 4,
              effect: const ExpandingDotsEffect(
                activeDotColor: Color.fromARGB(255, 5, 105, 220),
                dotWidth: 10,
                dotHeight: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
