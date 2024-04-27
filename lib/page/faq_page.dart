import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  final List<String> questions = [
    'What is Wallink?',
    'What are the advantages\nof Wallink?',
    'How to edit or delete links\nin Wallink?',
    'How to delete subcategories\nin Wallink?',
    'How do you launch a link\non Wallink?',
  ];

  final Map<String, Map<String, dynamic>> answers = {
    'What is Wallink?': {
      'text':
          'Wallink is a digital link management and management application. This application provides features such as link storage, link categorization, search features, and is able to integrate with other browsers. The Wallink application is designed to meet the needs and preferences of Generation Z in managing their digital links, with a focus on effectiveness, efficiency and minimal user interaction.',
      'image': 'assets/images/wallink_logo.png',
    },
    'What are the advantages\nof Wallink?': {
      'text':
          '1. Structured and easy to understand display.\n'
          '2. Note links with categories and sub-categories.\n'
          '3. Reminder for selected data.\n'
          '4. Automatic category (Auto fill for selected link domains).\n'
          '5. Quick search and access.',
      'image': null,
    },
    'How to edit or delete links\nin Wallink?': {
      'text':
          'Click the pencil icon to edit the link.\n'
          'Click the trash icon to delete the link.',
      'image': 'assets/images/edit_delete_icons.png',
    },
    'How to delete subcategories\nin Wallink?': {
      'text': 'Click the icon "Delete SubCategory"',
      'image': null,
    },
    'How do you launch a link\non Wallink?': {
      'text':
          'Step 1:\n Find the link you want to launch. This link can be found under SubCategory > Click Category > Link.\n'
          'Step 2:\n Click the link. This link will open your web browser and launch the link automatically.',
      'image': 'assets/images/launch_link_icon.png',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: AppBar(
              backgroundColor: Color(0xFF005ACC),
              title: Text(
                'FAQ',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              leadingWidth: 25.0,
              iconTheme: IconThemeData(color: Colors.white),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ExpansionTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              questions[index],
                              style: TextStyle(color: const Color.fromARGB(255, 6, 6, 6)),
                            ),
                          ],
                        ),
                        children: [
                          Divider(color: Colors.grey),
                          Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  answers[questions[index]]!['text'],
                                  style: TextStyle(fontSize: 16.0),
                                ),
                                SizedBox(height: 5),
                                if (answers[questions[index]]!['image'] != null)
                                  Image.asset(
                                    answers[questions[index]]!['image'],
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
