import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class NotifController extends GetxController {
  static NotifController get to => Get.find<NotifController>();

  var isActive = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> showNotif(String title, String message, IconData icon,
      Color backgroundColor) async {
    if (!isActive.value) {
      isActive.value = true;
      Get.snackbar(
        title,
        message,
        backgroundColor: backgroundColor,
        colorText: Colors.white,
        icon: Icon(
          icon,
          size: 30,
          color: Colors.white,
        ),
        snackPosition: SnackPosition.TOP, // Notifikasi muncul dari atas
        duration: const Duration(seconds: 2),
        onTap: (_) {
          isActive.value = false;
        },
        snackbarStatus: (status) {
          if (status == SnackbarStatus.CLOSED) {
            isActive.value = false;
          }
        },
        padding: const EdgeInsets.fromLTRB(20, 13, 20, 13),
        titleText: Text(
          title,
          style: GoogleFonts.urbanist(

            fontSize: 18.0, // Ukuran font title
            fontWeight: FontWeight.bold, // Berat font title
            color: Colors.white, // Warna font title
          ),
        ),
        messageText: Text(
          message,
          style: GoogleFonts.urbanist(
            fontSize: 16.0, // Ukuran font message
            color: Colors.white, // Warna font message
          ),
        ),
      );
    }
  }
}
