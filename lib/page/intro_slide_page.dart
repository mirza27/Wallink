import 'package:flutter/material.dart';
import 'package:wallink_v1/page/category_page.dart';
import 'package:wallink_v1/page/intro_list_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntroSlidePage extends StatefulWidget {
  @override
  _IntroSlidePageState createState() => _IntroSlidePageState();
}

// EDITEN BUTTON BEN APIK PLSS
class _IntroSlidePageState extends State<IntroSlidePage> {
  late PageController _pageController;
  int _currentPage = 0;
  final List<String> _imageAssets = [
    'assets/intro.png',
    'assets/intro2.png',
    'assets/intro3.png',
  ];

  void _checkOnboardingStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
    if (isFirstTime) {
      await prefs.setBool('isFirstTime', false);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CategoryPage()),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    //_checkOnboardingStatus();     // Iki diaktifne lek pgn sekali muncul
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
                child: index == _imageAssets.length - 1
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10, left: 200),
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => IntroListPagge(),
                                ),
                              );
                            },
                            child: Text('Get Started'),
                          ),
                        ),
                      )
                    : SizedBox(),
              );
            },
          ),
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildIndicators(),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < _imageAssets.length; i++) {
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
    return indicators;
  }
}
