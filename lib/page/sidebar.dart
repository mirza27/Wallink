import 'package:flutter/material.dart';
import 'package:wallink_v1/page/archived_page.dart';
import 'package:wallink_v1/page/fav_page.dart';
import 'package:wallink_v1/page/home_page.dart';
import 'package:wallink_v1/route_page.dart';
import 'faq_page.dart';

class Sidebar extends StatelessWidget {
  final Function(int index) setIndex;
  
  const Sidebar({Key? key, required this.setIndex}) : super(key: key);

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
                setIndex(0);
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
                setIndex(1);
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ArchivedLinksPage()),
                );
              },
            ),
            SizedBox(
              height: 350,
            ),
            Divider(
              // Gunakan Divider untuk membuat garis pemisah
              color: Colors.grey[400],
              thickness: 1.0,
              height: 40, // Atur tinggi Divider
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
                // Tambahkan logika untuk menavigasi ke halaman Settings jika diperlukan
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
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FAQPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
