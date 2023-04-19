import 'package:bke/data/models/toeic/toeic_models.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/utils/word_processing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewPartSeven extends StatelessWidget {
  const ReviewPartSeven({
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
    final WordProcessing _wordProcessing = WordProcessing.instance();
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
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
                children: _wordProcessing.createTextSpans(
                  context,
                  text,
                  AppTypography.body,
                ),
              ),
              textAlign: TextAlign.justify,
            ),
            10.verticalSpace,
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                if (index < answer.length) {
                  final toeicLocal = answer[index];
                  return _buildQuestionAndResult(
                      context, toeicLocal, index, _wordProcessing);
                } else {
                  return 100.verticalSpace;
                }
              },
              separatorBuilder: (context, index) => 10.verticalSpace,
              itemCount: answer.length + 1,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionAndResult(BuildContext context, ToeicQuestion toeicLocal,
      int index, WordProcessing wordProcessing) {
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(width: 1, color: AppColor.defaultBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
                children: wordProcessing.createTextSpans(
              context,
              answer[index].text ?? "Question",
              AppTypography.body,
            )),
            textAlign: TextAlign.justify,
          ),
          const Divider(
            color: AppColor.defaultBorder,
            thickness: 1,
          ),
          Text.rich(
            TextSpan(
                style: AppTypography.title.copyWith(color: AppColor.mainPink),
                children: [
                  ...toeicLocal.answers!
                      .map(
                        (e) => TextSpan(
                          // text: "$e\n",
                          children: wordProcessing.createTextSpans(
                            context,
                            e,
                            AppTypography.title,
                          )..add(const TextSpan(text: "\n")),
                          style: AppTypography.title,
                        ),
                      )
                      .toList()
                ]),
          ),
          Text.rich(TextSpan(
              text: "Answer: ",
              style: AppTypography.title.copyWith(color: AppColor.mainPink),
              children: [
                TextSpan(
                    text: toeicLocal.correctAnswer, style: AppTypography.title)
              ])),
          Text.rich(TextSpan(
              text: "User answer: ",
              style: AppTypography.title.copyWith(
                color: AppColor.mainPink,
              ),
              children: [
                TextSpan(
                  text: userAnswer[index],
                  style: AppTypography.title,
                )
              ])),
        ],
      ),
    );
  }
}
