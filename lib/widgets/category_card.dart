import 'package:flutter/material.dart';
import 'package:wallink_v1/models/category.dart';
import 'package:wallink_v1/page/sub_category_page.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  CategoryCard({
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () { // redirect ke subcategory page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategoryPage(categoryId: category.id),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Text(category.nameCategory as String),
          subtitle: Text('ID: ${category.id.toString()}'),
        ),
      ),
    );
  }
}
