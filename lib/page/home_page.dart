import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/models/sub_category.dart';
import 'package:wallink_v1/controller/sub_category_controller.dart';
import 'package:wallink_v1/widgets/category_mini_card.dart';
import 'package:wallink_v1/widgets/link_card.dart';
import 'package:wallink_v1/widgets/sub_category_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> links = []; // menyimpan semua link secara statis
  List<Map<String, dynamic>> _links =
      []; // menyimpan link  dinamis (burubah saat searching)
  List<Map<String, dynamic>> _subCategories = [];
  final TextEditingController _searchController = TextEditingController();
  int _categoryId = 0;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // logika search
  Future<void> _search(String keywords) async {
    List<Map<String, dynamic>> results = [];
    if (keywords.isEmpty) {
      results = _links;
    } else {
      results = links
          .where((link) => link['link_name']
              .toString()
              .toLowerCase()
              .contains(keywords.toLowerCase()))
          .toList();
    }
    setState(() {
      _links = results;
    });
  }

  // memilih category setelah dipanggil pada mini card
  Future<void> _chooseCategory(int categoryId) async {
    setState(() {
      _categoryId = categoryId;
    });
    print("home ganti category $_categoryId");
    _loadData();
  }

  // refresh dan load data
  Future<void> _loadData() async {
    List<Map<String, dynamic>> subCategories = await getSubCategoryByCategoryId(
        _categoryId); // mengisi link berdasarkan sub
    links = await getAllLink(); // Menyimpan semua data link statis

    setState(() {
      _subCategories = subCategories;
      _links = links;
    });
  }

  // FUNGSI SUBCATEGORY
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
                String newName = controller.text.trim();
                // Edit tidak boleh kosong
                if (newName.isNotEmpty) {
                  // Jika input tidak kosong
                  await editSubCategory(subCategory.id!, newName);
                  Navigator.pop(context);
                  await _loadData();
                } else {
                  // Jika input kosong
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Please fill all fields'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                }
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // FUNGSI LINK
  // delete link
  Future<void> _deleteLink(int linkId) async {}

  Future<void> _editLink(Link link) async {}

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 249, 251, 1),
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(120),
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(252, 252, 253, 1),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(139, 141, 152, 1),
                  spreadRadius: 0.5,
                  blurRadius: 1,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                    child: Row(
                      children: [
                        Builder(
                          builder: (BuildContext context) {
                            return IconButton(
                              icon: const Icon(Icons.menu),
                              onPressed: () {
                                Scaffold.of(context).openDrawer();
                              },
                            );
                          },
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                _isSearching = true;
                              } else {
                                _isSearching = false;
                              }
                              _search(value);
                            },
                            decoration: InputDecoration(
                              suffixIcon: const Icon(Icons.search),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 15.0),
                              filled: true,
                              focusColor: Color.fromRGBO(5, 105, 220, 1),
                              fillColor: Color.fromRGBO(239, 240, 243, 1),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(239, 240, 243, 1),
                                  width: 1.0,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(239, 240, 243, 1),
                                  width: 1.0,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20.0),
                                borderSide: const BorderSide(
                                  color: Color.fromRGBO(239, 240, 243, 1),
                                  width: 1.0,
                                ),
                              ),
                              hintText: 'Search Your Link',
                              hintStyle: const TextStyle(
                                fontSize: 16.0,
                                color: Color.fromRGBO(139, 141, 152, 1),
                              ),
                              alignLabelWithHint: true,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: CategoryMiniCard(
                      categoryId: null,
                      onCategoryChanged: _chooseCategory,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      // ini sidebar anjer

      body: !_isSearching
          ? Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _subCategories.length,
                    itemBuilder: (context, index) {
                      final SubCategory subCategory =
                          SubCategory.fromMap(_subCategories[index]);
                      return SubCategoryCard(
                        
                        subCategory: subCategory,
                        onDelete: _deleteSubCategory,
                        onUpdate: _loadData,
                      );
                    },
                  ),
                ),
              ],
            )
          : Column(
              children: [
                Expanded(
                  child: SizedBox(
                    child: ListView.builder(
                      itemCount: _links.length,
                      itemBuilder: ((context, index) {
                        final Link link = Link.fromMap(_links[index]);
                        return LinkCard(
                          key: ValueKey(link.id),
                          link: link,
                          onChanged: _loadData,
                        );
                      }),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
