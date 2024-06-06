import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  final List<String> questions = [
    'Apa itu Wallink?',
    'Apa kelebihan Wallink?',
    'Bagaimana cara mengedit link di Wallink?',
    'Bagaimana cara menghapus link di Wallink?',
    'Bagaimana cara membagikan link dari Wallink?',
  ];

  final Map<String, List<Map<String, dynamic>>> answers = {
    'Apa itu Wallink?': [
      {
        'text': 'Wallink adalah aplikasi manajemen dan manajemen tautan digital. Aplikasi ini menyediakan fitur-fitur seperti penyimpanan link, kategorisasi link, fitur pencarian, dan mampu berintegrasi dengan browser lain. Aplikasi Wallink dirancang untuk memenuhi kebutuhan dan preferensi Generasi Z dalam mengelola tautan digitalnya, dengan fokus pada efektivitas, efisiensi, dan interaksi pengguna yang minimal.',
      },
    ],
    'Apa kelebihan Wallink?': [
      {
        'text':
        '1. Tampilan terstruktur dan mudah dipahami.\n'
        '2. Catat tautan dengan kategori dan subkategori.\n'
        '3. Pencarian dan akses cepat.\n'
      },
    ],
    'Bagaimana cara mengedit link di Wallink?': [
      {
        'text': '1. Pada bagian SubCategory klik ikon arrow down.',
      },
      {
        'image': 'assets/faq1.png',
      },
      {
        'text':
        '1. Pada bagian kategori, terdapat link yang sudah Anda masukkan.\n'
        '2. Geser link yang ingin Anda edit ke kiri.\n'
        '3. Ketuk ikon edit berwarna kuning.\n'
      },
      {
        'image': 'assets/faq2.png',
      },
      {
        'text':
        '5. Lakukan perubahan yang diperlukan pada deskripsi link maupun URL.\n'
        '6. Ketuk tombol “Submit” untuk menyimpan perubahan Anda.\n'
      },
      {
        'image': 'assets/faq3.png',
      },
    ],
    'Bagaimana cara menghapus link di Wallink?': [
      {
        'text': '1. Pada bagian SubCategory klik ikon arrow down.',
      },
      {
        'image': 'assets/faq1.png',
      },
      {
        'text':
        '1. Pada bagian kategori, terdapat link yang sudah Anda masukkan.\n'
        '2. Geser link yang ingin Anda hapus ke kiri.\n'
        '3. Ketuk ikon hapus berwarna merah.\n'
      },
      {
        'image': 'assets/faq2.png',
      },
      {
        'text':
        '5. Konfirmasi penghapusan tautan dengan mengetuk tombol “Yes” pada pop-up notifikasi.\n'
        '6. KJika Anda ingin membatalkan penghapusan, ketuk tombol “Cancel” pada pop-up notifikasi.\n'
      },
      {
        'image': 'assets/faq4.png',
      },
    ],
    'Bagaimana cara membagikan link dari Wallink?': [
      {
        'text': 
        '1. Tekan lama pada bagian SubCategory untuk memunculkan ikon Share SubCategory di bagian bawah.\n'
        '2. Ketuk ikon tersebut untuk membagikan SubCategory ke orang lain melalui berbagai platform.\n'
      },
      {
        'image': 'assets/faq5.png',
      },
      
    ],
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
                      children: answers[questions[index]]!.map((answer) {
                        if (answer['text'] != null) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                bottom: 16.0, left: 16.0, right: 16.0),
                            child: Text(
                              answer['text'],
                              style: const TextStyle(
                                fontFamily: 'sharp',
                                fontSize: 13.0,
                                color: Color.fromARGB(137, 13, 13, 13),
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          );
                        } else if (answer['image'] != null) {
                          return Center(
                            child: Image.asset(
                              answer['image'],
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.contain, // Display image proportionally without being cut off
                            ),
                          );
                        }
                        return SizedBox.shrink(); // Return an empty widget if neither text nor image is present
                      }).toList(),
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
