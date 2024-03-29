import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wallink_v1/models/category.dart';
import 'package:wallink_v1/page/sub_category_page.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  final Function(int) onDelete; // memanggil fungsi delete di category page
  final Function(Category) onUpdate; // memanggil fungsi edit di category page

  const CategoryCard(
      {super.key,
      required this.category,
      required this.onDelete,
      required this.onUpdate});

  // MAIN WIDGET ==================================================
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // redirect ke subcategory page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SubCategoryPage(categoryId: category.id),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: double.infinity,
          height: 150, // Reduced height
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment(-0.97, -0.26),
              end: Alignment(0.97, 0.26),
              colors: [Color(0xFF537FE7), Color(0xFFB6FFFA)],
            ),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Opacity(
                    opacity: 0.0,
                    child: IconButton(
                      icon: const Icon(
                        Icons.edit,
                        size: 17,
                      ),
                      onPressed: () {
                      },
                    ),
                  )
                ],
              ),
              Expanded(
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    category.nameCategory as String,
                    style: GoogleFonts.lexend(
                      fontWeight: FontWeight.bold,
                      color: Colors.black, // Changed color to black
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    // icon delete
                    icon: const Icon(
                      Icons.edit,
                      size: 17,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      onUpdate(category);
                    },
                  ),
                  IconButton(
                    // icon delete
                    icon: const Icon(
                      Icons.delete,
                      size: 17,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      onDelete(category.id!);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
