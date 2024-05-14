import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/category_controller.dart';
import 'package:wallink_v1/models/category.dart';

class editCategoryForm extends StatefulWidget {
  final Function onUpdate;
  final Category category;
  const editCategoryForm({
    super.key,
    required this.onUpdate,
    required this.category,
  });

  @override
  State<editCategoryForm> createState() => _editSubCategoryFormState();
}

class _editSubCategoryFormState extends State<editCategoryForm> {
  final TextEditingController _categoryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _categoryController.text = widget.category.nameCategory ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.27,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0, left: 12.0),
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
                              text: "Edit ",
                              style: TextStyle(
                                fontFamily: 'sharp',
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            TextSpan(
                              text: "Category",
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

                // NAMA SUB================================
                TextFormField(
                  controller: _categoryController,
                  onChanged: (value) {
                    setState(() {
                      _categoryController.text = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "New Category name cannot be empty";
                    } else if (value.trim() == '') {
                      return "New Category cannot only space";
                    }
                    return null;
                  },
                  style: const TextStyle(
                    fontFamily: 'sharp',
                    fontSize: 15.0,
                  ),
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
                    hintText: 'Category Name',
                    hintStyle: const TextStyle(
                      fontFamily: 'sharp',
                      fontSize: 12.0,
                      color: Color.fromRGBO(139, 141, 152,
                          1), // Ganti dengan warna yang diinginkan
                    ),
                    alignLabelWithHint: true,
                  ),
                ),

                const Expanded(child: SizedBox()),
                Row(mainAxisAlignment: MainAxisAlignment.end, children: [
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
                    style: FilledButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        editCategory(
                            widget.category.id!, _categoryController.text);
                        widget.onUpdate.call();
                        Navigator.pop(context);
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
                  )
                ])
              ],
            ),
          ),
        ));
  }
}
