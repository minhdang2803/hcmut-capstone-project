import 'package:bke/data/models/toeic/toeic_models.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewPartSix extends StatelessWidget {
  const ReviewPartSix({
    super.key,
    required this.index,
    required this.answer,
    required this.text,
    required this.userAnswer,
  });
  final String text;
  final int index;
  final List<ToeicQuestion> answer;
  final List<String> userAnswer;

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
            Text.rich(
              TextSpan(
                text: "Paragraph To read:\n\n",
                style: AppTypography.title.copyWith(color: AppColor.mainPink),
                children: [
                  TextSpan(
                    text: text,
                    style: AppTypography.body,
                  )
                ],
              ),
            ),
            10.verticalSpace,
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final toeicLocal = answer[index];
                return _buildQuestionAndResult(toeicLocal, index + 1);
              },
              separatorBuilder: (context, index) => 10.verticalSpace,
              itemCount: answer.length,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionAndResult(ToeicQuestion toeicLocal, int index) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(width: 1, color: AppColor.defaultBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Question $index: ",
            style: AppTypography.body,
          ),
          const Divider(
            color: AppColor.defaultBorder,
            thickness: 1,
          ),
          Text.rich(TextSpan(
              style: AppTypography.title.copyWith(color: AppColor.mainPink),
              children: [
                ...toeicLocal.answers!
                    .map((e) =>
                        TextSpan(text: "$e\n", style: AppTypography.title))
                    .toList()
              ])),
          Text.rich(TextSpan(
              text: "Answer: ",
              style: AppTypography.title.copyWith(color: AppColor.mainPink),
              children: [
                TextSpan(
                    text: toeicLocal.correctAnswer, style: AppTypography.title)
              ])),
          Text.rich(TextSpan(
              text: "User answer: ",
              style: AppTypography.title.copyWith(color: AppColor.mainPink),
              children: [
                TextSpan(
                    text: toeicLocal.correctAnswer, style: AppTypography.title)
              ])),
        ],
      ),
    );
  }
}