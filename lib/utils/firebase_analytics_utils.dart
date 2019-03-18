import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:package_info/package_info.dart';

class FA {
  static FirebaseAnalytics analytics;

  static Future<void> setCurrentScreen(
      String screenName, String screenClassOverride) async {
    await analytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenClassOverride,
    );
  }

  static Future<void> setUserId(String id) async {
    await analytics.setUserId(id);
    print('setUserId succeeded');
  }

  static Future<void> setUserProperty(String name, String value) async {
    await analytics.setUserProperty(
      name: name,
      value: value,
    );
    print('setUserProperty succeeded');
  }

  static Future<void> logApiEvent(String type, int status) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    await analytics.logEvent(
      name: 'ap-api',
      parameters: <String, dynamic>{
        'type': type,
        'status': status,
        'version': packageInfo.version,
        'platform': Platform.operatingSystem,
      },
    );
    print('logEvent succeeded');
  }

  static Future<void> logAESErrorEvent(String encryptPassword) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    await analytics.logEvent(
      name: 'aes-error',
      parameters: <String, dynamic>{
        'type': encryptPassword,
        'version': packageInfo.version,
        'platform': Platform.operatingSystem,
      },
    );
    print('log encryptPassword succeeded');
  }

  static Future<void> logCalculateUnits(double seconds) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    await analytics.logEvent(
      name: 'calculate_units_time',
      parameters: <String, dynamic>{
        'time': seconds,
        'version': packageInfo.version,
        'platform': Platform.operatingSystem,
      },
    );
    print('log CalculateUnits succeeded');
  }
}