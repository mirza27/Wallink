import 'package:flutter/material.dart';
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
                child: index == 2 // Tampilkan tombol hanya jika indeks gambar adalah 2
                    ? Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24.0), // Sesuaikan jarak ke bawah di sini
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PreferencePage(),
                                ),
                              );
                            },
                            child: const Text('Get Started'),
                          ),
                        ),
                      )
                    : const SizedBox(),
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
          AnimatedPositioned(
            duration: const Duration(milliseconds: 500),
            bottom: 20,
            left: _backButtonOffset,
            child: TextButton(
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
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildIndicators() {
    List<Widget> indicators = [];
    // Menampilkan indikator hanya untuk gambar intro dan intro 2
    for (int i = 0; i < _imageAssets.length - 1; i++) {
      // Tambahkan kondisi untuk tidak menampilkan indikator jika indeks gambar adalah 2 (intro 3)
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
