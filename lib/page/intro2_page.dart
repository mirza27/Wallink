import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wallink_v1/page/category_page.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    super.initState();
    _checkOnboardingStatus();
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
            'assets/intro.png', // Ganti dengan path gambar Anda
            fit: BoxFit.cover,
          ),
          // Konten di atas gambar
          Center(
            child: Text(
              '', // Ganti dengan konten Anda
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          // Tombol di tengah bawah
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
                            CategoryPage()), // Ganti dengan halaman berikutnya
                  );
                },
                child: Text('Get Started'), // Ganti dengan teks tombol Anda
              ),
            ),
          ),
        ],
      ),
    );
  }
}
