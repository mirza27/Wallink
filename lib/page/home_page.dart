import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/models/sub_category.dart';
import 'package:wallink_v1/controller/sub_category_controller.dart';
import 'package:wallink_v1/widgets/category_mini_card.dart';
import 'package:wallink_v1/widgets/link_card.dart';
import 'package:wallink_v1/widgets/sub_category_card.dart';
import 'package:wallink_v1/page/sidebar.dart';

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
  Future<void> _tes(int tes) async {}

  Future<void> _tes2(SubCategory tes) async {}

  // FUNGSI LINK
  // delete link
  Future<void> _deleteLink(int linkId) async {}

  Future<void> _editLink(Link link) async {}

  Future<void> _showBottomSheet(BuildContext context, int index) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.archive),
              title: const Text('Archive'),
              onTap: () {},
            ),
          ],
        );
      },
    );
  }

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
                      return GestureDetector(
                        onLongPress: () {
                          _showBottomSheet(context, index);
                        },
                        child: SubCategoryCard(
                          
                          subCategory: subCategory,
                          onDelete: _tes,
                          onUpdate: _tes2,
                        ),
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
                          onDelete: _deleteLink,
                          onUpdate: _editLink,
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
