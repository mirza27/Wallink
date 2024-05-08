import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:wallink_v1/form/link_form.dart';
import 'package:wallink_v1/page/fav_page.dart';
import 'package:wallink_v1/page/home_page.dart';
import 'package:wallink_v1/page/sidebar.dart';

class RoutePage extends StatefulWidget {
  const RoutePage({super.key, required int selectedIndex});

  @override
  State<RoutePage> createState() => _RoutePageState();
}

class _RoutePageState extends State<RoutePage> {
  int _selectedIndex = 0;

  // static final List<Widget> _widgetOptions = [
  //   const HomePage(),
  //   FavoriteLinksPage()
  // ];

Future<void>SetRoute(int index)async {
  setState(() {
    _selectedIndex = index;
  });
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: false,
      // body: _widgetOptions.elementAt(_selectedIndex),
      body: _selectedIndex == 0
          ? HomePage(
      drawerButton: (BuildContext context) {
        return IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        );
      },
    )
  : FavoriteLinksPage(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) => AlertDialog(
                    backgroundColor: const Color.fromRGBO(249, 249, 251, 1),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    shape: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      borderSide: const BorderSide(
                        color: Color.fromRGBO(30, 31, 36, 1),
                        width: 1.5,
                      ),
                    ),
                    content: LinkForm(link: null, context: context),
                    insetPadding: const EdgeInsets.all(10),
                  ));
        },
        backgroundColor: const Color.fromRGBO(5, 105, 220, 1),
        foregroundColor: const Color.fromRGBO(252, 252, 253, 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: const Icon(
          Icons.add,
          size: 40,
        ),
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
      drawer: Sidebar(setIndex: SetRoute,),
    );
  }
}
