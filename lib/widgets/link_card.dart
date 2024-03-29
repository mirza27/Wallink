import 'package:flutter/material.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/services.dart';

class LinkCard extends StatefulWidget {
  final Link link;
  final Function(int) onDelete; // memanggil fungsi delete di subcategory card
  final Function(Link) onUpdate; // memanggil fungsi edit di subcategory page

  const LinkCard(
      {super.key,
      required this.link,
      required this.onDelete,
      required this.onUpdate});

  @override
  State<LinkCard> createState() => _LinkCardState();
}

class _LinkCardState extends State<LinkCard> {
  // fungsi launch url
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri(scheme: "https", host: url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "can't launch url";
    }
  }

  // fungsi copy
  Future<void> _copytoClipboard(String url) async {
    Clipboard.setData(ClipboardData(text: url));
  }

  // MAIN WIDGET ==================================================
  @override
  Widget build(BuildContext context) {
    return ListTile(
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
                    children: <Widget>[
                      // nama link
                      Text(
                        widget.link.nameLink as String,
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
                              _launchURL(widget.link.link as String);
                            }),
                      )
                    ],
                  ),
                  Text(
                    widget.link.link as String,
                    style:
                        const TextStyle(color: Colors.black87, fontSize: 10),
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
                      onPressed: () {
                        _copytoClipboard(widget.link.link as String);
                      },
                    ),
                    IconButton(
                      // icon edit
                      icon: const Icon(
                        Icons.edit,
                        size: 17,
                      ),
                      onPressed: () {
                        widget.onUpdate(widget.link);
                      },
                    ),
                    IconButton(
                      // icon delete
                      icon: const Icon(
                        Icons.delete,
                        size: 17,
                      ),
                      onPressed: () {
                        widget.onDelete(widget.link.id!);
                      },
                    ),
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
