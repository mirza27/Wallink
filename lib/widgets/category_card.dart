import 'package:flutter/material.dart';
import 'package:wallink_v1/models/category.dart';
import 'package:wallink_v1/page/sub_category_page.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final Function(int) onDelete; // memanggil fungsi delete di category page
  final Function(Category) onUpdate; // memanggil fungsi edit di category page

  const CategoryCard(
      {super.key, required this.category, required this.onDelete, required this.onUpdate});

  // MAIN WIDGET ==================================================
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // redirect ke subcategory page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategoryPage(categoryId: category.id),
          ),
        );
      },
      child: Card(
        child: ListTile(
          title: Row(
            children: [
              Text(category.nameCategory as String),
              IconButton(
            icon: const Icon(
              Icons.edit,
              size: 17,
            ),
            onPressed: () {
              onUpdate(category);
            },
          ),
          IconButton(
            // icon delete
            icon: const Icon(
              Icons.delete,
              size: 17,
            ),
            onPressed: () {
              onDelete(category.id!);
            },
          ),
            ],
          ),
          subtitle: Text('ID: ${category.id.toString()}'),
        ),
      ),
    );
  }
}
