import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/controller/sub_category_controller.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/models/sub_category.dart';
import 'package:wallink_v1/widgets/sub_category_card.dart';

class SubCategoryPage extends StatefulWidget {
  final int? categoryId;

  const SubCategoryPage({
    super.key,
    required this.categoryId,
  });

  @override
  State<SubCategoryPage> createState() => _SubCategoryPageState();
}

class _SubCategoryPageState extends State<SubCategoryPage> {
  List<Map<String, dynamic>> _subCategories = [];
  List<Map<String, dynamic>> _links = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    List<Map<String, dynamic>> subCategories = await getSubCategoryByCategoryId(
        widget.categoryId); // parameter dari widget

    // ambil semua link untuk difilter di sub category card
    List<Map<String, dynamic>> links = await getAllLink();

    setState(() {
      _subCategories = subCategories;
      _links = links;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallink'),
      ),
      body: ListView.builder(
          // iterasi widget sub category card
          itemCount: _subCategories.length,
          itemBuilder: (context, index) {
            final SubCategory category =
                SubCategory.fromMap(_subCategories[index]);

            // filter link berdasarkan sub category id
            final filteredLinks = _links
                .where((link) => link[LinkFields.columnSubCategoryId] == category.id)
                .toList();
            return SubCategoryCard(
              subCategory: category,
              links: filteredLinks, // parameter kelas subcategory
            );
          }),
    );
  }
}
