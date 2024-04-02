import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/category_controller.dart';
import 'package:wallink_v1/models/category.dart';
import 'package:wallink_v1/page/sub_category_page.dart';

class CategoryMiniCard extends StatefulWidget {
  final int? categoryId;

  const CategoryMiniCard({Key? key, required this.categoryId})
      : super(key: key);

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
          final Category category = Category.fromMap(_categories[index]);
          final bool isActive = widget.categoryId ==
              category.id; // logika jika aktif dan tidak aktif

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onTap: () {
                // redirect ke subcategory page
                // Kembali ke halaman sebelumnya
                Navigator.pop(context);
                // Navigasi ke halaman target
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SubCategoryPage(categoryId: category.id),
                  ),
                );
              },
              child: Chip(
                label: Text(category.nameCategory as String),
                backgroundColor: isActive ? const Color(0xFF181823) : const Color(0xFFFFFFFF),
                labelStyle: TextStyle(color: isActive ? const Color(0xFFFFFFFF) : const Color(0xFF181823).withOpacity(0.8)),
              ),
            ),
          );
        },
      ),
    );
  }
}
