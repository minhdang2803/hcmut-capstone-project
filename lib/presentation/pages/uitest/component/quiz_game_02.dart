import 'package:auto_size_text/auto_size_text.dart';
import 'package:bke/bloc/quiz/quiz/quiz_cubit.dart';
import 'package:bke/bloc/quiz/quiz_timer/quiz_timer_cubit.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:bke/utils/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizGame02 extends StatefulWidget {
  const QuizGame02({super.key});

  @override
  State<QuizGame02> createState() => _QuizGame02State();
}

class _QuizGame02State extends State<QuizGame02> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return _buildMainUI();
  }

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildMainUI() {
    return BlocListener<QuizCubit, QuizState>(
      listener: (context, state) {
        if (state.isCorrectGame2 == false) {
          WidgetUtil.showSnackBar(context,
              "Đáp án đúng là ${state.quizMC![state.currentIndex!].answer}");
        }
      },
      child: Column(
        children: [
          _buildProcessBarAndTime(),
          10.verticalSpace,
          _buildQuestionArea(context)
        ],
      ),
    );
  }

  Widget _buildQuestionArea(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.95,
      height: MediaQuery.of(context).size.height * 0.75,
      padding: EdgeInsets.all(15.r),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
      child: SingleChildScrollView(
        child: SlideTransition(
          position: _offsetAnimation,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPicture(),
              20.verticalSpace,
              _buildQuestion(),
              20.verticalSpace,
              _buildAnswer(),
              20.verticalSpace,
              _buildChoices(),
              10.verticalSpace,
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAnswer() {
    return BlocBuilder<QuizCubit, QuizState>(
      builder: (context, state) {
        double getHeight() {
          int length =
              state.quizMC![state.currentIndex!].answer!.split("").length;
          if (length <= 5) {
            return 50.r;
          } else if (length <= 10) {
            return 110.r;
          } else if (length <= 15) {
            return 160.r;
          } else {
            return 150.r;
          }
        }

        return SizedBox(
          width: MediaQuery.of(context).size.width * 0.75,
          height: getHeight(),
          child: BlocBuilder<QuizCubit, QuizState>(
            builder: (context, state) {
              return GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 10.r,
                  crossAxisSpacing: 10.r,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  return QuizButton(
                    isBorder: true,
                    borderColor: state.isCorrectGame2 == null
                        ? Colors.transparent
                        : state.isCorrectGame2!
                            ? Colors.green
                            : Colors.red,
                    text: state.answerChoosen![index],
                    onTap: () {
                      context.read<QuizCubit>().onAnswerGame2Clear(index);
                    },
                  );
                },
                // separatorBuilder: (context, index) => 10.horizontalSpace,
                itemCount:
                    state.quizMC![state.currentIndex!].answer!.split("").length,
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildChoices() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height * 0.25,
      child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 12,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            mainAxisSpacing: 10.r,
            crossAxisSpacing: 20.r,
            childAspectRatio: 1,
          ),
          itemBuilder: (context, index) {
            return BlocBuilder<QuizCubit, QuizState>(
              builder: (context, state) {
                final text =
                    state.quizMC![state.currentIndex!].vocabAns![index];
                return QuizButton(
                  hightlightColor: AppColor.primary,
                  backgroundColor: AppColor.accentBlue,
                  splashColor: AppColor.secondary,
                  text: text,
                  onTap: () {
                    context.read<QuizCubit>().onChosenGame2(index, text);
                  },
                );
              },
            );
          }),
    );
  }

  Widget _buildSubmitButton() {
    return Row(
      children: [
        Expanded(
          child: BlocBuilder<TimerCubit, TimerState>(
            builder: (context, state) {
              return QuizButton(
                height: 40.h,
                text: "Submit",
                textColor: Colors.white,
                backgroundColor: AppColor.primary,
                onTap: () async {
                  if (state.totalLoop! < 8) {
                    await context.read<QuizCubit>().onSubmitGame2(_controller);
                    context.read<TimerCubit>().resetCountdown(30);
                    context.read<TimerCubit>().startCountdown();
                  } else {
                    context.read<TimerCubit>().pauseCountdown();
                    await context.read<QuizCubit>().onSubmitGame2(null);
                  }
                },
              );
            },
          ),
        ),
        10.horizontalSpace,
        QuizButton(
          width: 50.r,
          text: "Clear",
          onTap: () => context.read<QuizCubit>().onGame2Erase(),
          iconData: Icons.backspace,
        ),
      ],
    );
  }

  Widget _buildQuestion() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(10.r),
      child: BlocBuilder<QuizCubit, QuizState>(
        builder: (context, state) {
          if (state.status == QuizStatus.done) {
            final question = state.quizMC![state.currentIndex!].sentence!;
            return AutoSizeText(
              "$question ?",
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
                  if (state.durationInSecond == 0 && state.totalLoop! < 8) {
                    context.read<QuizCubit>().onSubmitGame2(_controller);
                    context.read<TimerCubit>().resetCountdown(30);
                    context.read<TimerCubit>().startCountdown();
                  } else if (state.durationInSecond == 0 &&
                      state.totalLoop! == 8) {
                    context.read<QuizCubit>().onSubmitGame2(null);
                  }
                },
                builder: (context, state) {
                  return Text(
                    "Time left ⏱️: ${state.durationInSecond}s",
                    style: AppTypography.title.copyWith(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
