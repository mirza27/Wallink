import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/sub_category_controller.dart';
import 'package:wallink_v1/models/category.dart';

class editSubCategoryForm extends StatefulWidget {
  final Function onUpdate;
  final Category category;
  const editSubCategoryForm(
      {super.key, required this.onUpdate, required this.category});

  @override
  State<editSubCategoryForm> createState() => _editSubCategoryFormState();
}

class _editSubCategoryFormState extends State<editSubCategoryForm> {
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
                          text: "Category",
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
                  editSubCategory(widget.category.id!, _categoryController.text);
                },
                child: const Text('Submit'),
              )
            ])
            ],
          ),
        ));
  }
}
