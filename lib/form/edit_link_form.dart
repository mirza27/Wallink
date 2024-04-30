import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/models/link.dart';

class EditLinkForm extends StatefulWidget {
  final Function onUpdate;
  final Link link;
  const EditLinkForm({super.key, required this.link, required this.onUpdate,});

  @override
  State<EditLinkForm> createState() => _EditLinkFormState();
}

class _EditLinkFormState extends State<EditLinkForm> {
  final TextEditingController _linkNameController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _linkController.text = widget.link.link ?? '';
    _linkNameController.text = widget.link.nameLink ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * 0.3,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // JUDUL================================
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

            // NAMA LINK================================
            TextFormField(
              controller: _linkNameController,
              onChanged: (value) {
                setState(() {
                  _linkNameController.text = value;
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
                hintText: 'Link Title',
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

            // Link================================
            TextFormField(
              controller: _linkController,
              onChanged: (value) {
                setState(() {
                  _linkController.text = value;
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
                hintText: 'Link',
                hintStyle: const TextStyle(
                  fontSize: 12.0,
                  color: Color.fromRGBO(
                      139, 141, 152, 1), // Ganti dengan warna yang diinginkan
                ),
                alignLabelWithHint: true,
              ),
            ),
            const Expanded(child: SizedBox()),
            Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              TextButton(
                onPressed: () {
                  widget.onUpdate.call();
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  editLink(widget.link.id!, _linkNameController.text,
                      _linkController.text);
                },
                child: const Text('Submit'),
              )
            ])
          ],
        ),
      ),
    );
  }
}
