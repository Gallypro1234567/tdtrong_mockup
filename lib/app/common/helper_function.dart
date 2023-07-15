import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';

Future<String> toHashSHA256(File file) async {
  final bytes = await File(file.path).readAsBytes();
  final hash = sha256.convert(bytes);
  return hash.toString();
}

String fileToBase64(File file) {
  List<int> fileBytes = file.readAsBytesSync();
  String base64Image = base64Encode(fileBytes);
  return base64Image;
}