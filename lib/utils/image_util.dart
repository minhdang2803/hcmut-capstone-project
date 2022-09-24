import 'dart:convert';
import 'dart:io' as io;
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class ImageUtil {
  static Future<String> networkImageToBase64(String? imageUrl) async {
    if (imageUrl?.isEmpty ?? true) return '';
    try {
      http.Response response = await http.get(Uri.parse(imageUrl!));
      final bytes = response.bodyBytes;
      return base64Encode(bytes);
    } catch (e) {
      return '';
    }
  }

  static String localImageToBase64(String imagePath) {
    try {
      final bytes = io.File(imagePath).readAsBytesSync();
      return base64Encode(bytes);
    } catch (e) {
      return '';
    }
  }

  static Uint8List imageFromBase64(String base64String) {
    return const Base64Decoder().convert(base64String.split(',').last);
  }
}
