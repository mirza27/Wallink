import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/category_controller.dart';
import 'package:wallink_v1/models/category.dart';

class CategoryMiniCard extends StatefulWidget {
  final int? categoryId;
  final Function onCategoryChanged;

  const CategoryMiniCard(
      {super.key, required this.categoryId, required this.onCategoryChanged});

  @override
  State<CategoryMiniCard> createState() => _CategoryMiniCardState();
}

class _CategoryMiniCardState extends State<CategoryMiniCard> {
  List<Map<String, dynamic>> _categories = [];
  int _activeCategory = 0;

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40.0,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (BuildContext context, int index) {
          final Category category = Category.fromMap(_categories[index]);
          final bool isActive = _activeCategory ==
              category.id; // logika jika aktif dan tidak aktif

          return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _activeCategory = category.id!;
                    widget.onCategoryChanged(category.id);
                  });
                },
                child: Chip(
                    label: Text(
                      category.nameCategory as String, style: const TextStyle(fontSize: 16),
                    ),
                    backgroundColor: isActive
                        ? const Color.fromRGBO(201, 226, 255, 1)
                        : const Color.fromRGBO(239, 240, 243, 1),
                    labelStyle: TextStyle(
                      color: isActive
                          ? const Color.fromRGBO(5, 105, 220, 1)
                          : const Color.fromRGBO(139, 141, 152, 1),
                    ),
                    shape: RoundedRectangleBorder(
                      
                      borderRadius: BorderRadius.circular(20.0),
                      side: const BorderSide(
                        color: Colors.transparent
                        
                      )
                    )

                    ),
              ));
        },
      ),
    );
  }
}
