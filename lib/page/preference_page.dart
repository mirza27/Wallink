import 'package:flutter/material.dart';
import 'package:wallink_v1/controller/category_controller.dart';
import 'package:wallink_v1/database/app_prefereneces.dart';
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
        title: const Text('Preference Categories'),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Berikut Kategori yang Mungkin Cocok untuk anda',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
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
              child: const Text('Next'),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Kategori yang dipilih: ${_selectedCategories.join(', ')}',
              style: const TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
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
    super.key,
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Card(
        color: isSelected ? Colors.greenAccent : Colors.blueAccent,
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.black : Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
