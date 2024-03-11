import 'package:flutter/material.dart';
import 'package:wallink_v1/links.dart';
import 'package:wallink_v1/link_tile.dart';
import 'package:intl/intl.dart';

class SubCategoryTile extends StatefulWidget {
  final String subCategoryName;
  final List<Link> links;
  final VoidCallback onDelete;

  const SubCategoryTile({
    super.key,
    required this.subCategoryName,
    required this.links,
    required this.onDelete,
  });

  @override
  _SubCategoryTileState createState() => _SubCategoryTileState();
}

class _SubCategoryTileState extends State<SubCategoryTile> {
  late TextEditingController _textController;
  bool _isEditing = false;
  late String _editedText;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _editedText = widget.subCategoryName;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
          title: _isEditing
              ? TextFormField(
                  controller: _textController,
                  onFieldSubmitted: (value) {
                    _saveEditedText();
                  },
                )
              : Row(
                  children: [
                    // sentuh text untuk edit
                    Expanded(
                      child: GestureDetector(
                        onTap: _startEditing,
                        child: Text(widget.subCategoryName),
                      ),
                    ),

                    // icon edit
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _startEditing();
                      },
                    ),

                    // icon delete
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        widget.onDelete();
                      },
                    ),
                  ],
                ),
          children: [
            ...widget.links.asMap().entries.map((entry) {
              final index = entry.key;
              final link = entry.value;
              final formattedDate =
                  DateFormat.MMMd().add_jm().format(link.createdAt); // tanggal

              return LinkTile(
                name: link.name,
                link: link.link,
                createdAt: formattedDate,
                onUpdate: (String newName, String newLink) {
                  _updateLink(link, newName, newLink); // fungsi update link
                },
                onDelete: () {
                  _deleteLink(index);
                },
              );
            }).toList(),

            // tombol tambah link
            IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  _addNewLink();
                })
          ]),
    );
  }

  // EDIT SUB CATEGORY
  void _startEditing() {
    setState(() {
      _isEditing = true;
      _textController.text = _editedText;
    });
  }

  void _saveEditedText() {
    setState(() {
      _isEditing = false;
      _editedText = _textController.text;
    });
  }

  // membersihkan memori _textController
  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // ADD NEW LINK
  void _addNewLink() {
    setState(() {
      final newLink = Link(
        name: 'New Link',
        link: 'https://example.com',
        createdAt: DateTime.now(),
      );
      widget.links.add(newLink);
    });
  }

  // DELETE LINK
  void _deleteLink(int index) {
    setState(() {
      widget.links.removeAt(index);
    });
  }

  // UPDATE LINK dikirim ke link_tile.dart
  void _updateLink(Link link, String newName, String newLink) {
    setState(() {
      link.name = newName;
      link.link = newLink;
      link.createdAt = DateTime.now();
    });
  }
}
