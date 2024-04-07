import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallink_v1/controller/category_controller.dart';
import 'package:wallink_v1/models/category.dart';
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

  // refresh dan load data
  Future<void> _loadData() async {
    List<Map<String, dynamic>> categories = await getCategories();

    setState(() {
      _categories = categories;
    });
  }

  // add category
  Future<void> _addCategory(String categoryName) async {
    await insertCategory(categoryName);
    await _loadData();
  }

  // delete category
  void _deleteCategory(int categoryId) async {
    await deleteCategory(categoryId);
    await _loadData();
  }

// update category update
  Future<void> _editCategory(Category category) async {
    TextEditingController controller =
        TextEditingController(text: category.nameCategory);
    FocusNode focusNode = FocusNode();

    await showDialog(
      // menampilkan pop up edit
      context: context,
      builder: (context) {
        // keyboard aktif langsung
        WidgetsBinding.instance
            .addPostFrameCallback((_) => focusNode.requestFocus());

        return AlertDialog(
          title: const Text('Update Category'),
          content: TextField(
            controller: controller,
            focusNode: focusNode,
            decoration:
                const InputDecoration(hintText: 'Enter new category name'),
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
                await editCategory(category.id!, newName);
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
        // actions: [
        //   Padding(
        //     padding: const EdgeInsets.only(
        //       right: 8.0,
        //       top: 12.0,
        //       bottom: 12.0,
        //     ),
        //     child: IconButton(
        //       icon: const Icon(Icons.search),
        //       onPressed: () {
        //         // Handle search icon tap here
        //       },
        //     ),
        //   ),
        // ],
      ),
      body: _categories.isEmpty
          ? Column(
            children: [
              Expanded(
                child: Center(
                    // Tampilkan gambar jika _Categories kosong
                    child: Image.asset(
                      'assets/no_data.png',
                      width: 350,
                      height: 350,
                    ),
                  ),
              ),
              Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Container(
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
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: IconButton(
                              // tambah category
                              icon: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add),
                                  Text(
                                    "Tambah Category",
                                    style: GoogleFonts.lexend(
                                      color: const Color.fromARGB(
                                          255, 255, 254, 234),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              iconSize: 35,
                              color: const Color.fromARGB(255, 255, 254, 234),
                              onPressed: () {
                                _addCategory("New Category");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
            ],
          )
          // jik data ada
          : Column(
              children: [
                Expanded(
                  child: SizedBox(
                    child: ListView.builder(
                      // iterasi widget category card
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final Category category =
                            Category.fromMap(_categories[index]);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 4.0, horizontal: 8.0),
                          child: CategoryCard(
                              category: category,
                              onDelete: _deleteCategory,
                              onUpdate: _editCategory),
                        );
                      },
                    ),
                  ),
                ),
                // add category button
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: Container(
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
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: IconButton(
                              // tambah category
                              icon: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const Icon(Icons.add),
                                  Text(
                                    "Tambah Category",
                                    style: GoogleFonts.lexend(
                                      color: const Color.fromARGB(
                                          255, 255, 254, 234),
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                              iconSize: 35,
                              color: const Color.fromARGB(255, 255, 254, 234),
                              onPressed: () {
                                _addCategory("New Category");
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
