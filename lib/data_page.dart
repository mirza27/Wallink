import 'package:flutter/material.dart';
import 'package:wallink_v1/models/category.dart';
import 'package:wallink_v1/models/sub_category.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/controller/sub_category_controller.dart';
import 'package:wallink_v1/controller/category_controller.dart';
// import 'package:flutter/foundation.dart';
import 'dart:developer';

class DataPage extends StatefulWidget {
  const DataPage({super.key});

  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _subCategories = [];
  List<Map<String, dynamic>> _link = [];
  String subCategoryInfo = "";


  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
   List<Map<String, dynamic>> categories =
        await getCategories();
    List<Map<String, dynamic>> subCategories =
        await getSubCategoryByCategoryId(2);
    List<Map<String, dynamic>> link = await getAllLink();

    // int linkId = 1;
    // // Memanggil fungsi getSubCategoryInfo dan mencetak hasilnya
    // subCategoryInfo = await getSubCategoryInfo(linkId);

    setState(() {
       _categories = categories;
      _subCategories = subCategories;
      _link = link;
    });
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
            // _buildSubCategoryList(),
            // _buildLinkList(),
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
      ListView.separated(
        shrinkWrap: true,
        itemCount: _categories.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(), // Menambahkan pemisah antara setiap item
        itemBuilder: (context, index) {
          // Mendapatkan kategori dari _categories
          Category category = Category.fromMap(_categories[index]);
          return ListTile(
            title: Text('${category.nameCategory} (ID: ${category.id})'), // Menggunakan nama dan id dari kategori
          );
        },
      ),
    ],
  );
}


  // Widget _buildSubCategoryList() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Subcategories:',
  //         style: TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //       ListView.builder(
  //         shrinkWrap: true,
  //         itemCount: subCategories.length,
  //         itemBuilder: (context, index) {
  //           return ListTile(
  //             title: Text(
  //                 '${subCategories[index].subCategoryName} (ID: ${subCategories[index].id}) (CategoryID: ${subCategories[index].categoryId})'),
  //           );
  //         },
  //       ),
  //     ],
  //   );
  // }

  // Widget _buildLinkList() {
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       const Text(
  //         'Links:',
  //         style: TextStyle(fontWeight: FontWeight.bold),
  //       ),
  //       ListView.builder(
  //         shrinkWrap: true,
  //         itemCount: links.length,
  //         itemBuilder: (context, index) {
  //           return ListTile(
  //             title: Text(
  //                 '${links[index].linkName} (ID: ${links[index].id}) (SubCategoryID: ${links[index].subCategoryId})'),
  //             subtitle: Text('${links[index].link}'),
  //           );
  //         },
  //       ),
  //     ],
  //   );
  
}
