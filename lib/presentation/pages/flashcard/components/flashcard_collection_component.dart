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
        color: AppColor.primary,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          width: 2.r,
          color: AppColor.defaultBorder,
        ),
      ),
      child: Column(
        children: [
          Image(image: AssetImage(imgUrl)),
          AutoSizeText(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.body
                .copyWith(fontSize: 15.r, fontWeight: FontWeight.w500),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
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
        color: AppColor.primary,
        border: Border.all(width: 2.r, color: AppColor.defaultBorder),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          FadeInImage.assetNetwork(
            placeholder: 'assets/images/default_logo.png',
            image: "$imgUrl.png",
            fadeInDuration: const Duration(milliseconds: 350),
            fit: BoxFit.contain,
            placeholderFit: BoxFit.contain,
            imageErrorBuilder: (context, error, stackTrace) => Image.asset(
              width: 160.r,
              height: 70.r,
              'assets/images/default_logo.png',
              fit: BoxFit.contain,
            ),
          ),
          10.verticalSpace,
          AutoSizeText(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.body
                .copyWith(fontSize: 15.r, fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
