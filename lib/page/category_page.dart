import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/category_controller.dart';
import 'package:wallink_v1/models/category.dart';
import 'package:wallink_v1/page/sub_category_page.dart';
import 'package:wallink_v1/widgets/category_card.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    List<Map<String, dynamic>> categories = await getCategories();

    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallink"),
      ),
      body: ListView.builder(
          // iterasi widget category card
          itemCount: _categories.length,
          itemBuilder: (context, index) {
            final Category category = Category.fromMap(_categories[index]);
            return CategoryCard(
              category: category, // parameter kelas category
            );
          }),
    );
  }
}
