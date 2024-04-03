import 'package:flutter/material.dart';
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
    await insertLink(link, linkName, widget.subCategory.id!);
    await _loadData();
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
                String newLink = linkController.text;
                String newLinkName = linkNameController.text;
                await editLink(link.id!, newLinkName,
                    newLink); // Memperbarui link dan link_name
                Navigator.pop(context);
                await _loadData();
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
    return Card(
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment(-0.97, -0.26),
            end: Alignment(0.97, 0.26),
            colors: [Color(0xFF537FE7), Color(0xFFB6FFFA), Color(0xFFB6FFFA)],
          ),
          borderRadius: BorderRadius.circular(24),
        ),
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
              Expanded(child: Text(widget.subCategory.subCategoryName as String)),
              // icon edit
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  widget.onUpdate(widget.subCategory);
                },
              ),

              // icon delete
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  widget.onDelete(widget.subCategory.id!);
                },
              ),
            ],
          ),
          // iterasi setiap link dengan link card
          children: [
            ListView.builder(
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
                }),
            // tambah link
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _addLink("New Link", "www.example.com");
                }),
          ],
        ),
      ),
    );
  }
}
