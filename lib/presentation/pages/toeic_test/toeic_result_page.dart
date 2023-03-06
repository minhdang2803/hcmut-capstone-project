import 'dart:typed_data';

import 'package:bke/bloc/toeic/toeic_cubit.dart';
import 'package:bke/bloc/toeic/toeic_part/toeic_part_cubit.dart';
import 'package:bke/data/models/toeic/toeic_models.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../theme/app_typography.dart';

class ToeicResultPageParam {
  final BuildContext context;
  ToeicResultPageParam(this.context);
}

class ToeicResultPage extends StatelessWidget {
  const ToeicResultPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ToeicCubitPartOne, ToeicStatePartOne, bool>(
      selector: (state) {
        return state.status == ToeicStatus.finish;
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
          10.verticalSpace,
          _buildStatisticContent(context),
          20.verticalSpace,
          _buildCorrectAnswers(context),
        ],
      ),
    );
  }

  Widget _buildCorrectAnswers(BuildContext context) {
    return BlocBuilder<ToeicCubitPartOne, ToeicStatePartOne>(
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: AppColor.neutralGrey,
          ),
          child: SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              // physics: const ScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                List answer;
                if ([1, 2, 5].contains(state.part)) {
                  answer = state.part125! as List<ToeicQuestionLocal>;
                } else {
                  answer = state.part3467! as List<ToeicGroupQuestionLocal>;
                }
                if (index <= state.totalQuestion! - 1) {
                  return AnswerPartOne(
                    index: index,
                    text: answer[index].transcript!,
                    correctAnswer: answer[index].correctAnswer!,
                    imgUrl: answer[index].imgUrl!,
                  );
                } else {
                  return 350.verticalSpace;
                }
              },
              itemCount: state.totalQuestion! + 1,
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatisticContent(BuildContext context) {
    final titles = [
      "Mô Tả Hình Ảnh",
      "Hỏi & Đáp",
      "Đoạn Hội Thoại",
      "Bài Nói Chuyện Ngắn",
      "Điền Vào Câu",
      "Điền Vào Đoạn Văn",
      "Đọc Hiểu Đoạn Văn",
    ];
    final imgUrls = [
      "assets/texture/part1.svg",
      "assets/texture/part2.svg",
      "assets/texture/part3.svg",
      "assets/texture/part4.svg",
      "assets/texture/part5.svg",
      "assets/texture/part6.svg",
      "assets/texture/part7.svg",
    ];
    return BlocBuilder<ToeicCubitPartOne, ToeicStatePartOne>(
      builder: (context, state) {
        return Align(
          alignment: Alignment.center,
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.all(20.r),
                width: MediaQuery.of(context).size.width * 0.9,
                height: MediaQuery.of(context).size.height * 0.3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: AppColor.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Part ${state.part}",
                          style: AppTypography.title.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        ),
                        5.verticalSpace,
                        Text(
                          titles[state.part! - 1],
                          style: AppTypography.title.copyWith(
                              color: Colors.white, fontWeight: FontWeight.w700),
                        )
                      ],
                    ),
                    10.verticalSpace,
                    SvgPicture.asset(
                      imgUrls[state.part! - 1],
                      width: 100.r,
                      height: 50.r,
                      // height: 50.r,
                    )
                  ],
                ),
              ),
              Positioned(
                bottom: 0,
                left: 20.r,
                right: 20.r,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.1,
                  height: MediaQuery.of(context).size.height * 0.18,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r),
                    ),
                    color: AppColor.mainPink,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 20.r,
                child: SvgPicture.asset("assets/texture/card_texture.svg"),
              ),
              Positioned(
                bottom: 20.r,
                left: 40.r,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildStatistic(context, state),
                    10.horizontalSpace,
                    SizedBox(
                      width: 130.r,
                      child: Text(
                        "You have correct ${state.totalCorrect} over ${state.totalQuestion} questions",
                        style: AppTypography.title.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatistic(BuildContext context, ToeicStatePartOne state) {
    return SizedBox(
      width: 100.r,
      height: 100.r,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
            minimum: 0,
            maximum: state.totalQuestion!.toDouble(),
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            axisLineStyle: AxisLineStyle(
              thickness: 0.2,
              cornerStyle: CornerStyle.bothFlat,
              color: AppColor.pastelPink.withOpacity(0.5),
              thicknessUnit: GaugeSizeUnit.factor,
            ),
            pointers: <GaugePointer>[
              RangePointer(
                value: state.totalCorrect!.toDouble(),
                width: 0.2,
                sizeUnit: GaugeSizeUnit.factor,
                cornerStyle: CornerStyle.bothCurve,
                color: Colors.white,
                enableAnimation: true,
                animationDuration: 1000,
                animationType: AnimationType.bounceOut,
              ),
            ],
            annotations: <GaugeAnnotation>[
              GaugeAnnotation(
                positionFactor: 0.1,
                angle: 90,
                widget: Text('${state.totalCorrect} / ${state.totalQuestion}',
                    style: AppTypography.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    )),
              )
            ])
      ]),
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
          BlocBuilder<ToeicCubitPartOne, ToeicStatePartOne>(
            builder: (context, state) {
              return Text(
                'Xem lại kết quả part ${state.part} !',
                style: AppTypography.subHeadline
                    .copyWith(fontWeight: FontWeight.w700),
              );
            },
          ),
          const Spacer(flex: 1),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<ToeicCubitPartOne>().exit();
            },
            icon: Icon(
              Icons.clear,
              size: 25.r,
            ),
          )
        ],
      ),
    );
  }
}

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
                        AppTypography.title.copyWith(color: AppColor.primary),
                    children: [
                      TextSpan(text: text, style: AppTypography.title)
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
