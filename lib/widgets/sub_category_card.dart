import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/models/sub_category.dart';
import 'package:wallink_v1/widgets/link_card.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

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

  @override
  void didUpdateWidget(covariant SubCategoryCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if ((widget.subCategory.id != oldWidget.subCategory.id)) {
      if ((widget.subCategory.id != null || widget.subCategory.id != 0)) {
        _loadData();
      }
    }
  }

  void _markAsArchived(int id) async {
    await markAsArchived(id);
    _loadData();
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

  Future<void> _showBottomSheet(BuildContext context, int index) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit'),
              onTap: () {
                widget.onUpdate(widget.subCategory);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Delete'),
              onTap: () {
                widget.onDelete(widget.subCategory.id!);
              },
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share'),
              onTap: () {},
            ),
          ],
        );
      },
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
        padding: const EdgeInsets.only(
          right: 13.0,
          left: 13.0,
          bottom: 5.0,
        ),
        child: Card(
          child: Container(
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
              shadows: const [
                BoxShadow(
                  color: Color.fromARGB(255, 209, 208, 208),
                  offset: Offset(2, 4),
                  blurRadius: 5,
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
                  ],
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

                      return  LinkCard(
                            link: link,
                            onChanged: _loadData);
                      
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
      ),
    );
  }
}
