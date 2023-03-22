import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnswerPartTwo extends StatelessWidget {
  const AnswerPartTwo({
    super.key,
    required this.index,
    required this.text,
    required this.correctAnswer,
  });
  final int index;
  final String text;
  final String correctAnswer;

  List<String> getTranScript(String text) {
    int indexOfQuestion = text.indexOf("?");
    String question = text.substring(0, indexOfQuestion);
    List<String> answers = text.substring(indexOfQuestion + 1).split("(");
    answers.insert(0, question);
    return answers;
  }

  @override
  Widget build(BuildContext context) {
    final List<String> content = getTranScript(text);
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          color: Colors.white,
        ),
        padding: EdgeInsets.all(10.r),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Question $index: ",
              style: AppTypography.body,
            ),
            10.verticalSpace,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(TextSpan(
                    text: "Transcript: ",
                    style:
                        AppTypography.title.copyWith(color: AppColor.primary),
                    children: [
                      TextSpan(
                          text: "${content[0]}?", style: AppTypography.title),
                      TextSpan(
                          text: "${content[1]}\n", style: AppTypography.title),
                      TextSpan(
                          text: "(${content[2]}\n", style: AppTypography.title),
                      TextSpan(
                          text: "(${content[3]}\n", style: AppTypography.title),
                      TextSpan(
                          text: "(${content[4]}", style: AppTypography.title)
                    ])),
                10.verticalSpace,
                Text.rich(TextSpan(
                    text: "Answer: ",
                    style:
                        AppTypography.title.copyWith(color: AppColor.primary),
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
