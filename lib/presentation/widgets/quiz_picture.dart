import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_pixels/image_pixels.dart';

class QuizPicture extends StatelessWidget {
  const QuizPicture({
    super.key,
    // this.imageUrl,
    required this.imgData,
    this.borderRadius = 20,
    this.height = 200,
    this.width = 350,
    this.isBorder = true,
  });
  // final String? imageUrl;
  final Uint8List imgData;
  final double? borderRadius;
  final bool? isBorder;
  final double? width;
  final double? height;
  // final bool? picturesFromLocal;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isBorder! ? Border.all(width: 1.0, color: Colors.grey) : null,
        borderRadius: BorderRadius.circular(borderRadius!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: ImagePixels.container(
          imageProvider: MemoryImage(imgData),
          colorAlignment: Alignment.center,
          child: SizedBox(
            width: width,
            height: height,
            child: Image.memory(imgData, fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }
}
