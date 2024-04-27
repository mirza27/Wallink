import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  final List<String> questions = [
    'What is Wallink?',
    'What are the advantages of Wallink?',
    'How to edit or delete links in Wallink?',
    'How to delete subcategories in Wallink?',
    'How do you launch a link on Wallink?'
  ];

  final Map<String, Map<String, dynamic>> answers = {
    'What is Wallink?': {
      'text':
          'Wallink is a digital link management and management application. This application provides features such as link storage, link categorization, search features, and is able to integrate with other browsers. The Wallink application is designed to meet the needs and preferences of Generation Z in managing their digital links, with a focus on effectiveness, efficiency and minimal user interaction.',
      'image': 'assets/images/wallink_logo.png', // Path gambar
    },
    'What are the advantages of Wallink?': {
      'text':
          '1. Structured and easy to understand display.\n'
          '2. Note links with categories and sub-categories.\n'
          '3. Reminder for selected data.\n'
          '4. Automatic category (Auto fill for selected link domains).\n'
          '5. Quick search and access.',
      'image': null, // Tidak ada gambar untuk pertanyaan ini
    },
    'How to edit or delete links in Wallink?': {
      'text':
          'Click the pencil icon to edit the link.\n'
          'Click the trash icon to delete the link.',
      'image': 'assets/images/edit_delete_icons.png', // Path gambar
    },
    'How to delete subcategories in Wallink?': {
      'text': 'Click the icon "Delete SubCategory"',
      'image': null, // Tidak ada gambar untuk pertanyaan ini
    },
    'How do you launch a link on Wallink?': {
      'text':
          'Step 1: Find the link you want to launch. This link can be found under SubCategory > Click Category > Link.\n'
          'Step 2: Click the link. This link will open your web browser and launch the link automatically.',
      'image': 'assets/images/launch_link_icon.png', // Path gambar
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF005ACC),
        title: Text(
          'FAQ',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white), // Mengatur warna ikon kembali menjadi putih
      ),
      body: ListView.builder(
        itemCount: questions.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: ExpansionTile(
                title: Row(
                  children: [
                    Text(
                      questions[index],
                      style: TextStyle(color: const Color.fromARGB(255, 6, 6, 6)),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_drop_down, color: Colors.white),
                  ],
                ),
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          answers[questions[index]]!['text'],
                          style: TextStyle(fontSize: 16.0),
                        ),
                        SizedBox(height: 10),
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
          );
        },
      ),
    );
  }
}
