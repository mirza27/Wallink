import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/models/link.dart';

class EditLinkForm extends StatefulWidget {
  final Function onUpdate;
  final Link link;
  const EditLinkForm({
    super.key,
    required this.link,
    required this.onUpdate,
  });

  @override
  State<EditLinkForm> createState() => _EditLinkFormState();
}

class _EditLinkFormState extends State<EditLinkForm> {
  final TextEditingController _linkNameController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Link> _allLink = [];

  @override
  void initState() {
    super.initState();
    _getLink();

    _linkController.text = widget.link.link ?? '';
    _linkNameController.text = widget.link.nameLink ?? '';
  }

  Future<void> _getLink() async {
    List<Map<String, dynamic>> linkData = await getAllLink();
    List<Link> links = linkData.map((data) => Link.fromMap(data)).toList();
    setState(() {
      _allLink = links;
    });
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
              // JUDUL================================
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
                  bool isNameUnique =
                      _allLink.every((link) => link.nameLink != value);
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
                  color: Color.fromARGB(255, 94, 94, 94),
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
                  hintText: 'Link',
                  hintStyle: const TextStyle(
                    fontSize: 12.0,
                    color: Color.fromRGBO(
                        139, 141, 152, 1), // Ganti dengan warna yang diinginkan
                  ),
                  alignLabelWithHint: true,
                ),
              ),
              const Expanded(
                child: SizedBox(),
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
                    style: FilledButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        editLink(widget.link.id!, _linkNameController.text,
                            _linkController.text);
                        widget.onUpdate.call(); // refresh data
                        Navigator.of(context).pop(); // tutup pop up
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
      ),
    );
  }
}
