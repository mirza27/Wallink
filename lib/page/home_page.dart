import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/database/app_preferences.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/models/sub_category.dart';
import 'package:wallink_v1/controller/sub_category_controller.dart';
import 'package:wallink_v1/widgets/category_mini_card.dart';
import 'package:wallink_v1/widgets/link_card.dart';
import 'package:wallink_v1/widgets/sub_category_card.dart';

class HomePage extends StatefulWidget {
  final WidgetBuilder drawerButton;
  const HomePage({required this.drawerButton, super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> links = []; // menyimpan semua link secara statis
  List<Map<String, dynamic>> _links =
      []; // menyimpan link  dinamis (burubah saat searching)
  List<Map<String, dynamic>> _subCategories = [];
  final TextEditingController _searchController = TextEditingController();
  int _categoryId = 0; // category terplih saat ini
  bool _isSearching = false;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
    _loadLastcategory();
  }

  Future<void> _loadLastcategory() async {
    int categoryId = await AppPreferences.getLastCategory();
    if (categoryId != 0) {
      setState(() {
        _categoryId = categoryId;
      });
    }
    _loadData();
  }

  // get preference always expanded
  Future<void> _loadPreferences() async {
    bool alwaysExpanded = await AppPreferences.isExpanded();
    setState(() {
      _isExpanded = alwaysExpanded;
    });
    print("nilia expanded: $_isExpanded");
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

  @override
  Widget build(BuildContext context) {
    // var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(249, 249, 251, 1),
      appBar: AppBar(
        shadowColor: Colors.black,
        bottom: PreferredSize(
          preferredSize: !_isSearching
              ? Size.fromHeight(0.1 * height)
              : Size.fromHeight(0.05 * height),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                child: Row(
                  children: [
                    widget.drawerButton(context),
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
                          focusColor: const Color.fromRGBO(5, 105, 220, 1),
                          fillColor: const Color.fromRGBO(239, 240, 243, 1),
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
                            fontFamily: 'sharp',
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
              if (!_isSearching) ...{
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                  child: CategoryMiniCard(
                    categoryId: _categoryId,
                    onCategoryChanged: _chooseCategory,
                  ),
                ),
              } else
                const Padding(
                  padding: EdgeInsets.fromLTRB(15, 5, 5, 15),
                )
            ],
          ),
        ),
      ),
      // ini sidebar anjer

      body: !_isSearching
          ? RefreshIndicator(
              onRefresh: () {
                return Future.delayed(Duration.zero, () {
                  _loadPreferences();
                  _loadData();
                });
              },
              child: Column(
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
                          isExpanded: _isExpanded,
                        );
                      },
                    ),
                  ),
                ],
              ),
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
