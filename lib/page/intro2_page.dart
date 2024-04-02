// intro2_page.dart

import 'package:flutter/material.dart';
import 'package:wallink_v1/page/intro3_page.dart'; // import halaman IntroPage3

class IntroPage2 extends StatefulWidget {
  @override
  _IntroPage2State createState() => _IntroPage2State();
}

class _IntroPage2State extends State<IntroPage2> {
  @override
  void initState() {
    super.initState();
    // Menambahkan delay sebelum navigasi ke IntroPage3
    Future.delayed(Duration(milliseconds: 2500), () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => IntroPage3(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/intro2.png', // Ganti dengan path gambar Anda
            fit: BoxFit.cover,
          ),
        ],
      ),
    );
  }
}