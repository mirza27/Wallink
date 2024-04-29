import 'package:flutter/material.dart';
import 'package:wallink_v1/page/fav_page.dart';
import 'faq_page.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.zero,
        ),
        child: ListView(
          padding: EdgeInsets.only(top: 60),
          children: [
            ListTile(
              tileColor: Colors.white,
              title: Text(
                'WALLINK',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 33,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(
              height: 1,
            ),
            ListTile(
              tileColor: Colors.white,
              leading: Icon(Icons.home, color: Colors.black),
              title: Text(
                'Home',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 10),
            ListTile(
              tileColor: Colors.white,
              leading: Icon(Icons.collections_bookmark_sharp, color: Colors.black),
              title: Text(
                'Favorite',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => FavoriteLinksPage()));
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              tileColor: Colors.white,
              leading: Icon(Icons.archive_rounded, color: Colors.black),
              title: Text(
                'Archive',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            SizedBox(height: 350,),
            Divider( // Gunakan Divider untuk membuat garis pemisah
              color: Colors.grey[400],
              thickness: 1.0,
              height: 40, // Atur tinggi Divider agar memiliki jarak yang cukup dengan ListTile "Settings"
              indent: 16, // Atur indent agar garis dimulai dari kiri
              endIndent: 16, // Atur end indent agar garis berakhir di kanan
            ),
            ListTile(
              tileColor: Colors.white,
              leading: Icon(Icons.settings, color: Colors.black),
              title: Text(
                'Settings',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              tileColor: Colors.white,
              leading: Icon(Icons.help_outline_sharp, color: Colors.black),
              title: Text(
                'Help',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context) => FAQPage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
