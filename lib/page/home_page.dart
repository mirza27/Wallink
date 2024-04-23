import 'package:flutter/material.dart';
import 'package:wallink_v1/models/sub_category.dart';
import 'package:wallink_v1/controller/sub_category_controller.dart';
import 'package:wallink_v1/widgets/category_mini_card.dart';
import 'package:wallink_v1/widgets/sub_category_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _subCategories = [];
  int? _categoryId = null;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadData();
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
    List<Map<String, dynamic>> subCategories =
        await getSubCategoryByCategoryId(_categoryId); // parameter dari widget

    setState(() {
      _subCategories = subCategories;
    });
  }

  Future<void> _tes(int tes) async {}

  Future<void> _tes2(SubCategory tes) async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 249, 251, 1),
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(91),
          // Search field
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(252, 252, 253, 1),
              //   border: Border(
              //   bottom: BorderSide(
              //       color: Color.fromRGBO(216, 217, 224, 1),
              //       width: 0.5), // Menambahkan top border
              // ),
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(139, 141, 152, 1), // Warna shadow
                  spreadRadius: 0.5, // Radius penyebaran shadow
                  blurRadius: 1, // Radius blur shadow
                  offset: Offset(0, 1), // Offset shadow
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  SearchAnchor(builder:
                      (BuildContext context, SearchController controller) {
                    return SearchBar(
                      backgroundColor:
                          MaterialStateProperty.resolveWith<Color?>(
                        (Set<MaterialState> states) {
                          if (states.contains(MaterialState.disabled)) {
                            return const Color.fromRGBO(239, 240, 243, 1); // Warna latar belakang saat dalam keadaan disabled
                          }
                          return const Color(10); // Warna latar belakang default
                        },
                      ),
                      hintText: "Search Your Link",
                      controller: controller,
                      padding: const MaterialStatePropertyAll<EdgeInsets>(
                          EdgeInsets.symmetric(horizontal: 16.0)),
                      onTap: () {
                        controller.openView();
                      },
                      onChanged: (_) {
                        controller.openView();
                      },
                    );
                  }, suggestionsBuilder:
                      (BuildContext context, SearchController controller) {
                    return List<ListTile>.generate(5, (int index) {
                      final String item = 'item $index';
                      return ListTile(
                        title: Text(item),
                        onTap: () {
                          setState(() {
                            controller.closeView(item);
                          });
                        },
                      );
                    });
                  }),

                  // mini card
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),

                    // iterasi mini card category
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

      // List subcategory tiles
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
                      onDelete: _tes,
                      onUpdate: _tes2,
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
