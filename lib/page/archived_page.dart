import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/page/home_page.dart';
import 'package:wallink_v1/widgets/link_card.dart';

class ArchivedLinksPage extends StatefulWidget {
  @override
  _ArchivedLinksPageState createState() => _ArchivedLinksPageState();
}

class _ArchivedLinksPageState extends State<ArchivedLinksPage> {
  List<Map<String, dynamic>> _archiveLinkFuture = [];

  @override
  void initState() {
    super.initState();

    _getArchivedLinks();
  }

  Future<void> _getArchivedLinks() async {
    List<Map<String, dynamic>> archivedLinksData = await getArchivedLink();

    setState(() {
      _archiveLinkFuture = archivedLinksData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Archived Links'),
          backgroundColor: Color.fromRGBO(201, 226, 255, 1),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 16,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomePage(
                    drawerButton: (context) =>
                        Icon(Icons.menu),
                  ),
                ),
              );
            },
          ),
        ),
        body: Column(
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              // iterasi widget sub category card
              itemCount: _archiveLinkFuture.length,
              itemBuilder: (context, index) {
                final Link link = Link.fromMap(_archiveLinkFuture[index]);

                return LinkCard(link: link, onChanged: _getArchivedLinks);
              },
            ),
          ],
        ));
  }
}
