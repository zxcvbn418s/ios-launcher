import 'package:flutter/services.dart';
import '../models/installed_app.dart';

class AppService {
  static const MethodChannel _channel = MethodChannel('ios_launcher/apps');

  Future<List<InstalledApp>> getInstalledApps() async {
    final result = await _channel.invokeMethod<List<dynamic>>('getInstalledApps');

    if (result == null) {
      return [];
    }

    return result
        .map((item) => InstalledApp.fromMap(item as Map<dynamic, dynamic>))
        .where((app) => app.packageName.isNotEmpty)
        .toList();
  }

  Future<bool> launchApp(String packageName) async {
    final result = await _channel.invokeMethod<bool>(
      'launchApp',
      {
        'packageName': packageName,
      },
    );

    return result ?? false;
  }
}
