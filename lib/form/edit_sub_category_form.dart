import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/sub_category_controller.dart';
import 'package:wallink_v1/models/sub_category.dart';

class editSubCategoryForm extends StatefulWidget {
  final Function onUpdate;
  final SubCategory subCategory;

  const editSubCategoryForm(
      {super.key, required this.onUpdate, required this.subCategory});

  @override
  State<editSubCategoryForm> createState() => _editSubCategoryFormState();
}

class _editSubCategoryFormState extends State<editSubCategoryForm> {
  final TextEditingController _subCategoryController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _subCategoryController.text = widget.subCategory.subCategoryName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.2,
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
                              text: "Sub Category",
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
                  controller: _subCategoryController,
                  onChanged: (value) {
                    setState(() {
                      _subCategoryController.text = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "New SubCategory name cannot be empty";
                    } else if (value.trim() == '') {
                      return "New SubCategory cannot only space";
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
                    hintText: 'SubCategory Name',
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
                const Expanded(child: SizedBox()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.max,
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
                        if (_formKey.currentState!.validate()) {
                          editSubCategory(widget.subCategory.id!,
                              _subCategoryController.text);
                          widget.onUpdate.call(); // update data subcategory
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
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
