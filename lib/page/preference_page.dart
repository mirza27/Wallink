import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts package
import 'package:wallink_v1/controller/category_controller.dart';
import 'package:wallink_v1/database/app_preferences.dart';
import 'package:wallink_v1/page/category_page.dart';

class PreferencePage extends StatefulWidget {
  @override
  _PreferencePageState createState() => _PreferencePageState();
}

class _PreferencePageState extends State<PreferencePage> {
  final List<String> _selectedCategories = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Preference Categories',
          style: TextStyle(color: Colors.black), // Text color changed to black
        ),
        backgroundColor: Colors.lightBlue[200], // Background color changed to light blue
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Pilih Kategori Sesuai Kebutuhan Anda',
              style: GoogleFonts.lexend( // Use Google Fonts lexend
                fontSize: 27.0,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 0, 0, 0), // Text color changed to dark blue
              ),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: [
                  for (var category in [
                    'Education',
                    'Work',
                    'Entertainment',
                    'News',
                    'Organization',
                    'Documentation',
                  ])
                    CategoryCardWanted(
                      category: category,
                      isSelected: _selectedCategories.contains(category),
                      onTap: () {
                        setState(() {
                          if (_selectedCategories.contains(category)) {
                            _selectedCategories.remove(category);
                          } else {
                            _selectedCategories.add(category);
                          }
                        });
                      },
                    ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () async {
                for (String data in _selectedCategories) {
                  insertCategory(data);
                }

                // Set isFirstTime ke false
                await AppPreferences.setFirstTime(false);

                // Navigasi Kembali ke p
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const CategoryPage()),
                  (route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[300], // Button background color changed to light blue
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [                  
                  Text(
                    "NEXT",
                    style: GoogleFonts.lexend( // Use Google Fonts lexend
                      color: const Color.fromARGB(255, 255, 254, 234),
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

// Widget untuk category preferenced
class CategoryCardWanted extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryCardWanted({
    Key? key, // Add Key parameter
    required this.category,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key); // Pass key parameter to super constructor

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isSelected ? Colors.lightBlue[300] : Colors.lightBlue[100], // Card background color changed to light blue
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.lightBlue[900], // Text color changed to black if selected, dark blue otherwise
            ),
          ),
        ),
      ),
    );
  }
}
