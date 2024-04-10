import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallink_v1/page/preference_page.dart';

class IntroSlidePage extends StatefulWidget {
  const IntroSlidePage({Key? key}) : super(key: key);

  @override
  _IntroSlidePageState createState() => _IntroSlidePageState();
}

class _IntroSlidePageState extends State<IntroSlidePage> {
  late PageController _pageController;
  int _currentPage = 0;
  final List<String> _imageAssets = [
    'assets/intro.png',
    'assets/intro2.png',
    'assets/intro3.png',
  ];

  double _nextButtonOffset = 0.0;
  double _backButtonOffset = 0.0;

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
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
              _animateButtons();
            },
            itemCount: _imageAssets.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(_imageAssets[index]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  children: [
                    if (index == 0) // Show button only if image index is 0 (intro.png)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24.0, left: 16.0, right: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              _pageController.nextPage(
                                duration: const Duration(milliseconds: 500),
                                curve: Curves.ease,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.orangeAccent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Next",
                                  style: GoogleFonts.lexend(
                                    color: const Color.fromARGB(255, 255, 254, 234),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    if (index == 2) // Show button only if image index is 2 (intro3.png)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24.0, left: 16.0, right: 16.0),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PreferencePage(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              backgroundColor: Colors.orangeAccent,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Get Started",
                                  style: GoogleFonts.lexend(
                                    color: const Color.fromARGB(255, 255, 254, 234),
                                    fontSize: 17,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          Positioned(
            bottom: 15,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildIndicators(),
            ),
          ),
          if (_currentPage == 1) // Show Next and Back buttons only on the second slide
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              bottom: 20,
              right: _nextButtonOffset,
              child: TextButton(
                onPressed: () {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
                child: const Text(
                  'NEXT',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          if (_currentPage == 1) // Show Next and Back buttons only on the second slide
            AnimatedPositioned(
              duration: const Duration(milliseconds: 500),
              bottom: 20,
              left: _backButtonOffset,
              child: _currentPage != 0 ? TextButton(
                onPressed: () {
                  _pageController.previousPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.ease,
                  );
                },
                child: const Text(
                  'BACK',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ): const SizedBox(),
            ),
        ],
      ),
    );
  }

  List<Widget> _buildIndicators() {
    List<Widget> indicators = [];
    // Show indicators only for intro and intro 2 images
    for (int i = 0; i < _imageAssets.length - 1; i++) {
      // Add condition to not show indicator if image index is 2 (intro 3)
      if (i != 2 && _currentPage != 2) {
        indicators.add(
          Container(
            width: 8,
            height: 8,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == _currentPage ? Colors.white : Colors.grey,
            ),
          ),
        );
      }
    }
    return indicators;
  }

  void _animateButtons() {
    setState(() {
      _nextButtonOffset = _currentPage == _imageAssets.length - 1 ? -80.0 : 0.0;
      _backButtonOffset = _currentPage == 0 ? -80.0 : 0.0;
    });
  }
}
