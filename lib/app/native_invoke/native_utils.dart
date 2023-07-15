import 'dart:convert';
import 'dart:developer';

import 'package:flutter/services.dart';

class NativeUtils {
  static const channel = MethodChannel('com.tdtrong.mockup.finger_scan');
  static Future<dynamic> fingerScan() async {
    try {
      String? jsonStr = await channel.invokeMethod('start_finger_scan');
      if ((jsonStr ?? '').isNotEmpty) {
        var data = jsonDecode(jsonStr!);
        return data;
      }
    } on PlatformException catch (e) {
      log(e.toString(), name: 'TestTest');
    }
  }
}
