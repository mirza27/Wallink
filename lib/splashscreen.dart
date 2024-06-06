import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallink_v1/database/app_preferences.dart';
import 'package:wallink_v1/page/onboarding/onboarding.dart';
import 'package:wallink_v1/route_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2)); // Simulate a delay

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => FutureBuilder<bool>(
          future: AppPreferences.isFirstTime(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                final bool? isFirstTime =
                    snapshot.data; // ambil dari nilai isFirstTime

                return GetMaterialApp(
                  title: 'WALINK',
                  home: isFirstTime!
                      ? const OnBoarding()
                      : const RoutePage(
                          selectedIndex: 0,
                        ),
                );
              }
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.blue],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 50, left: 50),
            child: Image.asset("assets/wallink-logo.png"),
          ),
        ),
      ),
    );
  }
}
