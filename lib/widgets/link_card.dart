import 'package:flutter/material.dart';
import 'package:wallink_v1/models/link.dart';

class LinkCard extends StatefulWidget {
  final Map<String, dynamic> link;

  const LinkCard({super.key, required this.link});

  @override
  State<LinkCard> createState() => _LinkCardState();
}

class _LinkCardState extends State<LinkCard> {
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
                        widget.link[LinkFields.columnLinkName] as String,
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
                              // _launchURL(widget.link);
                            }),
                      )
                    ],
                  ),
                  Text(
                    widget.link[LinkFields.columnLink] as String,
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
                        // _editLinkName(context, widget.name, widget.link);
                      },
                    ),
                    IconButton(
                      // icon delete
                      icon: const Icon(
                        Icons.delete,
                        size: 17,
                      ),
                      onPressed: () {
                        // widget.onDelete();
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
