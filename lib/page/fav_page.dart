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
  late Future<List<Link>> _favoriteLinksFuture;

  @override
  void initState() {
    super.initState();
    _favoriteLinksFuture = _getFavoriteLinks();
  }

  Future<List<Link>> _getFavoriteLinks() async {
    List<Map<String, dynamic>> favoriteLinksData = await getFavLink();
    List<Link> favoriteLinks =
        favoriteLinksData.map((data) => Link.fromMap(data)).toList();
    return favoriteLinks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Links'),
      ),
      body: FutureBuilder<List<Link>>(
        future: _favoriteLinksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isEmpty) {
            return Center(child: Text('No favorite links found.'));
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
