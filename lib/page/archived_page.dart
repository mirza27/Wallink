import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/link_controller.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/widgets/link_card.dart';

class ArchivedLinksPage extends StatefulWidget {
  @override
  _ArchivedLinksPageState createState() => _ArchivedLinksPageState();
}

class _ArchivedLinksPageState extends State<ArchivedLinksPage> {
  late Future<List<Link>> _archivedLinkFuture;

  @override
  void initState() {
    super.initState();
    _archivedLinkFuture = _getArchivedLinks();
  }

  Future<List<Link>> _getArchivedLinks() async {
    List<Map<String, dynamic>> archivedLinksData = await getArchivedLink();
    List<Link> archivedLinks =
        archivedLinksData.map((data) => Link.fromMap(data)).toList();
    return archivedLinks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Archived Links'),
      ),
      body: FutureBuilder<List<Link>>(
        future: _archivedLinkFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(child: Text('No Archived links found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return LinkCard(
                  link: snapshot.data![index],
                  onDelete: (id) {
                    // Implement delete functionality if needed
                  },
                  onUpdate: (link) {
                    // Implement update functionality if needed
                  },
                  onChanged: () {},
                );
              },
            );
          }
        },
      ),
    );
  }
}