import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallink_v1/controller/category_controller.dart';
import 'package:wallink_v1/controller/notif_controller.dart';
import 'package:wallink_v1/database/app_preferences.dart';
import 'package:wallink_v1/dialog/delete_confirmation.dart';
import 'package:wallink_v1/form/edit_category_form.dart';
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
  bool _alwaysAskConfirmation = true;
  final NotifController notifController = Get.put(NotifController());

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    bool alwaysAskConfirmation = await AppPreferences.getAlwaysAsk();

    setState(() {
      _alwaysAskConfirmation = alwaysAskConfirmation;
    });
  }

  // refresh dan load data
  Future<void> _loadData() async {
    List<Map<String, dynamic>> categories = await getCategories();

    setState(() {
      _categories = categories;
    });
  }

  // delete category
  Future<void> _deleteCategory(int categoryId) async {
    await deleteCategory(categoryId);
    _loadData();
  }

  // hold to show bottom sheet bar
  Future<void> _showBottomSheet(
      BuildContext context, int index, Category category) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.create_outlined,
                  color: Color.fromRGBO(5, 105, 220, 1),
                ),
                title: const Text(
                  'Edit Category',
                  style: TextStyle(
                    fontFamily: 'sharp',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) => AlertDialog(
                            backgroundColor:
                                const Color.fromRGBO(249, 249, 251, 1),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 15),
                            shape: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8.0),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(30, 31, 36, 1),
                                width: 1.5,
                              ),
                            ),
                            content: editCategoryForm(
                              category: category,
                              onUpdate: () {
                                _loadData();
                                notifController.showNotif(
                                  'Success',
                                  'Category edited successfully',
                                  CupertinoIcons.checkmark_alt,
                                  Color.fromARGB(255, 98, 212, 101),
                                );
                              },
                            ),
                            insetPadding: const EdgeInsets.all(10),
                          )).then((value) => Navigator.pop(
                      context)); //agar showModalBottomSheet bisa hilang sendiri;
                },
              ),
              ListTile(
                leading: const Icon(
                  CupertinoIcons.delete,
                  color: Color.fromARGB(255, 229, 72, 77),
                ),
                title: const Text(
                  'Delete Category',
                  style: TextStyle(
                    fontFamily: 'sharp',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  if (_alwaysAskConfirmation) {
                    showDialog(
                      context: context,
                      builder: (context) => DeleteConfirmationDialog(
                        title: 'Warning!',
                        message:
                            'Are you sure you want to delete this Category? This action cannot be undone',
                        onDeleteConfirmed: () {
                          _deleteCategory(index);
                          _loadData();
                          notifController.showNotif(
                            'Success',
                            'Category deleted successfully, Please refresh',
                            CupertinoIcons.delete,
                            Color.fromARGB(255, 98, 212, 101),
                          );
                        },
                        isThisLink: false,
                      ),
                    );
                  } else {
                    // langsung menghapus
                    _deleteCategory(index);
                    _loadPreferences();
                    _loadData();
                    Navigator.pop(context);
                    Get.snackbar(
                      'Success',
                      'Category deleted successfully',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      icon: const Icon(Icons.delete_rounded),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
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

          if (widget.categoryId != null || widget.categoryId != 0) {
            _activeCategory = widget.categoryId!;
          } // jika ada last category yang dipilih, maka diaktifkan

          final bool isActive = _activeCategory ==
              category.id; // logika jika aktif dan tidak aktif

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: GestureDetector(
              onLongPress: () {
                _showBottomSheet(context, category.id!, category);
              },
              onTap: () {
                setState(() {
                  _activeCategory = category.id!;
                  widget.onCategoryChanged(category.id);
                  AppPreferences.setLastCategory(category.id!);
                });
              },
              child: Chip(
                  label: Text(
                    category.nameCategory as String,
                    style: const TextStyle(
                      fontFamily: 'sharp',
                      fontSize: 16,
                    ),
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
                      side: const BorderSide(color: Colors.transparent))),
            ),
          );
        },
      ),
    );
  }
}
