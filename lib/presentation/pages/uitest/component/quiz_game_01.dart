import 'package:auto_size_text/auto_size_text.dart';
import 'package:bke/bloc/quiz/quiz/quiz_cubit.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:bke/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizGame01 extends StatefulWidget {
  const QuizGame01({super.key});

  @override
  State<QuizGame01> createState() => _QuizGame01State();
}

class _QuizGame01State extends State<QuizGame01> {
  @override
  Widget build(BuildContext context) {
    return _buildMainUI(context);
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
    return BlocBuilder<QuizCubit, QuizState>(
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
          child: BlocBuilder<QuizCubit, QuizState>(
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
              BlocBuilder<QuizCubit, QuizState>(
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
        context.read<QuizCubit>().onSubmitGame1();
      },
    );
  }

  Widget _buildQuestion() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(10.r),
      child: BlocBuilder<QuizCubit, QuizState>(
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
    final cubit = context.read<QuizCubit>();
    return SizedBox(
      width: 341.w,
      height: 100.h,
      child: BlocBuilder<QuizCubit, QuizState>(
        builder: (context, state) {
          return Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: QuizButton(
                  borderRadius: 20.r,
                  backgroundColor:
                      state.isChosen![0] ? AppColor.secondary : backgroundColor,
                  height: height,
                  width: width,
                  text: state.quizMC![state.currentIndex!].vocabAns![0]
                      .toCapitalize(),
                  onTap: () => cubit.onChosen(
                    0,
                    state.quizMC![state.currentIndex!].vocabAns![0],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: QuizButton(
                  borderRadius: 20.r,
                  backgroundColor:
                      state.isChosen![1] ? AppColor.secondary : backgroundColor,
                  height: height,
                  width: width,
                  text: state.quizMC![state.currentIndex!].vocabAns![1]
                      .toCapitalize(),
                  onTap: () => cubit.onChosen(
                    1,
                    state.quizMC![state.currentIndex!].vocabAns![1],
                  ),
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
                  backgroundColor:
                      state.isChosen![2] ? AppColor.secondary : backgroundColor,
                  onTap: () => cubit.onChosen(
                    2,
                    state.quizMC![state.currentIndex!].vocabAns![2],
                  ),
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
                  backgroundColor:
                      state.isChosen![3] ? AppColor.secondary : backgroundColor,
                  onTap: () => cubit.onChosen(
                    3,
                    state.quizMC![state.currentIndex!].vocabAns![3],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
