import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

Future<Uint8List> saveImageToLocal(String url) async {
  final ByteData imageData = await NetworkAssetBundle(Uri.parse(url)).load("");
  return imageData.buffer.asUint8List();
}

Future<Uint8List> audioUrlToUint8List(String url) async {
  final response =
      await Dio().get(url, options: Options(responseType: ResponseType.bytes));
  return Uint8List.fromList(response.data);
}

Future<String> saveAudioToDocumentsFromInternet(String audioUrl) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final String path = directory.path;
  final String fileName = audioUrl.split('/').last;
  final File file = File('$path/$fileName');

  final response = await Dio()
      .get(audioUrl, options: Options(responseType: ResponseType.bytes));
  await file.writeAsBytes(response.data);
  return file.path;
}
