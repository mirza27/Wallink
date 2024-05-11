import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:share/share.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/controller/sub_category_controller.dart';
import 'package:wallink_v1/database/app_preferences.dart';
import 'package:wallink_v1/dialog/delete_confirmation.dart';
import 'package:wallink_v1/form/edit_sub_category_form.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/models/sub_category.dart';
import 'package:wallink_v1/widgets/link_card.dart';

class SubCategoryCard extends StatefulWidget {
  final SubCategory subCategory;
  final Function(int) onDelete; // memanggil fungsi delete di subcategory page
  final Function onUpdate; // memanggil fungsi load di home_page.dart
  final bool isExpanded;

  const SubCategoryCard({
    Key? key,
    required this.subCategory,
    required this.onDelete,
    required this.onUpdate,
    required this.isExpanded,
  }) : super(key: key);

  @override
  State<SubCategoryCard> createState() => _SubCategoryCardState();
}

class _SubCategoryCardState extends State<SubCategoryCard> {
  List<Map<String, dynamic>> _links = [];
  bool _alwaysAskConfirmation = true;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadPreferences();
    print("always expanded: ${widget.isExpanded}");
  }

  Future<void> _loadPreferences() async {
    bool alwaysAskConfirmation = await AppPreferences.getAlwaysAsk();

    setState(() {
      _alwaysAskConfirmation = alwaysAskConfirmation;
    });
  }

  // refresh dan load data
  Future<void> _loadData() async {
    // mengambil link berdasarkan subcategory id
    List<Map<String, dynamic>> links = await getLink(widget.subCategory.id);
    setState(() {
      _links = links;
    });
  }

  // load per subcategory ketika subcategory berubah
  @override
  void didUpdateWidget(covariant SubCategoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.subCategory.id != oldWidget.subCategory.id ||
        widget.isExpanded != oldWidget.isExpanded) {
      if (widget.subCategory.id != null && widget.subCategory.id != 0) {
        _loadData();
      }
    }
  }

  // fungsi add new link
  Future<void> _addLink(String linkName, String link) async {
    await showDialog<String>(
      context: context,
      builder: (context) {
        TextEditingController linkNameController = TextEditingController();
        TextEditingController linkController = TextEditingController();

        // keyboard aktif langsung
        FocusNode focusNode = FocusNode();
        WidgetsBinding.instance!
            .addPostFrameCallback((_) => focusNode.requestFocus());

        return AlertDialog(
          title: const Text('Add Link'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: linkNameController,
                decoration: const InputDecoration(
                  hintText: 'Enter New Link Name',
                ),
              ),
              TextField(
                controller: linkController,
                decoration: const InputDecoration(
                  hintText: 'Enter New Link',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String newLinkName = linkNameController.text.trim();
                String newLink = linkController.text.trim();
                // bool checkLink = await checkLinkUrl(newLink, newLinkName);

                if (newLinkName.isNotEmpty && newLink.isNotEmpty) {
                  await insertLink(
                      newLink, newLinkName, widget.subCategory.id!);
                  Navigator.pop(context);
                  await _loadData();
                } else {
                  // jika input kosong
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Please fill all fields'),
                    duration: Duration(seconds: 2),
                  ));
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showBottomSheet(BuildContext context, int index) async {
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
                  Icons.edit,
                  color: Color.fromRGBO(5, 105, 220, 1),
                ),
                title: const Text(
                  'Edit Sub Category',
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
                      backgroundColor: const Color.fromRGBO(249, 249, 251, 1),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: Color.fromRGBO(30, 31, 36, 1),
                          width: 1.5,
                        ),
                      ),
                      content: editSubCategoryForm(
                        subCategory: widget.subCategory,
                        onUpdate: () {
                          _loadData();
                          Get.snackbar(
                            'Success',
                            'Subcategory edited successfully',
                            backgroundColor: Color.fromARGB(255, 220, 211, 5),
                            colorText: Colors.white,
                            icon: const Icon(Icons.security_update_good),
                          );
                          widget.onUpdate();
                        },
                      ),
                      insetPadding: const EdgeInsets.all(10),
                    ),
                  ).then((value) => Navigator.pop(
                      context)); //agar showModalBottomSheet bisa hilang sendiri
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.share,
                  color: Color.fromRGBO(5, 105, 220, 1),
                ),
                title: const Text(
                  'Share Sub Category',
                  style: TextStyle(
                    fontFamily: 'sharp',
                    fontSize: 16.0,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                onTap: () {
                  _shareSubCategory(widget.subCategory);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.delete,
                  color: Color.fromARGB(255, 229, 72, 77),
                ),
                title: const Text(
                  'Delete Sub Category',
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
                            'Are you sure you want to delete this SubCategory? This action cannot be undone',
                        onDeleteConfirmed: () {
                          deleteSubCategory(index);
                          widget.onUpdate();
                          Get.snackbar(
                            'Success',
                            'SubCategory deleted successfully, Please refresh',
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            icon: const Icon(Icons.delete_outlined),
                          );
                        },
                        isThisLink: false,
                      ),
                    );
                  } else {
                    // langsung menghapus
                    deleteSubCategory(index);
                    widget.onUpdate();
                    Navigator.pop(context);
                    Get.snackbar(
                      'Success',
                      'SubCategory deleted successfully, Please refresh',
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                      icon: const Icon(Icons.delete),
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

  void _shareSubCategory(SubCategory subCategory) async {
    List<Link> links = _links.map((linkMap) => Link.fromMap(linkMap)).toList();

    String shareText =
        'Saya membagikan kumpulan link untuk Anda menggunakan Wallink\n\n'
        'Sub Category: ${subCategory.subCategoryName}';
    shareText += '\nLinks:\n';
    for (Link link in links) {
      shareText += '${link.linkName}: ${link.link}\n';
    }

    await Clipboard.setData(ClipboardData(text: shareText));
    Share.share(
      '$shareText',
      subject: 'Sub Category Info',
    );
  }

  // MAIN WIDGET ==================================================
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onLongPress: () {
        _showBottomSheet(context, widget.subCategory.id!);
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 3.0, 16.0, 10.0),
        child: Card(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(255, 209, 208, 208),
                  offset: Offset(2, 4),
                  blurRadius: 5,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: ExpansionTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                initiallyExpanded: widget.isExpanded,
                title: Text(
                  widget.subCategory.subCategoryName as String,
                  style: const TextStyle(
                    fontFamily: 'sharp',
                    fontWeight: FontWeight.w800,
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                // iterasi setiap link dengan link card
                children: [
                  ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    // iterasi widget sub category card
                    itemCount: _links.length,
                    itemBuilder: (context, index) {
                      final Link link = Link.fromMap(_links[index]);

                      return LinkCard(link: link, onChanged: _loadData);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
