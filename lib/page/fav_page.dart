import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/link_controller.dart';
//import 'package:wallink_v1/database/link_database.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/widgets/link_card.dart';

class FavoriteLinksPage extends StatefulWidget {
  @override
  _FavoriteLinksPageState createState() => _FavoriteLinksPageState();
}

class _FavoriteLinksPageState extends State<FavoriteLinksPage> {
  List<Map<String, dynamic>> _favoriteLinksFuture = [];

  @override
  void initState() {
    super.initState();
    _getFavoriteLinks();
  }

  Future<void> _getFavoriteLinks() async {
    List<Map<String, dynamic>> favoriteLinksData = await getFavLink();

    setState(() {
      _favoriteLinksFuture = favoriteLinksData;
    });

    // List<Link> favoriteLinks =
    //     favoriteLinksData.map((data) => Link.fromMap(data)).toList();
    // return favoriteLinks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Favorite Links'),
          backgroundColor: Color.fromRGBO(201, 226, 255, 1),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              size: 16,
            ),
            onPressed: () {
              Navigator.pop(
                  context); // Fungsi Navigator.pop untuk kembali ke halaman sebelumnya
            },
          ),
        ),
        body: Column(
          children: [
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              // iterasi widget sub category card
              itemCount: _favoriteLinksFuture.length,
              itemBuilder: (context, index) {
                final Link link = Link.fromMap(_favoriteLinksFuture[index]);

                return LinkCard(link: link, onChanged: _getFavoriteLinks);
              },
            ),
          ],
        ));
  }
}
