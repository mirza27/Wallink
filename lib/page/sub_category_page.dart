import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/controller/sub_category_controller.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/models/sub_category.dart';
import 'package:wallink_v1/widgets/category_mini_card.dart';
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
  // List<Map<String, dynamic>> _links = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // refresh dan load data
  Future<void> _loadData() async {
    List<Map<String, dynamic>> subCategories = await getSubCategoryByCategoryId(
        widget.categoryId); // parameter dari widget

    // ambil semua link untuk difilter di sub category card
    // List<Map<String, dynamic>> links = await getAllLink();

    setState(() {
      _subCategories = subCategories;
      // _links = links;
    });
  }

  // add new sub category
  Future<void> _addSubCategory(String subCategoryName, int categoryId) async {
    await insertSubCategory(subCategoryName, categoryId);
    await _loadData();
  }

  // delete sub category
  Future<void> _deleteSubCategory(int subCategoryId) async {
    await deleteSubCategory(subCategoryId);
    await _loadData();
  }

  // edit sub category
  Future<void> _editSubCategory(SubCategory subCategory) async {
    TextEditingController controller =
        TextEditingController(text: subCategory.subCategoryName);
    FocusNode focusNode = FocusNode();

    await showDialog(
      // menampilkan pop up edit
      context: context,
      builder: (context) {
        // keyboard aktif langsung
        WidgetsBinding.instance
            .addPostFrameCallback((_) => focusNode.requestFocus());

        return AlertDialog(
          title: const Text('Update Sub Category'),
          content: TextField(
            controller: controller,
            focusNode: focusNode,
            decoration:
                const InputDecoration(hintText: 'Enter new sub category name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newName = controller.text;
                await editSubCategory(subCategory.id!, newName);
                Navigator.pop(context);
                await _loadData();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // INTERFACE UTAMA ================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallink'),
        bottom: PreferredSize(
          preferredSize:
              Size.fromHeight(60), // Sesuaikan tinggi sesuai kebutuhan
          child: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: Padding(
              padding: EdgeInsets.only(bottom: 8.0),
              child: CategoryMiniCard(),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: ListView.builder(
                  // iterasi widget sub category card
                  itemCount: _subCategories.length,
                  itemBuilder: (context, index) {
                    final SubCategory subCategory =
                        SubCategory.fromMap(_subCategories[index]);

                    return SubCategoryCard(
                      // parameter kelas subcategory
                      subCategory: subCategory,
                      onDelete: _deleteSubCategory,
                      onUpdate: _editSubCategory,
                    );
                  }),
            ),
          ),
          // tambah sub category
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () {
                _addSubCategory("New Sub Category", widget.categoryId!);
              }),
        ],
      ),
    );
  }
}
