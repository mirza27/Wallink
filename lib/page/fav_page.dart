import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:wallink_v1/controller/link_controller.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Favorite Links',
          style: TextStyle(
            color: Color.fromRGBO(5, 105, 220, 1),
            fontWeight: FontWeight.bold,
            fontFamily: 'sharp',
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color.fromRGBO(201, 226, 255, 1),
      ),
      body: Column(
        children: [
          SlidableAutoCloseBehavior(
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              // iterasi widget sub category card
              itemCount: _favoriteLinksFuture.length,
              itemBuilder: (context, index) {
                final Link link = Link.fromMap(_favoriteLinksFuture[index]);

                return LinkCard(link: link, onChanged: _getFavoriteLinks);
              },
            ),
          ),
        ],
      ),
    );
  }
}
