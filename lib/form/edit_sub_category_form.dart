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
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Edit ",
                          style: TextStyle(color: Colors.black, fontSize: 15),
                        ),
                        TextSpan(
                          text: "Sub Category",
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
                  color: Color.fromRGBO(
                      139, 141, 152, 1), // Ganti dengan warna yang diinginkan
                ),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(
              height: 10,
            ),

             Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onUpdate.call();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  editSubCategory(widget.subCategory.id!, _subCategoryController.text);
                },
                child: const Text('Submit'),
              )
            ])
            ],
          ),
        ));
  }
}
