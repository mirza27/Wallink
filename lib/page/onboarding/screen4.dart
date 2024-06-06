import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Screen4 extends StatelessWidget {
  const Screen4({super.key});

  @override
  Widget build(BuildContext context) {
    var orientation = MediaQuery.of(context).orientation;
    var isLandscape = orientation == Orientation.landscape;

    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 5, 105, 220),
              Color.fromARGB(0, 255, 255, 255),
              Colors.transparent
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: isLandscape ? 16.0 : 40.0,
              horizontal: 16.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 100,
                ),
                Image.asset(
                  "assets/share-illustration.png",
                  width: isLandscape
                      ? MediaQuery.of(context).size.width * 0.5
                      : MediaQuery.of(context).size.width * 0.9,
                ),
                SizedBox(height: isLandscape ? 10 : 20),
                Text(
                    'Bagikan Link dengan Mudah',
                    style: GoogleFonts.urbanist(
                      fontSize: isLandscape ? 18 : 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                Padding(
                  padding: isLandscape
                      ? const EdgeInsets.all(10)
                      : const EdgeInsets.all(20),
                  child: Text(
                    'Bagikan kumpulan link dengan mudah dan praktis kepada teman atau kolega Anda dalam sekali klik.',
                    style: GoogleFonts.urbanist(
                      fontSize: isLandscape ? 16 : 18,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: isLandscape ? 20 : 200),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
