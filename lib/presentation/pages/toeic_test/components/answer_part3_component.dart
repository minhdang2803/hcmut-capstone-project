import 'package:bke/data/models/toeic/toeic_models.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnswerPartThree extends StatelessWidget {
  const AnswerPartThree({
    super.key,
    required this.index,
    required this.answer,
  });
  final int index;
  final List<ToeicQuestionLocal> answer;

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
              "Audio ${index + 1}: ",
              style: AppTypography.body,
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

  Widget _buildQuestionAndResult(ToeicQuestionLocal toeicLocal, int index) {
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
          10.verticalSpace,
          Text.rich(TextSpan(
              text: "Question: ",
              style: AppTypography.title.copyWith(color: AppColor.textPrimary),
              children: [
                TextSpan(
                    text: "${toeicLocal.text}\n", style: AppTypography.title),
                ...toeicLocal.answers!
                    .map((e) =>
                        TextSpan(text: "$e\n", style: AppTypography.title))
                    .toList()
              ])),
          Text.rich(TextSpan(
              text: "Answer: ",
              style: AppTypography.title.copyWith(color: AppColor.textPrimary),
              children: [
                TextSpan(
                    text: toeicLocal.correctAnswer, style: AppTypography.title)
              ])),
        ],
      ),
    );
  }
}
