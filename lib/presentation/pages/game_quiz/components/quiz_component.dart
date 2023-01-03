import 'package:bke/data/models/quiz/quiz.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'option_component.dart';
import 'question_component.dart';

class QuizComponent extends StatelessWidget {
  final List<Quiz>? quizs;
  final int questionIndex;
  final Function answerQuestion;

  const QuizComponent({
    Key? key,
    required this.quizs,
    required this.answerQuestion,
    required this.questionIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: QuestionComponent(
            quizs?.elementAt(questionIndex).question.toString(),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
                left: 20.w, right: 20.w, bottom: 20.w, top: 0.6.sh),
            child: Stack(
              children: [
                ...(quizs?.elementAt(questionIndex).answers as List<dynamic>)
                    .map((answer) {
                  return quizs
                              ?.elementAt(questionIndex)
                              .answers
                              .indexOf(answer) ==
                          0
                      ? Positioned(
                          top: 0,
                          left: 0,
                          child:
                              OptionComponent(() => answerQuestion(1), answer))
                      : quizs
                                  ?.elementAt(questionIndex)
                                  .answers
                                  .indexOf(answer) ==
                              1
                          ? Positioned(
                              top: 0,
                              right: 0,
                              child: OptionComponent(
                                  () => answerQuestion(1), answer))
                          : quizs
                                      ?.elementAt(questionIndex)
                                      .answers
                                      .indexOf(answer) ==
                                  2
                              ? Positioned(
                                  bottom: 0,
                                  left: 0,
                                  child: OptionComponent(
                                      () => answerQuestion(1), answer))
                              : Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: OptionComponent(
                                      () => answerQuestion(1), answer));
                }).toList()
              ],
            ),
          ),
        ),
      ],
    );
  }
}
