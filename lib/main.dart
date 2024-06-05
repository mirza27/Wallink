import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:wallink_v1/database/app_preferences.dart';
import 'package:wallink_v1/page/intro_slide_page.dart';
import 'package:wallink_v1/route_page.dart';
import 'package:wallink_v1/tracker_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await (TrackerService()).track("on-open-app", {}, withDeviceInfo: true);

  runApp(const MainApp());

  await (TrackerService()).track("on-load-app", {}, withDeviceInfo: true);

  // Pelacakan saat aplikasi akan ditutup
  WidgetsBinding.instance?.addPostFrameCallback((_) async {
    await (TrackerService()).track("on-close-app", {}, withDeviceInfo: true);
  });
}

class MainApp extends StatelessWidget {
  const MainApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AppPreferences.isFirstTime(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else {
          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final bool? isFirstTime =
                snapshot.data; // ambil dari nilai isFirstTime

            return GetMaterialApp(
              title: 'WALINK',
              home: isFirstTime!
                  ? const IntroSlidePage()
                  : const RoutePage(
                      selectedIndex: 0,
                    ),
              debugShowCheckedModeBanner: false,
            );
          }
        }
      },
    );
  }
}
