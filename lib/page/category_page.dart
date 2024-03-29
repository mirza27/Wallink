import 'package:flutter/material.dart';
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
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(
            left: 8.0,
            top: 12.0,
            bottom: 12.0,
          ),
          child: Text(
            'Wallink',
            style: TextStyle(
              fontWeight: FontWeight.bold
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(
              right: 8.0,
              top: 12.0,
              bottom: 12.0,
            ),
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                // Handle search icon tap here
              },
            ),
          ),
        ],
      ),
      body: Column(
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
                    padding: EdgeInsets.symmetric(
                      vertical: 4.0,
                      horizontal: 8.0
                    ),
                    child: CategoryCard(
                      category: category,
                      onDelete: _deleteCategory,
                      onUpdate: _editCategory
                    ),
                  );
                  // return CategoryCard(
                  //   category: category,
                  //   onDelete: _deleteCategory,
                  //   onUpdate: _editCategory,
                  // );
                },
              ),
            ),
          ),
          IconButton( // tambah category
              icon: const Icon(
                Icons.add
              ),
              onPressed: () {
                _addCategory("New Category");
              })
        ],
      ),
    );
  }
}
