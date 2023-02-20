import 'package:auto_size_text/auto_size_text.dart';
import 'package:bke/bloc/quiz/quiz/quiz_cubit.dart';
import 'package:bke/bloc/quiz/quiz_timer/quiz_timer_cubit.dart';
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

class _QuizGame01State extends State<QuizGame01> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    _controller.forward();

    context.read<TimerCubit>().startCountdown();
    context.read<TimerCubit>().resetCountdown(10);
    context.read<TimerCubit>().startCountdown();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
    return SlideTransition(
      position: _offsetAnimation,
      child: Container(
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
              BlocConsumer<TimerCubit, TimerState>(
                listener: (context, state) {
                  if (state.durationInSecond == 0 && state.totalLoop! < 9) {
                    _controller.reset();
                    _controller.forward();
                    context.read<QuizCubit>().onSubmitGame1();
                    context.read<TimerCubit>().resetCountdown(10);
                    context.read<TimerCubit>().startCountdown();
                  } else if (state.durationInSecond == 0 &&
                      state.totalLoop! == 9) {
                    context.read<QuizCubit>().onSubmitGame1();
                  }
                },
                builder: (context, state) {
                  return Text(
                    "Time left ⏱️: ${state.durationInSecond}s",
                    style: AppTypography.title.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return BlocBuilder<TimerCubit, TimerState>(
      builder: (context, state) {
        return QuizButton(
          width: MediaQuery.of(context).size.width * 0.95,
          height: 40.h,
          text: "Next",
          textColor: Colors.white,
          backgroundColor: AppColor.primary,
          onTap: () {
            {
              if (state.totalLoop! < 9) {
                _controller.reset();
                _controller.forward();
                context.read<QuizCubit>().onSubmitGame1();
                context.read<TimerCubit>().resetCountdown(10);
                context.read<TimerCubit>().startCountdown();
              } else {
                context.read<TimerCubit>().pauseCountdown();
                context.read<QuizCubit>().onSubmitGame1();
              }
            }
          },
        );
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
          return GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.r,
                  mainAxisSpacing: 10.r,
                  childAspectRatio: 3),
              itemCount: state.quizMC![state.currentIndex!].vocabAns!.length,
              itemBuilder: (context, index) {
                return QuizButton(
                  borderRadius: 20.r,
                  backgroundColor: state.answerCorrectColor![index]
                      ? AppColor.secondary
                      : backgroundColor,
                  height: height,
                  width: width,
                  text: state.quizMC![state.currentIndex!].vocabAns![index]
                      .toCapitalize(),
                  onTap: () {
                    if (state.allowReChoose!) {
                      cubit.onChosenGame1(
                        index,
                        state.quizMC![state.currentIndex!].vocabAns![index],
                      );
                    }
                  },
                );
              });
        },
      ),
    );
  }
}
