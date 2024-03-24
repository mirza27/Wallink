import 'package:flutter/material.dart';
import 'package:wallink_v1/data_links.dart';
import 'package:wallink_v1/sub_category_tile.dart';

class CategoryTile extends StatefulWidget {
  final String categoryName;
  final List<SubCategory> subCategories;

  const CategoryTile({
    super.key,
    required this.categoryName,
    required this.subCategories,
  });

  @override
  State<CategoryTile> createState() => _CategoryTileState();
}


class _CategoryTileState extends State<CategoryTile> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey,
      child: ExpansionTile(
          initiallyExpanded: _isExpanded,
          onExpansionChanged: (expanded) {
            setState(() {
              _isExpanded = expanded;
            });
          },
          title: Text(widget.categoryName),
          children: [
            ...widget.subCategories.asMap().entries.map((entry) {
              final indexSub = entry.key;
              final subCategory = entry.value;
              return SubCategoryTile(
                subCategoryName: subCategory.subCategoryName,
                links: subCategory.links,
                onDelete: () {
                  _deleteSubcategory(indexSub);
                },
              );
            }).toList(),

            // tombol tambah subcategory
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _addNewSubCategory();
                })
          ]),
    );
  }

  // ADD SUB CATEGORY
  void _addNewSubCategory() {
    setState(() {
      final newSubCategory =
          SubCategory(subCategoryName: "New Sub Category", links: []);
      widget.subCategories.add(newSubCategory);
    });
  }

  // DELETE SUB CATEGORY
  void _deleteSubcategory(int indexSub) {
    setState(() {
      widget.subCategories.removeAt(indexSub);
    });
  }
}
