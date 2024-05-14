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
    'assets/intr1.png',
    'assets/intr2.png',
    'assets/intr3.png',
    'assets/intr4.png',
  ];

  double _nextButtonOffset = 0.0;
  double _indicator4Offset = 0.0;

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
            Positioned(
              bottom: 100, // Ubah posisi titik 4 lebih ke bawah
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildIndicator(0),
                  const SizedBox(width: 8),
                  _buildIndicator(1),
                  const SizedBox(width: 8),
                  _buildIndicator(2),
                  const SizedBox(width: 8),
                  _buildIndicator(3),
                ],
              ),
            ),
            Positioned(
              bottom: 50, // Ubah posisi tombol Next dan Mulai lebih ke bawah
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
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(_imageAssets[index]),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildNextButton() {
    return AnimatedPositioned(
      duration: const Duration(milliseconds: 500),
      bottom: _nextButtonOffset,
      left: 0,
      right: 0,
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: TextButton(
            onPressed: () async{
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
                color: const Color(0xFF0569DC),
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
    _animateButtons();
  }

  void _animateButtons() {
    setState(() {
      _nextButtonOffset = _currentPage == _imageAssets.length - 1 ? -80.0 : 0.0;
      _indicator4Offset = _currentPage >= 2 ? -80.0 : 0.0;
    });
  }
}
