import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/category_controller.dart';
import 'package:wallink_v1/page/category_page.dart';
//import 'package:wallink_v1/data_links.dart'; // Import data _categories
import 'package:wallink_v1/widgets/category_card_intro.dart';
import 'package:wallink_v1/models/category.dart';

class IntroListPagge extends StatefulWidget {
  const IntroListPagge({Key? key})
      : super(key: key); // Perbaikan pada konstruktor

  @override
  State<IntroListPagge> createState() => _IntroListPaggeState();
}

class _IntroListPaggeState extends State<IntroListPagge> {
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // refresh dan load data
  Future<void> _loadData() async {
    List<Map<String, dynamic>> categories = await getCategories();

    setState(() {
      _categories = categories;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Padding(
          padding: EdgeInsets.only(
            left: 8.0,
            top: 12.0,
            bottom: 12.0,
          ),
          child: Text(
            'Wallink',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(
              right: 8.0,
              top: 12.0,
              bottom: 12.0,
            ),
            // child: IconButton(
            //   icon: const Icon(Icons.search),
            //   onPressed: () {
            //     // Handle search icon tap here
            //   },
            // ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Text(
                'Berikut Kategori yang Mungkin Cocok ',
                style: TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: SizedBox(
                  child: ListView.builder(
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      if (_categories.isEmpty) {
                        return CircularProgressIndicator();
                      }
                      final Category category =
                          Category.fromMap(_categories[index]);
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4.0,
                          horizontal: 8.0,
                        ),
                        child: CategoryCardIntro(
                          category: category,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 16, // Jarak dari bawah layar
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CategoryPage(), // Ganti 'HalamanTujuan' dengan nama kelas halaman tujuan
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black, // Warna latar belakang hitam
                ),
                child: Text(
                  'Pindah Halaman',
                  style: TextStyle(
                    color: Colors.white, // Warna teks putih
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _delete(int p1) {}

  _update(Category p1) {}
}
