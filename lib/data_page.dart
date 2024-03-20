import 'package:flutter/material.dart';
import 'package:wallink_v1/models/category.dart';
import 'package:wallink_v1/models/sub_category.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/controller/sub_category_controller.dart';
import 'package:wallink_v1/controller/category_controller.dart';

class DataPage extends StatefulWidget {
const DataPage({super.key});

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<Category> categories = [];
  List<SubCategory> subCategories = [];
  List<Link> links = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    categories = await getAllCategory();
    subCategories = await getAllSubCategory();
    links = await getAllLink();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data Page'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryList(),
            _buildSubCategoryList(),
            _buildLinkList(),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Categories:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${categories[index].categoryName} (ID: ${categories[index].id})'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildSubCategoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Subcategories:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: subCategories.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${subCategories[index].subCategoryName} (ID: ${subCategories[index].id}) (CategoryID: ${subCategories[index].categoryId})'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLinkList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Links:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        ListView.builder(
          shrinkWrap: true,
          itemCount: links.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text('${links[index].linkName} (ID: ${links[index].id}) (SubCategoryID: ${links[index].subCategoryId})'),
              subtitle: Text('${links[index].link}'),
            );
          },
        ),
      ],
    );
  }
}
