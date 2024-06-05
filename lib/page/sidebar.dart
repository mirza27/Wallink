import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallink_v1/page/archived_page.dart';
import 'package:wallink_v1/page/setting_page.dart';
import 'faq_page.dart';

class Sidebar extends StatelessWidget {
  final Function(int) setIndex;
  final Function backReload;
  const Sidebar({super.key, required this.setIndex, required this.backReload});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 16,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.zero,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    ListTile(
                      tileColor: Colors.white,
                      title: const Text(
                        'Wallink',
                        style: TextStyle(
                          fontFamily: 'sharp',
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 30,
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
                      leading:
                          const Icon(CupertinoIcons.home, color: Colors.black),
                      title: const Text(
                        'Home',
                        style: TextStyle(
                          fontFamily: 'sharp',
                          color: Colors.black,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setIndex(0);
                      },
                    ),
                    ListTile(
                      tileColor: Colors.white,
                      leading:
                          const Icon(CupertinoIcons.heart, color: Colors.black),
                      title: const Text(
                        'Favorite',
                        style:
                            TextStyle(fontFamily: 'sharp', color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        setIndex(1);
                      },
                    ),
                    ListTile(
                      tileColor: Colors.white,
                      leading: const Icon(CupertinoIcons.archivebox,
                          color: Colors.black),
                      title: const Text(
                        'Archive',
                        style:
                            TextStyle(fontFamily: 'sharp', color: Colors.black),
                      ),
                      onTap: () {
                        // Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ArchivedLinksPage(
                                    onBackPressed: backReload,
                                  )),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Column(
                  children: [
                    ListTile(
                      tileColor: Colors.white,
                      leading:
                          const Icon(CupertinoIcons.gear, color: Colors.black),
                      title: const Text(
                        'Settings',
                        style:
                            TextStyle(fontFamily: 'sharp', color: Colors.black),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingPage(
                                      onChangedPreference: setIndex,
                                    )));
                      },
                    ),
                    ListTile(
                      tileColor: Colors.white,
                      leading: const Icon(CupertinoIcons.question_circle,
                          color: Colors.black),
                      title: const Text(
                        'Help',
                        style: TextStyle(
                          fontFamily: 'sharp',
                          color: Colors.black,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FAQPage()),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
