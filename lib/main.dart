import 'package:flutter/material.dart';
import 'package:wallink_v1/page/category_page.dart';
import 'package:wallink_v1/page/intro_slide_page.dart';
import 'package:wallink_v1/database/app_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key,});

  @override
  Widget build(BuildContext context) {
   return FutureBuilder<bool>(
      future: AppPreferences.isFirstTime(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final bool? isFirstTime = snapshot.data; // ambil dari nilai isFirstTime
            return MaterialApp(
              title: 'WALINK',
              home: isFirstTime! ? const IntroSlidePage() : const CategoryPage(),
            );
          }
        }
      },
    );
  }
}
