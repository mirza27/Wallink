import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotifController extends GetxController {
  static NotifController get to => Get.find<NotifController>();

  var isActive = false.obs;

  @override
  void onInit() {
    super.onInit();
  }

  Future<void> showNotif(String title, String message, IconData icon, Color backgroundColor) async {
    if (!isActive.value) {
      isActive.value = true;
      Get.snackbar(
        title,
        message,
        backgroundColor: backgroundColor,
        colorText: Colors.white,
        icon: Icon(icon),
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
      );
    }
  }
}
