import 'package:flutter/material.dart';
import 'package:wallink_v1/route_page.dart';

class SettingConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback saveSettings;

  const SettingConfirmationDialog({
    required this.title,
    required this.message,
    required this.saveSettings,
    Key? key,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: const BorderSide(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      title: const Center(
        child: Text(
          'Warning!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'sharp',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontFamily: 'sharp',
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    border: Border.all(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      fontFamily: 'sharp',
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10), // Spasi antara tombol
              TextButton(
                onPressed: () {
                  saveSettings.call();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RoutePage(
                        selectedIndex: 0,
                      ),
                    ),
                    (Route<dynamic> route) =>
                        false, // Remove all previous routes
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      color: const Color.fromRGBO(5, 105, 220, 1)),
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontFamily: 'sharp',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
