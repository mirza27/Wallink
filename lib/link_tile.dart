import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkTile extends StatefulWidget {
  final String name;
  final String link;
  final String createdAt;
  final Function(String newName, String newLink) onUpdate;
  final VoidCallback onDelete;

  const LinkTile({
    Key? key,
    required this.name,
    required this.link,
    required this.createdAt,
    required this.onUpdate,
    required this.onDelete,
  }) : super(key: key);

  @override
  _LinkTileState createState() => _LinkTileState();
}

class _LinkTileState extends State<LinkTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.black12,
      title: SizedBox(
        child: Row(
          children: <Widget>[
            // LINK DAN LAUNCH LINK
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    // nama link
                    children: <Widget>[
                      Text(
                        widget.name,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                        ),
                      ),

                      // launch button
                      SizedBox(
                        child: IconButton(
                            icon: const Icon(
                              Icons.launch,
                              size: 12,
                            ),
                            onPressed: () {
                              _launchURL(widget.link);
                            }),
                      )
                    ],
                  ),
                  Text(
                    widget.link,
                    style: const TextStyle(color: Colors.black87, fontSize: 10),
                  )
                ],
              ),
            ),

            // ICON UNTUK CRUD
            Expanded(
                flex: 3,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      // icon copy
                      icon: const Icon(
                        Icons.copy,
                        size: 17,
                      ),
                      onPressed: () {},
                    ),
                    IconButton(
                      // icon edit
                      icon: const Icon(
                        Icons.edit,
                        size: 17,
                      ),
                      onPressed: () {
                        _editLinkName(context, widget.name, widget.link);
                      },
                    ),
                    IconButton(
                      // icon delete
                      icon: const Icon(
                        Icons.delete,
                        size: 17,
                      ),
                      onPressed: () {
                        widget.onDelete();
                      },
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }

  // POP UP DIALOG EDIT LINK DAN LINK_NAME
  void _editLinkName(BuildContext context, String name, String link) async {
    TextEditingController linkNameTextController = TextEditingController();
    TextEditingController linkTextController = TextEditingController();
    linkNameTextController.text = name;
    linkTextController.text = link;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Edit Link"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: linkNameTextController,
                decoration: const InputDecoration(hintText: "Enter new name"),
              ),
              TextFormField(
                controller: linkTextController,
                decoration: const InputDecoration(hintText: "Enter new link"),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateLink(
                    linkNameTextController.text, linkTextController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // panggil update di sub_category
  _updateLink(String newName, String newLink) {
    widget.onUpdate(
        newName, newLink); // menggunakan callback untuk update nilai
  }

  // luncurkan link
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri(scheme: "https", host: url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "can't launch url";
    }
  }
}
