import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnswerPartFive extends StatelessWidget {
  const AnswerPartFive({
    super.key,
    required this.index,
    required this.text,
    required this.answer,
    required this.correctAnswer,
  });
  final int index;
  final String text;
  final List<String> answer;
  final String correctAnswer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(width: 1, color: AppColor.defaultBorder),
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
            const Divider(
              thickness: 1,
              color: AppColor.defaultBorder,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(
                    text: "Question: ",
                    style: AppTypography.title
                        .copyWith(color: AppColor.textPrimary),
                    children: [
                      TextSpan(text: "$text\n", style: AppTypography.title),
                      ...answer
                          .map((e) => TextSpan(
                              text: "$e\n", style: AppTypography.title))
                          .toList()
                    ])),
                Text.rich(TextSpan(
                    text: "Answer: ",
                    style: AppTypography.title
                        .copyWith(color: AppColor.textPrimary),
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
