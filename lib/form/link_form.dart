import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/category_controller.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/controller/sub_category_controller.dart';
import 'package:wallink_v1/models/category.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/route_page.dart';

class LinkForm extends StatefulWidget {
  final Link? link;
  const LinkForm({required this.link, super.key});

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

  // EDIT link properties
  final TextEditingController _linkController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadData();
    if (widget.link != null) {
      _linkController.text = widget.link!.link ?? '';
    }
  }

  // refresh dan load data
  Future<void> _loadData() async {
    List<Map<String, dynamic>> categories = await getCategories();

    setState(() {
      _categories = categories;
      print(_categories);
    });

    if (_choosedCategoryId != null &&
        _choosedCategoryId != '' &&
        _choosedCategoryId != 'add_new_category') {
      List<Map<String, dynamic>> subCategories =
          await getSubCategoryByCategoryId(int.parse(_choosedCategoryId!));
      setState(() {
        _subCategories = subCategories;
        print(_subCategories);
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
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Add New "),
                  Text(
                    "Link",
                    style: TextStyle(color: Color.fromRGBO(5, 105, 220, 1)),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              if (_categories.isNotEmpty && widget.link == null) ...[
                // ==============================JIKA ADD LINK
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
                              fontSize: 12,
                              color: Color.fromRGBO(30, 31, 36, 1)),
                        ),
                      );
                    }).toList(),
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Category cannot  be empty";
                    }

                    print(value);
                    return null;
                  },
                  decoration: InputDecoration(
                    fillColor: const Color.fromRGBO(224, 225, 230, 1),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(224, 225, 230, 1),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(224, 225, 230, 1),
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(224, 225, 230, 1),
                        width: 1.0,
                      ),
                    ),
                    hintText: 'Category',
                    hintStyle: const TextStyle(
                      fontSize: 12.0,
                      color: Color.fromRGBO(139, 141, 152,
                          1), // Ganti dengan warna yang diinginkan
                    ),
                    alignLabelWithHint: true,
                  ),
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 20),
                      filled: true,
                      fillColor: const Color.fromRGBO(224, 225, 230, 1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(224, 225, 230, 1),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(224, 225, 230, 1),
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
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
                  )
                ],

                // ==============================dropdown subcategory
                DropdownButtonFormField<String>(
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
                      print("is add new sub category ${_choosedSubCategoryId}");
                      print("is add new sub category ${isAddSubCategory}");
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
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(224, 225, 230, 1),
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(224, 225, 230, 1),
                        width: 1.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(224, 225, 230, 1),
                        width: 1.0,
                      ),
                    ),
                    hintText: 'Sub Category',
                    hintStyle: const TextStyle(
                      fontSize: 12.0,
                      color: Color.fromRGBO(139, 141, 152,
                          1), // Ganti dengan warna yang diinginkan
                    ),
                    alignLabelWithHint: true,
                  ),
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 20),
                      filled: true,
                      fillColor: const Color.fromRGBO(224, 225, 230, 1),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(224, 225, 230, 1),
                          width: 1.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(224, 225, 230, 1),
                          width: 1.0,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
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
                  )
                ],

                const SizedBox(height: 10),
                // ==============================Iterasi array Link
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
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(224, 225, 230, 1),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(224, 225, 230, 1),
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
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
                        // link
                        TextFormField(
                          onChanged: (value) {
                            setState(() {
                              _linkInputs[index].link = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "link cannot be empty";
                            } else if (value.trim() == '') {
                              return "Link cannot only space";
                            }
                            if (!value.startsWith('http://') &&
                                !value.startsWith('https://')) {
                              value = 'https://$value';
                            }

                            if (!Uri.parse(value).isAbsolute) {
                              return 'Please enter a valid URL';
                            }

                            if (!Uri.parse(value).host.contains('.')) {
                              return 'URL must contain a domain';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 4, horizontal: 20),
                            filled: true,
                            fillColor: const Color.fromRGBO(224, 225, 230, 1),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(224, 225, 230, 1),
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
                              borderSide: const BorderSide(
                                color: Color.fromRGBO(224, 225, 230, 1),
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0),
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
                                    _linkInputs
                                        .add(Link(nameLink: '', link: ''));
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
              ] else // =========================jika edit link
                ...[],
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
                      int finalSubcategoryId = 0;
                      if (_formKey.currentState!.validate()) {
                        if (isAddCategory && isAddSubCategory) {
                          int categoryId = await insertCategory(
                              _newCategoryController.text.trim());
                          int subCategoryId = await insertSubCategory(
                              _newSubCategoryController.text.trim(),
                              categoryId);

                          finalSubcategoryId = subCategoryId;
                        } else if (isAddSubCategory) {
                          int subCategoryId = await insertSubCategory(
                              _newSubCategoryController.text.trim(),
                              int.parse(_choosedCategoryId!));
                          finalSubcategoryId = subCategoryId;
                        } else {
                          finalSubcategoryId =
                              int.parse(_choosedSubCategoryId!);
                        }

                        for (var linkInput in _linkInputs) {
                          insertLink(linkInput.link!.trim(),
                              linkInput.nameLink!.trim(), finalSubcategoryId);
                        }

                        Navigator.pop(context);
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
