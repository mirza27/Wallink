import 'package:flutter/material.dart';
import 'package:wallink_v1/models/link.dart';
import 'package:wallink_v1/models/sub_category.dart';
import 'package:wallink_v1/widgets/link_card.dart';

class SubCategoryCard extends StatefulWidget {
  final SubCategory subCategory;
  final List<Map<String, dynamic>> links;
  // final List<Link> links;

  const SubCategoryCard(
      {super.key, required this.subCategory, required this.links});

  @override
  State<SubCategoryCard> createState() => _SubCategoryCardState();
}

class _SubCategoryCardState extends State<SubCategoryCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ExpansionTile(
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        title: Text(widget.subCategory.subCategoryName
            as String), // mengambil parameter widget

            // iterasi setiap link dengan link card
        children: <Widget>[
          Column(
            children: widget.links.map((link) {
              return LinkCard(
                link: link,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
