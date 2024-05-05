import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/category_controller.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/controller/sub_category_controller.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/database/app_preferences.dart';
import 'package:wallink_v1/route_page.dart';

class LinkForm extends StatefulWidget {
  final Link? link;
  final BuildContext context;
  const LinkForm({required this.link, required this.context ,super.key});

  @override
  State<LinkForm> createState() => _LinkFormState();
}

class _LinkFormState extends State<LinkForm> {
  // ADD LINK properties
  List<Map<String, dynamic>> _categories = [];
  String? _choosedCategoryId;
  List<Map<String, dynamic>> _subCategories = [];
  String? _choosedSubCategoryId;

  final List<Link> _linkInputs = [
    Link(nameLink: '', link: '')
  ]; // array input banyak link

  bool isAddCategory = false;
  bool isAddSubCategory = false;

  final TextEditingController _newCategoryController = TextEditingController();
  final TextEditingController _newSubCategoryController =
      TextEditingController();

  final _formKey = GlobalKey<FormState>();

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

    if (_choosedCategoryId != null &&
        _choosedCategoryId != '' &&
        _choosedCategoryId != 'add_new_category') {
      List<Map<String, dynamic>> subCategories =
          await getSubCategoryByCategoryId(int.parse(_choosedCategoryId!));
      setState(() {
        _subCategories = subCategories;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            // mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Add ",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        TextSpan(
                          text: "Link",
                          style: TextStyle(
                              color: Color.fromRGBO(5, 105, 220, 1),
                              fontSize: 15),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),

              // ==============================dropdown category
              DropdownButtonFormField<String>(
                value: _choosedCategoryId,
                onChanged: (value) {
                  if (value == "add_new_category") {
                    setState(() {
                      _choosedCategoryId = null;
                      isAddCategory = true;
                    });
                  } else {
                    setState(() {
                      _choosedCategoryId = value!;
                      isAddCategory = false;
                      isAddSubCategory= false;
                    });
                  }

                  setState(() {
                    // set null ketika sudah pilih category dan sub namun merubah category lagi
                    _choosedSubCategoryId = null;
                    _loadData();
                  });
                },
                items: [
                  const DropdownMenuItem<String>(
                    value: 'add_new_category',
                    child: Text('Add New Category',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(30, 31, 36, 1))),
                  ),
                  ..._categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category['id'].toString(),
                      child: Text(
                        category['category_name'],
                        style: const TextStyle(
                            fontSize: 12, color: Color.fromRGBO(30, 31, 36, 1)),
                      ),
                    );
                  }).toList(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Category cannot  be empty";
                  }

                  return null;
                },
                decoration: InputDecoration(
                  fillColor: const Color.fromRGBO(224, 225, 230, 1),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(224, 225, 230, 1),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(224, 225, 230, 1),
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(224, 225, 230, 1),
                      width: 1.0,
                    ),
                  ),
                  hintText: 'Category',
                  hintStyle: const TextStyle(
                    fontSize: 12.0,
                    color: Color.fromRGBO(
                        139, 141, 152, 1), // Ganti dengan warna yang diinginkan
                  ),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              // ==================================jika add new category
              if (isAddCategory) ...[
                TextFormField(
                  controller: _newCategoryController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "New Category cannot be empty";
                    } else if (value.trim() == '') {
                      return "New Category cannot only space";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                    filled: true,
                    fillColor: const Color.fromRGBO(224, 225, 230, 1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(224, 225, 230, 1),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(224, 225, 230, 1),
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(224, 225, 230, 1),
                        width: 1.0,
                      ),
                    ),
                    hintText: 'New Category',
                    hintStyle: const TextStyle(
                      fontSize: 12.0,
                      color: Color.fromRGBO(139, 141, 152,
                          1), // Ganti dengan warna yang diinginkan
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(
                  height: 10,
                )
              ],

              // ==============================dropdown subcategory
              DropdownButtonFormField<String>(
                enableFeedback: true,
                value: _choosedSubCategoryId,
                onChanged: (value) {
                  if (value == 'add_new_subcategory') {
                    setState(() {
                      isAddSubCategory = true;
                    });
                  } else {
                    setState(() {
                      isAddSubCategory = false;
                    });
                  }

                  setState(() {
                    _choosedSubCategoryId = value!;
                  });
                },
                items: [
                  const DropdownMenuItem<String>(
                    
                    value: 'add_new_subcategory',
                    child: Text('Add New Subcategory',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color.fromRGBO(30, 31, 36, 1))),
                  ),
                  ..._subCategories.map((subcategory) {
                    return DropdownMenuItem<String>(
                      value: subcategory['id'].toString(),
                      child: Text(subcategory['sub_category_name'],
                          style: const TextStyle(
                              fontSize: 12,
                              color: Color.fromRGBO(30, 31, 36, 1))),
                    );
                  }).toList(),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Sub Category cannot  be empty";
                  }
                  return null;
                },
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                  fillColor: const Color.fromRGBO(224, 225, 230, 1),
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(224, 225, 230, 1),
                      width: 1.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(224, 225, 230, 1),
                      width: 1.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24.0),
                    borderSide: const BorderSide(
                      color: Color.fromRGBO(224, 225, 230, 1),
                      width: 1.0,
                    ),
                  ),
                  hintText: 'Sub Category',
                  hintStyle: const TextStyle(
                    fontSize: 12.0,
                    color: Color.fromRGBO(
                        139, 141, 152, 1), // Ganti dengan warna yang diinginkan
                  ),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(
                height: 10,
              ),

              // ==============================jika add new subcategory
              if (isAddSubCategory) ...[
                TextFormField(
                  controller: _newSubCategoryController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "New Subcategory cannot be empty";
                    } else if (value.trim() == '') {
                      return "New Category cannot only space";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                    filled: true,
                    fillColor: const Color.fromRGBO(224, 225, 230, 1),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(224, 225, 230, 1),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(224, 225, 230, 1),
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(224, 225, 230, 1),
                        width: 1.0,
                      ),
                    ),
                    hintText: 'New Subcategory',
                    hintStyle: const TextStyle(
                      fontSize: 12.0,
                      color: Color.fromRGBO(139, 141, 152,
                          1), // Ganti dengan warna yang diinginkan
                    ),
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],

              const SizedBox(height: 10),
              // ============================== Iterasi array Link
              Column(
                children: _linkInputs.asMap().entries.map((entry) {
                  final int index = entry.key;
                  // final Link linkInput = entry.value;
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 0, horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Link"),
                            if (index != 0) ...[
                              // delete icon tidak belaku jika data link cuma 1
                              IconButton(
                                padding: const EdgeInsets.all(0),
                                icon: const Icon(
                                  Icons.delete,
                                  size: 13,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _linkInputs.removeAt(index);
                                  });
                                },
                              )
                            ],
                          ],
                        ),
                      ),
                      // nama link
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            _linkInputs[index].nameLink = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Link name cannot be empty";
                          } else if (value.trim() == '') {
                            return "New Category cannot only space";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 20),
                          filled: true,
                          fillColor: const Color.fromRGBO(224, 225, 230, 1),
                          focusColor: const Color.fromRGBO(252, 252, 253, 1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(224, 225, 230, 1),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(224, 225, 230, 1),
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(224, 225, 230, 1),
                              width: 1.0,
                            ),
                          ),
                          hintText: 'Link Title',
                          hintStyle: const TextStyle(
                            fontSize: 12.0,
                            color: Color.fromRGBO(139, 141, 152,
                                1), // Ganti dengan warna yang diinginkan
                          ),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      // link
                      TextFormField(
                        onChanged: (value) {
                          setState(() {
                            _linkInputs[index].link = value;
                          });
                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Link cannot be empty";
                          } else if (value.trim() == '') {
                            return "Link cannot only contain spaces";
                          }

                          if (!RegExp(r'^https?://').hasMatch(value)) {
                            value = 'https://$value';
                          }

                          if (!RegExp(
                                  r'^((http|https):\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,5}(:[0-9]{1,5})?(\/.*)?$')
                              .hasMatch(value)) {
                            return 'Please enter a valid URL';
                          }

                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 4, horizontal: 20),
                          filled: true,
                          fillColor: const Color.fromRGBO(224, 225, 230, 1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(224, 225, 230, 1),
                              width: 1.0,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(224, 225, 230, 1),
                              width: 1.0,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24.0),
                            borderSide: const BorderSide(
                              color: Color.fromRGBO(224, 225, 230, 1),
                              width: 1.0,
                            ),
                          ),
                          hintText: 'Link',
                          hintStyle: const TextStyle(
                            fontSize: 12.0,
                            color: Color.fromRGBO(139, 141, 152,
                                1), // Ganti dengan warna yang diinginkan
                          ),
                          alignLabelWithHint: true,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (index == _linkInputs.length - 1)
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  // memasukkan array link
                                  _linkInputs.add(Link(nameLink: '', link: ''));
                                });
                              },
                            ),
                        ],
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                }).toList(),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () async {
                      int finalCategoryId = 0;
                      int finalSubcategoryId = 0;
                      if (_formKey.currentState!.validate()) {
                        // submit add link
                        if (isAddCategory && isAddSubCategory) {
                          int categoryId = await insertCategory(
                              _newCategoryController.text.trim());
                          int subCategoryId = await insertSubCategory(
                              _newSubCategoryController.text.trim(),
                              categoryId);
                          finalCategoryId = categoryId;
                          finalSubcategoryId = subCategoryId;

                        } else if (isAddSubCategory) {
                          int subCategoryId = await insertSubCategory(
                              _newSubCategoryController.text.trim(),
                              int.parse(_choosedCategoryId!));
                          finalCategoryId = int.parse(_choosedCategoryId!);
                          finalSubcategoryId = subCategoryId;


                        } else {
                          finalSubcategoryId =
                              int.parse(_choosedSubCategoryId!);
                          finalCategoryId = int.parse(_choosedSubCategoryId!);
                        }

                        for (var linkInput in _linkInputs) {
                          insertLink(linkInput.link!.trim(),
                              linkInput.nameLink!.trim(), finalSubcategoryId);
                        }
                        
                        // set lastCategory
                        AppPreferences.setLastCategory(finalCategoryId);

                        // back to home page
                        // Navigator.pop(context);
                        // Navigator.popAndPushNamed(context, MaterialPageRoute(builder: (context) => RoutePage()));
                        Navigator.pushReplacement(
                          context,
                            MaterialPageRoute(
                                builder: (context) => const RoutePage()));
                      }
                    },
                    child: const Text('Submit'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
