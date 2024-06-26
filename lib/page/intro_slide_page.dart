import 'package:flutter/material.dart';
import 'package:wallink_v1/database/app_preferences.dart';
import 'package:wallink_v1/route_page.dart';

class IntroSlidePage extends StatefulWidget {
  const IntroSlidePage({Key? key}) : super(key: key);

  @override
  _IntroSlidePageState createState() => _IntroSlidePageState();
}

class _IntroSlidePageState extends State<IntroSlidePage> {
  late PageController _pageController;
  int _currentPage = 0;
  final List<String> _imageAssets = [
    'assets/splashscreen.png',
    'assets/intr1.png',
    'assets/intr2.png',
    'assets/intr3.png',
    'assets/intr4.png',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: _updateCurrentPage,
              itemCount: _imageAssets.length,
              itemBuilder: _buildPage,
            ),
            if (_currentPage != 0)
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _imageAssets.length - 1,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: _buildIndicator(index + 1),
                    ),
                  ),
                ),
              ),
            if (_currentPage != 0)
              Positioned(
                bottom: 50,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    _buildNextButton(),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          _pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.ease,
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(_imageAssets[index]),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      opacity: _currentPage == 0 ? 0.0 : 1.0,
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: TextButton(
            onPressed: () async {
              if (_currentPage < _imageAssets.length - 1) {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              } else {
                await AppPreferences.setFirstTime(false);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RoutePage(
                      selectedIndex: 0,
                    ),
                  ),
                );
              }
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
            ),
            child: Text(
              _currentPage == _imageAssets.length - 1 ? 'Mulai' : 'Next',
              style: const TextStyle(
                color: Color(0xFF0569DC),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIndicator(int index) {
    return GestureDetector(
      onTap: () {
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 500),
          curve: Curves.ease,
        );
      },
      child: Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.only(bottom: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentPage == index ? Colors.white : Colors.grey,
        ),
      ),
    );
  }

  void _updateCurrentPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }
}
