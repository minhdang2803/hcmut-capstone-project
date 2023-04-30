import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/utils/word_processing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/quiz_picture.dart';

class ReviewPartOne extends StatelessWidget {
  const ReviewPartOne({
    super.key,
    required this.index,
    required this.text,
    required this.correctAnswer,
    required this.imgUrl,
    required this.userAnser,
  });
  final int index;
  final String text;
  final String correctAnswer;
  final String userAnser;
  final String imgUrl;
  @override
  Widget build(BuildContext context) {
    final wordProcessing = WordProcessing.instance();
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.defaultBorder),
          borderRadius: BorderRadius.circular(20.r),
          color: AppColor.primary,
        ),
        padding: EdgeInsets.all(10.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${index + 1}: ",
              style: AppTypography.body,
            ),
            10.verticalSpace,
            QuizPicture(
              imageUrl: imgUrl,
              isLocal: false,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            10.verticalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                      text: "Transcript: ",
                      style: AppTypography.title
                          .copyWith(color: AppColor.mainPink),
                      children: wordProcessing.createTextSpans(
                          context, text, AppTypography.title)),
                ),
                10.verticalSpace,
                Text.rich(TextSpan(
                    text: "Answer: ",
                    style:
                        AppTypography.title.copyWith(color: AppColor.mainPink),
                    children: [
                      TextSpan(text: correctAnswer, style: AppTypography.title)
                    ])),
                5.verticalSpace,
                Text.rich(TextSpan(
                    text: "Your answer: ",
                    style:
                        AppTypography.title.copyWith(color: AppColor.mainPink),
                    children: [
                      TextSpan(text: userAnser, style: AppTypography.title)
                    ])),
              ],
            )
          ],
        ),
      ),
    );
  }
}
