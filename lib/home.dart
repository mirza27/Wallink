import 'package:flutter/material.dart';
import 'package:wallink_v1/links.dart';
import 'package:wallink_v1/category_tile.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallink"),
      ),
      body: ListView.builder(
        itemCount: listData.length,
        itemBuilder: (context, index) {
          final data = listData[index];

          // CategoryTile
          return CategoryTile(
            categoryName: data.categoryName,
            subCategories: data.subCategories,
          );
        },
      ),
    );
  }
}
