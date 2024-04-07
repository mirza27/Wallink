import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallink_v1/controller/sub_category_controller.dart';
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

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // refresh dan load data
  Future<void> _loadData() async {
    List<Map<String, dynamic>> subCategories = await getSubCategoryByCategoryId(
        widget.categoryId); // parameter dari widget

    setState(() {
      _subCategories = subCategories;
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
      backgroundColor: const Color.fromARGB(255, 255, 254, 234),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 254, 234),
        title: Padding(
          padding: const EdgeInsets.only(
            left: 8.0,
            top: 15.0,
            bottom: 13.0,
          ),
          child: Text(
            'Wallink',
            style: GoogleFonts.lexend(
              fontWeight: FontWeight.w800,
              fontSize: 30,
            ),
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: PreferredSize(
            preferredSize: const Size.fromHeight(50.0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),

              // iterasi mini card category
              child: CategoryMiniCard(
                categoryId: widget.categoryId,
              ),
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
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              width: double.infinity,
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [Color(0xFFB6FFFA), Color(0xFF537FE7)],
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(32)),
                shadows: const [
                  BoxShadow(
                    color: Color(0x4C537FE7),
                    blurRadius: 3,
                    offset: Offset(0, 3),
                    spreadRadius: 0,
                  )
                ],
              ),
              child: IconButton(
                icon: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.add),
                    Text(
                      "Tambah Sub Category",
                      style: GoogleFonts.lexend(
                        color: const Color.fromARGB(255, 255, 254, 234),
                        fontSize: 17,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                iconSize: 35,
                color: const Color.fromARGB(255, 255, 254, 234),
                onPressed: () {
                  _addSubCategory("New Sub Category", widget.categoryId!);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
