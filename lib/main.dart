import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:wallink_v1/database/app_preferences.dart';
import 'package:wallink_v1/page/onboarding/onboarding.dart';
import 'package:wallink_v1/route_page.dart';
import 'package:wallink_v1/tracker_service.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await (TrackerService()).track("on-open-app", {}, withDeviceInfo: true);

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((_) {
    runApp(const MainApp());
  });

  await (TrackerService()).track("on-load-app", {}, withDeviceInfo: true);
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
                  ? const OnBoarding()
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
