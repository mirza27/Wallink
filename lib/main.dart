import 'package:flutter/material.dart';
import 'package:wallink_v1/home.dart';
import 'package:wallink_v1/page/category_page.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: CategoryPage()
      // home: Home()
    );
  }
}

