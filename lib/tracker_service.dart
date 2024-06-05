import 'dart:convert';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:uuid/uuid.dart';
import 'package:wallink_v1/database/app_preferences.dart';

class TrackerService {
  static const String trackerEndpoint = '/api/v1/products/{PRODUCT_ID}/track';

  Future track(
    String target,
    Map<String, String> map, {
    Map content = const {},
    bool withDeviceInfo = false,
  }) async {
    final environment = dotenv.get('APP_ENV');
    final user = getUser();

    final productId = dotenv.get('PRODUCT_ID');
    final endpoint = trackerEndpoint.replaceFirst('{PRODUCT_ID}', productId);
    final url = getUrl(endpoint);

    if (withDeviceInfo) {
      content = {}
        ..addAll(content)
        ..addAll({
          'device_info': await getDeviceInfo(),
        });
    }

    content = {}
      ..addAll(content)
      ..addAll({
        "app_info": await getAppInfo(),
      });

    // send req
    final response = await (Dio()).post(
      url,
      data: {
        'environment': environment,
        'target': target,
        'content': jsonEncode(content),
        'user': jsonEncode(await user),
      },
    );

    print(response.data);
    print(response.statusCode);
  }

  // FUNCTION LIST ======================
  Future<Map> getUser() async {
    String? userId = await AppPreferences.getUserId();
    // create new uuid for user jika pertama kali
    if (userId == '') {
      AppPreferences.setUserId(const Uuid().v4());
    }

    return {
      'id': await AppPreferences.getUserId(),
    };
  }

  String getUrl(String endpoint) {
    final baseUrl = dotenv.get('BASE_URL');

    return baseUrl + endpoint;
  }

  Future<Map> getAppInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return {
      'app_name': packageInfo.appName,
      'package_name': packageInfo.packageName,
      'version': packageInfo.version,
      'build_number': packageInfo.buildNumber,
    };
  }

  dynamic getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    return androidInfo.data;
  }
}
