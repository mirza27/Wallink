import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/models/sub_category.dart';
import 'package:wallink_v1/widgets/link_card.dart';

class SubCategoryCard extends StatefulWidget {
  final SubCategory subCategory;
  final Function(int) onDelete; // memanggil fungsi delete di subcategory page
  final Function(SubCategory)
      onUpdate; // memanggil fungsi edit di subcategory page

  const SubCategoryCard({
    super.key,
    required this.subCategory,
    required this.onDelete,
    required this.onUpdate,
  });

  @override
  State<SubCategoryCard> createState() => _SubCategoryCardState();
}

class _SubCategoryCardState extends State<SubCategoryCard> {
  List<Map<String, dynamic>> _links = [];
  bool _isExpanded = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // refresh dan load data
  Future<void> _loadData() async {
    // mengambil link berdasarkan subcategory id
    List<Map<String, dynamic>> links = await getLink(widget.subCategory.id);
    setState(() {
      _links = links;
    });
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
        WidgetsBinding.instance
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

                if (newLinkName.isNotEmpty && newLink.isNotEmpty) {
                  // jika input tidak kosong
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

  // delete link
  Future<void> _deleteLink(int linkId) async {
    await deleteLink(linkId);
    await _loadData();
  }

  // edit link
  Future<void> _editLink(Link link) async {
    TextEditingController linkController =
        TextEditingController(text: link.link);
    TextEditingController linkNameController =
        TextEditingController(text: link.nameLink);
    FocusNode linkFocusNode = FocusNode();
    FocusNode linkNameFocusNode = FocusNode();

    await showDialog(
      // menampilkan pop up edit
      context: context,
      builder: (context) {
        // keyboard aktif langsung
        WidgetsBinding.instance
            .addPostFrameCallback((_) => linkFocusNode.requestFocus());

        return AlertDialog(
          title: const Text('Update Link'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: linkNameController,
                focusNode: linkNameFocusNode,
                decoration: const InputDecoration(
                  hintText: 'Enter New Link Name',
                ),
              ),
              TextField(
                controller: linkController,
                focusNode: linkFocusNode,
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
                
                // Edit ga bole kosong
                String newLinkName = linkNameController.text.trim();
                String newLink = linkController.text.trim();

                if (newLinkName.isNotEmpty && newLink.isNotEmpty) {
                  // jika input tidak kosong
                  await editLink(link.id!, newLinkName, newLink);
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
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  // MAIN WIDGET ==================================================
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 13.0,
        left: 13.0,
        bottom: 5.0,
      ),
      child: Card(
        child: Container(
          decoration: ShapeDecoration(
            gradient: const LinearGradient(
              begin: Alignment(-0.97, -0.26),
              end: Alignment(0.97, 0.26),
              colors: [Color(0xFF537FE7), Color(0xFFB6FFFA)],
            ),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            shadows: const [
              BoxShadow(
                color: Color(0x4C537FE7),
                blurRadius: 3,
                offset: Offset(0, 3),
                spreadRadius: 0,
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ExpansionTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              initiallyExpanded: _isExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _isExpanded = expanded;
                });
              },
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.subCategory.subCategoryName as String,
                      style: GoogleFonts.lexend(
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Changed color to black
                        fontSize: 20,
                      ),
                    ),
                  ),
                  // icon edit
                  IconButton(
                    icon: const Icon(Icons.edit),
                    iconSize: 20,
                    color: const Color.fromARGB(255, 0, 0, 0),
                    onPressed: () {
                      widget.onUpdate(widget.subCategory);
                    },
                  ),

                  // icon delete
                  IconButton(
                    icon: const Icon(Icons.delete),
                    iconSize: 20,
                    color: const Color.fromARGB(255, 207, 22, 22),
                    onPressed: () {
                      widget.onDelete(widget.subCategory.id!);
                    },
                  ),
                ],
              ),
              // iterasi setiap link dengan link card
              children: [
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  // iterasi widget sub category card
                  itemCount: _links.length,
                  itemBuilder: (context, index) {
                    final Link link = Link.fromMap(_links[index]);

                    return LinkCard(
                      link: link,
                      onDelete: _deleteLink,
                      onUpdate: _editLink,
                    );
                  },
                ),
                // tambah link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        _addLink("", "");
                      },
                      icon: const Icon(Icons.add),
                      label: Text(
                        "Tambah Link",
                        style: GoogleFonts.lexend(
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF537FE7),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
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
