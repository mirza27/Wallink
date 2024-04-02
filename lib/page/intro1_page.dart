// intro1_page.dart

import 'package:flutter/material.dart';
import 'package:wallink_v1/page/intro2_page.dart'; // Import IntroPage2

class IntroPage1 extends StatelessWidget {
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
