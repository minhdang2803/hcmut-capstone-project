import 'package:auto_size_text/auto_size_text.dart';
import 'package:bke/bloc/quiz/cubit/quiz_map_cubit_cubit.dart';
import 'package:bke/data/models/quiz/quiz_model.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:bke/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({
    super.key,
    this.level,
    this.numberOfQuestions,
    this.gameType,
  });
  final int? level;
  final int? numberOfQuestions;
  final GameType? gameType;
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animationEaseIn;
  late final Animation<double> _animationEaseOut;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..forward();

    _animationEaseIn = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _animationEaseOut = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: _buildAppbar(),
      body: SafeArea(
        bottom: false,
        child: BlocBuilder<QuizMapCubit, QuizMapState>(
          // selector: (state) => state.status == QuizStatus.done,
          builder: (context, state) {
            if (state.status == QuizStatus.loading ||
                state.status == QuizStatus.initial) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: _buildLoadingSkeleton(),
              );
            } else {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: _buildMainUI(context),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildMainUI(BuildContext context) {
    return Column(
      children: [
        _buildProcessBarAndTime(),
        30.verticalSpace,
        _buildQuestionArea(context)
      ],
    );
  }

  Widget _buildQuestionArea(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.71,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildPicture(),
          // 20.verticalSpace,
          _buildQuestion(),
          // 20.verticalSpace,
          _buildChoices(),
          // 20.verticalSpace,
          _buildSubmitButton(),
        ],
      ),
    );
  }

  Widget _buildPicture() {
    return BlocBuilder<QuizMapCubit, QuizMapState>(
      builder: (context, state) {
        return QuizPicture(
          imgData: state.quizMC![state.currentIndex!].imgUrl!,
          width: 350.r,
          height: 200.h,
        );
      },
    );
  }

  Widget _buildProcessBarAndTime() {
    return Column(
      children: [
        SizedBox(
          height: 10.h,
          child: BlocBuilder<QuizMapCubit, QuizMapState>(
            builder: (context, state) {
              return LinearProgressIndicator(
                value: (state.currentIndex! + 1) / state.total!,
                backgroundColor: AppColor.pastelPink,
                color: AppColor.mainPink,
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(10.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BlocBuilder<QuizMapCubit, QuizMapState>(
                builder: (context, state) {
                  return Text(
                    "Question: ${state.currentIndex! + 1}/${state.total}",
                    style: AppTypography.title.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  );
                },
              ),
              Text(
                "Time left ⏱️: 10s",
                style: AppTypography.title
                    .copyWith(color: Colors.white, fontWeight: FontWeight.w700),
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return QuizButton(
      width: MediaQuery.of(context).size.width * 0.95,
      height: 40.h,
      text: "Submit",
      textColor: Colors.white,
      backgroundColor: AppColor.primary,
      onTap: () {
        print("hello");
        context.read<QuizMapCubit>().onSubmit();
      },
    );
  }

  Widget _buildQuestion() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(10.r),
      child: BlocBuilder<QuizMapCubit, QuizMapState>(
        builder: (context, state) {
          if (state.status == QuizStatus.done) {
            return AutoSizeText(
              state.quizMC![state.currentIndex!].sentence!,
              textAlign: TextAlign.center,
              style: AppTypography.title.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black54,
                fontSize: 22,
              ),
            );
          } else {
            return Text(
              "This is a question",
              textAlign: TextAlign.center,
              style: AppTypography.title.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.black54,
                fontSize: 20,
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildChoices() {
    double width = 130.h;
    double height = 50.w;
    Color backgroundColor = AppColor.accentBlue;
    return SizedBox(
      width: 341.w,
      height: 100.h,
      child: BlocBuilder<QuizMapCubit, QuizMapState>(
        builder: (context, state) {
          return Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: QuizButton(
                  borderRadius: 20.r,
                  backgroundColor: backgroundColor,
                  height: height,
                  width: width,
                  text: state.quizMC![state.currentIndex!].vocabAns![0]
                      .toCapitalize(),
                  onTap: () => print("object"),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: QuizButton(
                  borderRadius: 20.r,
                  backgroundColor: backgroundColor,
                  height: height,
                  width: width,
                  text: state.quizMC![state.currentIndex!].vocabAns![1]
                      .toCapitalize(),
                  onTap: () => print("object"),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: QuizButton(
                  height: height,
                  width: width,
                  text: state.quizMC![state.currentIndex!].vocabAns![2]
                      .toCapitalize(),
                  borderRadius: 20.r,
                  backgroundColor: backgroundColor,
                  onTap: () => print("object"),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: QuizButton(
                  height: height,
                  width: width,
                  text: state.quizMC![state.currentIndex!].vocabAns![3]
                      .toCapitalize(),
                  borderRadius: 20.r,
                  backgroundColor: backgroundColor,
                  onTap: () => print("object"),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  AppBar _buildAppbar() {
    return AppBar(
      backgroundColor: AppColor.primary,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BackButton(
            color: Colors.white,
            onPressed: () {
              print(context.read<QuizMapCubit>().state);
              Navigator.pop(context);
              context.read<QuizMapCubit>().exit();
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Câu đố cấp độ 1",
              style: AppTypography.subHeadline
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(width: 40.r)
        ],
      ),
      elevation: 0,
    );
  }

  Widget _buildLoadingSkeleton() {
    double width = 130.h;
    double height = 50.w;
    return FadeTransition(
      opacity: _animationEaseOut,
      child: SizedBox(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SkeletonLine(
              style: SkeletonLineStyle(
                height: 15.r,
                borderRadius: BorderRadius.circular(8),
                width: double.infinity,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10.r),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 10.r,
                      borderRadius: BorderRadius.circular(8),
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                  ),
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 10.r,
                      borderRadius: BorderRadius.circular(8),
                      width: MediaQuery.of(context).size.width / 3,
                    ),
                  ),
                ],
              ),
            ),
            30.verticalSpace,
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
              height: MediaQuery.of(context).size.height * 0.71,
              padding: EdgeInsets.all(15.r),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r)),
              child: Column(
                children: [
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      width: 350.r,
                      height: 200.h,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  30.verticalSpace,
                  Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      padding: EdgeInsets.all(10.r),
                      child: SkeletonLine(
                        style: SkeletonLineStyle(
                          height: 15.r,
                          borderRadius: BorderRadius.circular(8),
                          width: MediaQuery.of(context).size.width,
                        ),
                      )),
                  30.verticalSpace,
                  SizedBox(
                    width: 341.w,
                    height: 100.h,
                    child: Stack(
                      children: [
                        Positioned(
                          left: 0,
                          top: 0,
                          child: SkeletonLine(
                            style: SkeletonLineStyle(
                              width: width,
                              height: height,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          right: 0,
                          child: SkeletonLine(
                            style: SkeletonLineStyle(
                              width: width,
                              height: height,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          child: SkeletonLine(
                            style: SkeletonLineStyle(
                              width: width,
                              height: height,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: SkeletonLine(
                            style: SkeletonLineStyle(
                              width: width,
                              height: height,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  30.verticalSpace,
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: 40.h,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
