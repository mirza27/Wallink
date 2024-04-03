import 'package:flutter/material.dart';
//import 'package:wallink_v1/page/category_page.dart';
import 'package:wallink_v1/page/intro1_page.dart';
import 'package:wallink_v1/page/intro3_page.dart';
import 'package:wallink_v1/page/intro_list_page.dart';
//import 'package:wallink_v1/page/intro_list_page.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WALINK',
      home: IntroPage1(),
    );
  }
}
