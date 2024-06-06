import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wallink_v1/splashscreen.dart';
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
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
