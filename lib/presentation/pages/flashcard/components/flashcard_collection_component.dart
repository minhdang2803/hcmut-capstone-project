import 'package:auto_size_text/auto_size_text.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlashcardComponent extends StatelessWidget {
  const FlashcardComponent({
    Key? key,
    required this.imgUrl,
    required this.title,
  }) : super(key: key);

  final String imgUrl;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          width: 2.r,
          color: AppColor.primary,
        ),
      ),
      child: Column(
        children: [
          Image(image: AssetImage(imgUrl)),
          AutoSizeText(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}

class FlashcardRandomComponent extends StatelessWidget {
  const FlashcardRandomComponent({
    Key? key,
    required this.imgUrl,
    required this.title,
  }) : super(key: key);

  final String imgUrl;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          width: 2.r,
          color: AppColor.primary,
        ),
      ),
      child: Column(
        children: [
          Image.network(
            "$imgUrl.png",
          ),
          AutoSizeText(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.body.copyWith(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
