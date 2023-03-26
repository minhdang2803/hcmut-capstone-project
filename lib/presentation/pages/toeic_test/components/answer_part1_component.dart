import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnswerPartOne extends StatelessWidget {
  const AnswerPartOne({
    super.key,
    required this.index,
    required this.text,
    required this.correctAnswer,
    required this.imgUrl,
  });
  final int index;
  final String text;
  final String correctAnswer;
  final Uint8List imgUrl;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: AppColor.primary,
        ),
        padding: EdgeInsets.all(10.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question ${index+1}: ",
              style: AppTypography.body,
            ),
            10.verticalSpace,
            QuizPicture(
              imgData: imgUrl,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.25,
            ),
            10.verticalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(
                    text: "Transcript: ",
                    style:
                        AppTypography.title.copyWith(color: AppColor.secondary),
                    children: [
                      TextSpan(text: text, style: AppTypography.title)
                    ])),
                10.verticalSpace,
                Text.rich(TextSpan(
                    text: "Answer: ",
                    style:
                        AppTypography.title.copyWith(color: AppColor.secondary),
                    children: [
                      TextSpan(text: correctAnswer, style: AppTypography.title)
                    ])),
              ],
            )
          ],
        ),
      ),
    );
  }
}
