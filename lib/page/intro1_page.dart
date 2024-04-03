import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallink_v1/page/category_page.dart';
import 'package:wallink_v1/page/intro2_page.dart';

class IntroPage1 extends StatefulWidget {
  @override
  _IntroPage1State createState() => _IntroPage1State();
}

class _IntroPage1State extends State<IntroPage1> {
  @override
  void initState() {
    super.initState();
    //_checkOnboardingStatus(); //  IKI DIAKTIFNE LEK PGN CUMA SEKALI MUNCU
  }

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/intro.png', // Replace with your image path
            fit: BoxFit.cover,
          ),
          // Button at the bottom center
          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          IntroPage2(), // Navigate to IntroPage2
                    ),
                  );
                },
                child: Text('Get Started'), // Customize your button text
              ),
            ),
          ),
        ],
      ),
    );
  }
}
