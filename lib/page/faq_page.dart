import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  final List<String> questions = [
    'What is Wallink?',
    'What are the advantages of Wallink?',
    'How to edit or delete links in Wallink?',
    'How to delete subcategories in Wallink?',
    'How do you launch a link on Wallink?',
  ];

  final Map<String, Map<String, dynamic>> answers = {
    'What is Wallink?': {
      'text':
          'Wallink is a digital link management and management application. This application provides features such as link storage, link categorization, search features, and is able to integrate with other browsers. The Wallink application is designed to meet the needs and preferences of Generation Z in managing their digital links, with a focus on effectiveness, efficiency and minimal user interaction.',
    },
    'What are the advantages of Wallink?': {
      'text': '1. Structured and easy to understand display.\n'
          '2. Note links with categories and sub-categories.\n'
          '3. Reminder for selected data.\n'
          '4. Automatic category (Auto fill for selected link domains).\n'
          '5. Quick search and access.',
      'image': null,
    },
    'How to edit or delete links in Wallink?': {
      'text':
          'Click the pencil icon to edit the link.\nClick the trash icon to delete the link.',
      'image': 'assets/editdelete.jpg',
    },
    'How to delete subcategories in Wallink?': {
      'text':
          '1. Long press and hold the sub category until additional options appear.\n2. Locate and tap the trash can icon or delete icon that indicates the sub category deletion function.\n3. Upon clicking the delete icon, a warning dialog box will pop up asking for confirmation to proceed with deleting the sub category.\n4. Within the warning dialog box, click the "Delete" button to confirm and finalize the deletion process.',
      'image': null,
    },
    'How do you launch a link on Wallink?': {
      'text': 'Step 1:\nFind the link you want to launch. This link can be found under SubCategory > Click Category > Link.\n'
          'Step 2:\nClick the link. This link will open your web browser and launch the link automatically.',
      'image': 'assets/deletesubcategory.jpg',
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(201, 226, 255, 1),
        title: const Text(
          'FAQ',
          style: TextStyle(
            fontFamily: 'sharp',
            color: Color.fromRGBO(5, 105, 220, 1),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.back,
            size: 30,
            color: Color.fromRGBO(5, 105, 220, 1),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
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
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: questions.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16.0, 3.0, 16.0, 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                          width: 1,
                          color: const Color.fromARGB(255, 5, 105, 220)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ExpansionTile(
                      shape: const Border(),
                      title: Text(
                        questions[index],
                        style: const TextStyle(
                          fontFamily: 'sharp',
                          fontSize: 15,
                          color: Color.fromARGB(255, 6, 6, 6),
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 16.0, left: 16.0, right: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                answers[questions[index]]!['text'],
                                style: const TextStyle(
                                  fontFamily: 'sharp',
                                  fontSize: 13.0,
                                  color: Color.fromARGB(137, 13, 13, 13),
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                              if (answers[questions[index]]!['image'] != null)
                                Center(
                                  child: Image.asset(
                                    answers[questions[index]]!['image'],
                                    width: MediaQuery.of(context).size.width,
                                    fit: BoxFit
                                        .contain, // Menampilkan gambar secara proporsional tanpa terpotong
                                  ),
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
          ),
        ],
      ),
    );
  }
}
