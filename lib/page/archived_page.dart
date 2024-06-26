import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/widgets/link_card.dart';

class ArchivedLinksPage extends StatefulWidget {
  Function? onBackPressed;
  ArchivedLinksPage({
    super.key,
    required this.onBackPressed,
  });

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
          centerTitle: true,
          title: const Text(
            'Archive',
            style: TextStyle(
              color: Color.fromRGBO(5, 105, 220, 1),
              fontWeight: FontWeight.bold,
              fontFamily: 'sharp',
              fontSize: 20,
            ),
          ),
          backgroundColor: const Color.fromRGBO(201, 226, 255, 1),
          leading: IconButton(
            icon: const Icon(
              CupertinoIcons.back,
              size: 30,
              color: Color.fromRGBO(5, 105, 220, 1),
            ),
            onPressed: () {
              //
              widget.onBackPressed!();
            },
          ),
        ),
        body: _archiveLinkFuture.isEmpty
            ? Center(
                child: Image.asset(
                  'assets/nodata_archived.png',
                  width: 370,
                  height: 370,
                ),
              )
            : Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      // iterasi widget sub category card
                      itemCount: _archiveLinkFuture.length,
                      itemBuilder: (context, index) {
                        final Link link =
                            Link.fromMap(_archiveLinkFuture[index]);

                        return LinkCard(
                            link: link, onChanged: _getArchivedLinks);
                      },
                    ),
                  ),
                ],
              ));
  }
}
