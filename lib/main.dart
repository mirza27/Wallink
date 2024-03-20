import 'package:flutter/material.dart';
import 'package:wallink_v1/data_page.dart';
import 'package:wallink_v1/home.dart';


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: DataPage() // tes database
      // home: Home()
    );
  }
}

