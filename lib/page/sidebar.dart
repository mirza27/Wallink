import 'package:flutter/material.dart';
import 'package:wallink_v1/page/archived_page.dart';
import 'package:wallink_v1/page/setting_page.dart';
import 'faq_page.dart';

class Sidebar extends StatelessWidget {
  final Function(int index) setIndex;
  const Sidebar({super.key, required this.setIndex});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.zero,
        ),
        child: ListView(
          padding: const EdgeInsets.only(top: 60),
          children: [
            ListTile(
              tileColor: Colors.white,
              title: const Text(
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
            const SizedBox(
              height: 1,
            ),
            ListTile(
              tileColor: Colors.white,
              leading: const Icon(Icons.home, color: Colors.black),
              title: const Text(
                'Home',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
                setIndex(0);
              },
            ),
            const SizedBox(height: 10),
            ListTile(
              tileColor: Colors.white,
              leading: const Icon(Icons.collections_bookmark_sharp,
                  color: Colors.black),
              title: const Text(
                'Favorite',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.pop(context);
                setIndex(1);
              },
            ),
            const SizedBox(
              height: 10,
            ),
            ListTile(
              tileColor: Colors.white,
              leading: const Icon(Icons.archive_rounded, color: Colors.black),
              title: const Text(
                'Archive',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                // Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ArchivedLinksPage()),
                );
              },
            ),
            const SizedBox(
              height: 350,
            ),
            Divider(
              color: Colors.grey[400],
              thickness: 1.0,
              height: 40,
              indent: 16,
              endIndent: 16,
            ),
            ListTile(
              tileColor: Colors.white,
              leading: const Icon(Icons.settings, color: Colors.black),
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.black),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SettingPage()));
              },
            ),
            ListTile(
              tileColor: Colors.white,
              leading:
                  const Icon(Icons.help_outline_sharp, color: Colors.black),
              title: const Text(
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
