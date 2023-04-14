import 'package:bke/bloc/toeic/toeic_cubit.dart';
import 'package:bke/bloc/toeic/toeic_history/toeic_history_cubit.dart';
import 'package:bke/data/models/toeic/toeic_models.dart';
import 'package:bke/presentation/pages/toeic_test/components/answer_part7_component.dart';
import 'package:bke/presentation/pages/toeic_test/components/toeic_review_part1.dart';
import 'package:bke/presentation/pages/toeic_test/toeics.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class ReviewToeicParam {
  final BuildContext context;
  final int part;
  final String id;

  ReviewToeicParam({
    required this.context,
    required this.part,
    required this.id,
  });
}

class ToeicReviewPage extends StatefulWidget {
  const ToeicReviewPage({
    super.key,
    required this.part,
    required this.id,
  });
  final int part;
  final String id;
  @override
  State<ToeicReviewPage> createState() => _ToeicReviewPageState();
}

class _ToeicReviewPageState extends State<ToeicReviewPage> {
  int length = 0;
  @override
  Widget build(BuildContext context) {
    return BlocSelector<ToeicHistoryCubit, ToeicHistoryState, bool>(
      selector: (state) {
        return state.status == ToeicHistoryStatus.done;
      },
      builder: (context, isDone) {
        return Scaffold(
            body: SafeArea(
          bottom: false,
          child: isDone ? _buildMainUI(context) : const SizedBox(),
        ));
      },
    );
  }

  Widget _buildMainUI(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: ListView(
        physics: const NeverScrollableScrollPhysics(),
        primary: true,
        children: [
          _buildTopBar(context),
          _buildCorrectAnswers(context),
        ],
      ),
    );
  }

  Widget _buildCorrectAnswers(BuildContext context) {
    return BlocBuilder<ToeicHistoryCubit, ToeicHistoryState>(
      builder: (context, state) {
        WidgetsBinding.instance.addPostFrameCallback(
          (timeStamp) {
            setState(() {
              if ([1, 2, 5].contains(widget.part)) {
                length = state.part125!.length;
              } else {
                length = state.part3467!.length;
              }
            });
          },
        );
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 10.r),
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                List answer;
                if ([1, 2, 5].contains(widget.part)) {
                  answer = state.part125!;
                } else {
                  answer = state.part3467!;
                }
                WidgetsBinding.instance.addPostFrameCallback(
                  (timeStamp) {
                    setState(() => length = answer.length);
                  },
                );
                if (index <= answer.length - 1) {
                  return _getAnswerPart(widget.part, answer, index);
                } else {
                  return 350.verticalSpace;
                }
              },
              itemCount: length,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, //change here don't //worked
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          BlocBuilder<ToeicHistoryCubit, ToeicHistoryState>(
            builder: (context, state) {
              return Text(
                'Xem lại kết quả part ${widget.part}',
                style: AppTypography.subHeadline
                    .copyWith(fontSize: 14.h, fontWeight: FontWeight.w700),
              );
            },
          ),
          const Spacer(flex: 1),
          BlocBuilder<ToeicHistoryCubit, ToeicHistoryState>(
            builder: (context, state) {
              return IconButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                icon: Icon(
                  Icons.clear,
                  size: 25.r,
                ),
              );
            },
          )
        ],
      ),
    );
  }

  Widget _getAnswerPart(int part, List<dynamic> answer, int index) {
    Widget returnWidget;
    switch (part) {
      case 1:
        returnWidget = ReviewPartOne(
          userAnser: answer[index].userAnswer,
          index: index,
          text: answer[index].transcript!,
          correctAnswer: answer[index].correctAnswer!,
          imgUrl: answer[index].imgUrl!,
        );
        break;
      case 2:
        returnWidget = ReviewPartTwo(
          index: index,
          text: answer[index].transcript!,
          correctAnswer: answer[index].correctAnswer!,
          userAnswer: answer[index].userAnswer,
        );
        break;
      case 3:
        returnWidget = ReviewPartThree(
          index: index,
          answer: answer[index].questions!,
          userAnswer: answer[index].userAnswer,
        );
        break;
      case 4:
        returnWidget = ReviewPartThree(
          index: index,
          answer: answer[index].questions!,
          userAnswer: answer[index].userAnswer,
        );
        break;
      case 5:
        returnWidget = ReviewPartFive(
          answer: answer[index].answers!,
          index: index,
          text: answer[index].text!,
          correctAnswer: answer[index].correctAnswer!,
          userAnswer: answer[index].userAnswer,
        );
        break;
      case 6:
        returnWidget = ReviewPartSix(
          text: answer[index].text,
          index: index,
          answer: answer[index].questions!,
          userAnswer: answer[index].userAnswer!,
        );
        break;
      default:
        returnWidget = ReviewPartSeven(
          index: index,
          text: answer[index].text!,
          answer: answer[index].questions!,
          userAnswer: answer[index].userAnswer!,
        );
        break;
    }
    return returnWidget;
  }
}
