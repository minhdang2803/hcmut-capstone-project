import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_pixels/image_pixels.dart';

class QuizPicture extends StatelessWidget {
  const QuizPicture({
    super.key,
    required this.imageUrl,
    this.borderRadius = 20,
    this.height = 200,
    this.width = 350,
  });
  final String imageUrl;
  final double? borderRadius;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(width: 1.0, color: Colors.grey),
        borderRadius: BorderRadius.circular(borderRadius!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius!),
        child: ImagePixels.container(
          imageProvider: NetworkImage(imageUrl),
          colorAlignment: Alignment.center,
          child: SizedBox(
            width: width,
            height: height,
            child: Image.network(imageUrl, fit: BoxFit.fill),
          ),
        ),
      ),
    );
  }
}
