import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wallink_v1/page/fav_page.dart';
import 'package:wallink_v1/page/home_page.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = [
    const HomePage(),
    FavoriteLinksPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      body: _widgetOptions.elementAt(_selectedIndex),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color.fromRGBO(5, 105, 220, 1),
        
        foregroundColor: const Color.fromRGBO(252, 252, 253, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
          
        ),
        child: const Icon(Icons.add, size: 40,),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: Container(
        color: const Color.fromRGBO(252, 252, 253, 1),
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromRGBO(252, 252, 253, 1),
            border: Border(
              top: BorderSide(
                  color: Color.fromRGBO(216, 217, 224, 1),
                  width: 0.5), // Menambahkan top border
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 15),
            child: GNav(
              tabs: const [
                GButton(icon: Icons.home),
                GButton(icon: Icons.favorite_border),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              gap: 8,
              iconSize: 35,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              duration: const Duration(milliseconds: 200),
              backgroundColor: const Color.fromRGBO(252, 252, 253, 1),
              color: const Color.fromRGBO(139, 141, 152, 1),
              activeColor: const Color.fromRGBO(5, 105, 220, 1),
              // tabBackgroundColor: const Color.fromRGBO(57, 62, 70, 1),
              padding: const EdgeInsets.all(10),
            ),
          ),
        ),
      ),
    );
  }
}