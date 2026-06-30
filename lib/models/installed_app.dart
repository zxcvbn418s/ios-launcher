import 'dart:convert';
import 'dart:typed_data';

class InstalledApp {
  final String name;
  final String packageName;
  final Uint8List iconBytes;

  const InstalledApp({
    required this.name,
    required this.packageName,
    required this.iconBytes,
  });

  factory InstalledApp.fromMap(Map<dynamic, dynamic> map) {
    final iconBase64 = map['icon']?.toString() ?? '';

    return InstalledApp(
      name: map['name']?.toString() ?? 'Unknown',
      packageName: map['packageName']?.toString() ?? '',
      iconBytes: base64Decode(iconBase64),
    );
  }
}
