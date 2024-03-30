import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/category_controller.dart';
import 'package:wallink_v1/models/category.dart';

class CategoryMiniCard extends StatefulWidget {
  const CategoryMiniCard({super.key});

  @override
  State<CategoryMiniCard> createState() => _CategoryMiniCardState();
}

class _CategoryMiniCardState extends State<CategoryMiniCard> {
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // refresh dan load data
  Future<void> _loadData() async {
    List<Map<String, dynamic>> categories = await getCategories();

    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (BuildContext context, int index) {
          final Category category =
                      Category.fromMap(_categories[index]);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Chip(
              label: Text(category.nameCategory as String),
              backgroundColor: Colors.blue,
              labelStyle: const TextStyle(color: Colors.white),
            ),
          );
        },
      ),
    );
  }
}
