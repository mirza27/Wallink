import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wallink_v1/controller/category_controller.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/controller/notif_controller.dart';
import 'package:wallink_v1/controller/sub_category_controller.dart';
import 'package:wallink_v1/database/app_preferences.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/route_page.dart';
import 'package:wallink_v1/tracker_service.dart';

class LinkForm extends StatefulWidget {
  final Link? link;
  final BuildContext context;
  const LinkForm({required this.link, required this.context, super.key});

  @override
  State<LinkForm> createState() => _LinkFormState();
}

class _LinkFormState extends State<LinkForm> {
  final NotifController notifController = Get.put(NotifController());
  // ADD LINK properties
  List<Map<String, dynamic>> _categories = [];
  String? _choosedCategoryId;
  List<Map<String, dynamic>> _subCategories = [];
  String? _choosedSubCategoryId;
  List<Link> _allLink = [];

  Future<void> _getLink() async {
    List<Map<String, dynamic>> linkData = await getAllLink();
    List<Link> links = linkData.map((data) => Link.fromMap(data)).toList();
    setState(() {
      _allLink = links;
    });

    //print(_allLink);
    // for (int i = 0; i < _allLink.length; i++) {
    //   print(_allLink[i].link);
    // }
  }

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
    _getLink();
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
          child: Padding(
            padding: const EdgeInsets.only(right: 15.0, left: 15.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0, bottom: 13.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "Add ",
                              style: TextStyle(
                                fontFamily: 'sharp',
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: "Link",
                              style: TextStyle(
                                fontFamily: 'sharp',
                                color: Color.fromRGBO(5, 105, 220, 1),
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),

                // ==============================dropdown category
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 18.0, bottom: 5.0),
                      child: Text(
                        'Category',
                        style: TextStyle(
                          fontFamily: 'sharp',
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: _choosedCategoryId,
                      onChanged: (value) {
                        print("categroy id terpilih : $value");
                        if (value == "add_new_category") {
                          setState(() {
                            _choosedCategoryId = "add_new_category";
                            isAddCategory = true;
                          });
                        } else {
                          setState(() {
                            _choosedCategoryId = value!;
                            isAddCategory = false;
                            isAddSubCategory = false;
                            _subCategories = [];
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
                          child: Text(
                            'Add New Category',
                            style: TextStyle(
                              fontFamily: 'sharp',
                              fontSize: 12,
                              color: Color.fromRGBO(30, 31, 36, 1),
                            ),
                          ),
                        ),
                        ..._categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category['id'].toString(),
                            child: Text(
                              category['category_name'],
                              style: const TextStyle(
                                  fontFamily: 'sharp',
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

                        return null;
                      },
                      decoration: InputDecoration(
                        fillColor: const Color.fromRGBO(224, 225, 230, 1),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 20),
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
                        hintText: 'Add New or Select Category',
                        hintStyle: const TextStyle(
                          fontFamily: 'sharp',
                          fontSize: 12.0,
                          color: Color.fromRGBO(139, 141, 152, 1),
                        ),
                      ),
                    ),
                  ],
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
                    style: const TextStyle(
                      fontFamily: 'sharp',
                      fontSize: 12.0,
                    ),
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
                      hintText: 'New Category',
                      hintStyle: const TextStyle(
                        fontFamily: 'sharp',
                        fontSize: 12.0,
                        color: Color.fromRGBO(139, 141, 152, 1),
                      ),
                      alignLabelWithHint: true,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  )
                ],

                // ==============================dropdown subcategory
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 18.0, bottom: 5.0),
                      child: Text(
                        'Sub Category',
                        style: TextStyle(
                          fontFamily: 'sharp',
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
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
                          child: Text(
                            'Add New Subcategory',
                            style: TextStyle(
                              fontFamily: 'sharp',
                              fontSize: 12,
                              color: Color.fromRGBO(30, 31, 36, 1),
                            ),
                          ),
                        ),
                        ..._subCategories.map((subcategory) {
                          return DropdownMenuItem<String>(
                            value: subcategory['id'].toString(),
                            child: Text(subcategory['sub_category_name'],
                                style: const TextStyle(
                                    fontFamily: 'sharp',
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
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 4, horizontal: 20),
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
                        hintText: 'Add New or Select Sub Category',
                        hintStyle: const TextStyle(
                          fontFamily: 'sharp',
                          fontSize: 12.0,
                          color: Color.fromRGBO(139, 141, 152, 1),
                        ),
                        alignLabelWithHint: true,
                      ),
                    ),
                  ],
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
                    style: const TextStyle(
                      fontFamily: 'sharp',
                      fontSize: 12.0,
                    ),
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
                      hintText: 'New Subcategory',
                      hintStyle: const TextStyle(
                        fontFamily: 'sharp',
                        fontSize: 12.0,
                        color: Color.fromRGBO(139, 141, 152, 1),
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
                  children: _linkInputs.asMap().entries.map(
                    (entry) {
                      final int index = entry.key;
                      // final Link linkInput = entry.value;
                      return Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Padding(
                                padding:
                                    EdgeInsets.only(left: 20.0, bottom: 5.0),
                                child: Text(
                                  'Link',
                                  style: TextStyle(
                                    fontFamily: 'sharp',
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              if (index != 0) ...[
                                // delete icon tidak belaku jika data link cuma 1
                                IconButton(
                                  icon: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.red,
                                        ),
                                        borderRadius: BorderRadius.circular(3)),
                                    child: const Icon(
                                      Icons.remove,
                                      size: 15,
                                      weight: 20,
                                      color: Colors.red,
                                    ),
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
                              } else if (value.trim().isEmpty) {
                                return "New Category cannot only space";
                              }

                              // Memeriksa apakah nama link sudah ada dalam _allLink
                              bool isNameUnique = _allLink
                                  .every((link) => link.nameLink != value);
                              if (!isNameUnique) {
                                return "Link name must be unique";
                              }
                              return null;
                            },
                            style: const TextStyle(
                              fontFamily: 'sharp',
                              fontSize: 12.0,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 20),
                              filled: true,
                              fillColor: const Color.fromRGBO(224, 225, 230, 1),
                              focusColor:
                                  const Color.fromRGBO(252, 252, 253, 1),
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
                                fontFamily: 'sharp',
                                fontSize: 12.0,
                                color: Color.fromRGBO(139, 141, 152, 1),
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

                              bool isUrlUnique =
                                  _allLink.every((link) => link.link != value);
                              if (!isUrlUnique) {
                                return "You already have this url link";
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
                            style: const TextStyle(
                              fontFamily: 'sharp',
                              fontSize: 12.0,
                            ),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 20,
                              ),
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
                                fontFamily: 'sharp',
                                fontSize: 12.0,
                                color: Color.fromRGBO(139, 141, 152, 1),
                              ),
                              alignLabelWithHint: true,
                            ),
                          ),

                          // tombol add link
                          if (index == _linkInputs.length - 1)
                            Padding(
                              padding: const EdgeInsets.only(left: 14.0),
                              child: IconButton(
                                icon: Row(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          width: 1,
                                          color: Colors.blue,
                                        ),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: const Icon(
                                        Icons.add,
                                        size: 15,
                                        weight: 20,
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8.0,
                                    ),
                                    const Text(
                                      'Add More Link',
                                      style: TextStyle(
                                        fontFamily: 'sharp',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {
                                  setState(
                                    () {
                                      // memasukkan array link
                                      _linkInputs.add(
                                        Link(nameLink: '', link: ''),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      );
                    },
                  ).toList(),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            fontFamily: 'sharp',
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.black),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    FilledButton(
                      style:
                          FilledButton.styleFrom(backgroundColor: Colors.blue),
                      onPressed: () async {
                        int finalCategoryId = 0;
                        int finalSubcategoryId = 0;
                        if (_formKey.currentState!.validate()) {
                          // submit add link
                          // if (isAddCategory && isAddSubCategory) {
                          //   int categoryId = await insertCategory(
                          //       _newCategoryController.text.trim());
                          //   int subCategoryId = await insertSubCategory(
                          //       _newSubCategoryController.text.trim(),
                          //       categoryId);
                          //   finalCategoryId = categoryId;
                          //   finalSubcategoryId = subCategoryId;
                          // } else if (isAddSubCategory) {
                          //   int subCategoryId = await insertSubCategory(
                          //       _newSubCategoryController.text.trim(),
                          //       int.parse(_choosedCategoryId!));
                          //   finalCategoryId = int.parse(_choosedCategoryId!);
                          //   finalSubcategoryId = subCategoryId;
                          // } else {
                          //   finalSubcategoryId =
                          //       int.parse(_choosedSubCategoryId!);
                          //   finalCategoryId = int.parse(_choosedSubCategoryId!);
                          // }

                          // snackbar muncul saat menambahkan category baru saja
                          if (isAddCategory && isAddSubCategory) {
                            int categoryId = await insertCategory(
                                _newCategoryController.text.trim());
                            int subCategoryId = await insertSubCategory(
                                _newSubCategoryController.text.trim(),
                                categoryId);
                            finalCategoryId = categoryId;
                            finalSubcategoryId = subCategoryId;

                            notifController.showNotif(
                              'Success',
                              'New category added successfully!',
                              CupertinoIcons.checkmark_alt,
                              Color.fromARGB(255, 98, 212, 101),
                            );
                          } else if (isAddSubCategory) {
                            // Inserting a new subcategory
                            int subCategoryId = await insertSubCategory(
                                _newSubCategoryController.text.trim(),
                                int.parse(_choosedCategoryId!));
                            finalCategoryId = int.parse(_choosedCategoryId!);
                            finalSubcategoryId = subCategoryId;

                            notifController.showNotif(
                              'Success',
                              'New subcategory added successfully!',
                              CupertinoIcons.checkmark_alt,
                              Color.fromARGB(255, 98, 212, 101),
                            );
                          } else {
                            finalSubcategoryId =
                                int.parse(_choosedSubCategoryId!);
                            finalCategoryId = int.parse(_choosedSubCategoryId!);
                          }

                          for (var linkInput in _linkInputs) {
                            insertLink(linkInput.link!.trim(),
                                linkInput.nameLink!.trim(), finalSubcategoryId);
                            await (TrackerService()).track(
                              "create-link",
                              {},
                              content: {
                                "categoryId": finalCategoryId.toString(),
                                "subCategoryId": finalSubcategoryId.toString(),
                                "link": linkInput.link!.trim(),
                              },
                            );
                          }

                          // nnotif create new link
                          if (_linkInputs.length > 0) {
                            notifController.showNotif(
                              'Success',
                              'Mutiple link added successfully!',
                              CupertinoIcons.checkmark_alt,
                              Color.fromARGB(255, 98, 212, 101),
                            );
                          } else {
                            notifController.showNotif(
                              'Success',
                              'A Link added successfully!',
                              CupertinoIcons.checkmark_alt,
                              Color.fromARGB(255, 98, 212, 101),
                            );
                          }

                          // set lastCategory
                          print("final category id: $finalCategoryId");
                          AppPreferences.setLastCategory(finalCategoryId);

                          // back to home page
                          // Navigator.pop(context);
                          // Navigator.popAndPushNamed(context, MaterialPageRoute(builder: (context) => RoutePage()));
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RoutePage(
                                selectedIndex: 0,
                              ),
                            ),
                            (Route<dynamic> route) =>
                                false, // Remove all previous routes
                          );
                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const RoutePage(
                          //       selectedIndex: 0,
                          //     ),
                          //   ),
                          // );
                        }
                      },
                      child: const Text(
                        'Submit',
                        style: TextStyle(
                            fontFamily: 'sharp',
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
