import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/utils/word_processing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReviewPartTwo extends StatelessWidget {
  const ReviewPartTwo({
    super.key,
    required this.index,
    required this.text,
    required this.correctAnswer,
    required this.userAnswer,
  });
  final int index;
  final String text;
  final String correctAnswer;
  final String userAnswer;

  List<String> getTranScript(String text) {
    int indexOfQuestion = text.indexOf("?");
    String question = text.substring(0, indexOfQuestion);
    List<String> answers = text.substring(indexOfQuestion + 1).split("(");
    answers.insert(0, question);
    return answers;
  }

  @override
  Widget build(BuildContext context) {
    final wordProcessing = WordProcessing.instance();
    final List<String> content = getTranScript(text);
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColor.defaultBorder),
          color: AppColor.primary,
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
                Text.rich(
                  TextSpan(
                      text: "Transcript: ",
                      style: AppTypography.title
                          .copyWith(color: AppColor.mainPink),
                      children: [
                        TextSpan(
                          children: wordProcessing.createTextSpans(
                              context, content[0], AppTypography.title)
                            ..add(TextSpan(text: "\n")),
                        ),
                        TextSpan(
                          children: wordProcessing.createTextSpans(
                              context, content[1], AppTypography.title)
                            ..add(TextSpan(text: "\n")),
                        ),
                        TextSpan(
                          children: wordProcessing.createTextSpans(
                              context, content[2], AppTypography.title)
                            ..add(TextSpan(text: "\n")),
                        ),
                        TextSpan(
                          children: wordProcessing.createTextSpans(
                              context, content[3], AppTypography.title)
                            ..add(TextSpan(text: "\n")),
                        ),
                        TextSpan(
                          children: wordProcessing.createTextSpans(
                              context, content[4], AppTypography.title),
                        ),
                        // TextSpan(
                        //     text: "${content[1]}\n",
                        //     style: AppTypography.title),
                        // TextSpan(
                        //     text: "(${content[2]}\n",
                        //     style: AppTypography.title),
                        // TextSpan(
                        //     text: "(${content[3]}\n",
                        //     style: AppTypography.title),
                        // TextSpan(
                        //     text: "(${content[4]}", style: AppTypography.title)
                      ]),
                ),
                10.verticalSpace,
                Text.rich(TextSpan(
                    text: "Answer: ",
                    style:
                        AppTypography.title.copyWith(color: AppColor.mainPink),
                    children: [
                      TextSpan(text: correctAnswer, style: AppTypography.title)
                    ])),
                Text.rich(TextSpan(
                    text: "Your answer: ",
                    style:
                        AppTypography.title.copyWith(color: AppColor.mainPink),
                    children: [
                      TextSpan(text: userAnswer, style: AppTypography.title)
                    ])),
              ],
            )
          ],
        ),
      ),
    );
  }
}
