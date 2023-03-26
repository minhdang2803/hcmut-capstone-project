import 'package:bke/bloc/countdown_cubit/count_down_cubit.dart';
import 'package:bke/bloc/toeic/toeic_cubit.dart';
import 'package:bke/data/services/audio_service.dart';
import 'package:bke/presentation/pages/toeic_test/toeics.dart';
import 'package:bke/presentation/routes/route_name.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToeicPartFiveComponent extends StatefulWidget {
  const ToeicPartFiveComponent({
    super.key,
    required this.animationController,
    required this.audioService,
    this.isReal = false,
  });

  final AnimationController animationController;
  final AudioService audioService;
  final bool? isReal;

  @override
  State<ToeicPartFiveComponent> createState() => _ToeicPartFiveComponentState();
}

class _ToeicPartFiveComponentState extends State<ToeicPartFiveComponent>
    with SingleTickerProviderStateMixin {
  late final Animation<Offset> _slideAnimation;
  late final AnimationController _slideAnimationController;
  bool isPlayed = false;
  @override
  void initState() {
    super.initState();
    _slideAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideAnimationController,
      curve: Curves.easeInOut,
    ));
    _slideAnimationController.forward();
    widget.audioService.play();
    context
        .read<ToeicCubitPartOne>()
        .setTimer(5, widget.isReal!, widget.audioService);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ToeicCubitPartOne, ToeicStatePartOne>(
      listener: (context, state) {
        if (state.status == ToeicStatus.finish) {
          Navigator.pushReplacementNamed(
            context,
            RouteName.resultToeic,
            arguments: ToeicResultPageParam(context),
          );
        }
      },
      builder: (context, state) {
        if (state.status == ToeicStatus.done) {
          return Container(
            decoration: BoxDecoration(
                color: AppColor.primary,
                borderRadius:
                    BorderRadius.only(topLeft: Radius.circular(30.r))),
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                10.verticalSpace,
                _buildTimer(context),
                10.verticalSpace,
                _buildQuestionContent(context),
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.secondary,
            ),
          );
        }
      },
    );
  }

  Widget _buildQuestionContent(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          border: Border.all(width: 1, color: AppColor.defaultBorder),
          color: AppColor.primary,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocBuilder<ToeicCubitPartOne, ToeicStatePartOne>(
              builder: (context, state) {
                return Text(
                  state.part125![state.currentIndex!].text ??
                      "Question${state.currentIndex! + 1}\nNghe và chọn đáp án đúng",
                  style: AppTypography.subHeadline,
                );
              },
            ),
            5.verticalSpace,
            const Divider(thickness: 1, color: AppColor.defaultBorder),
            5.verticalSpace,
            _buildAnswerContent(context)
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerContent(BuildContext context) {
    return BlocBuilder<ToeicCubitPartOne, ToeicStatePartOne>(
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final userAnser =
                  state.part125![state.currentIndex!].answers![index];
              return GestureDetector(
                onTap: () async {
                  await context.read<ToeicCubitPartOne>().checkAnswerPart5(
                        userAnser,
                        index,
                        widget.audioService,
                        _slideAnimationController,
                      );
                },
                child: _buildAnswer(userAnser, index, state),
              );
            },
            separatorBuilder: (context, index) => 10.verticalSpace,
            itemCount: state.part125![state.currentIndex!].answers!.length,
          ),
        );
      },
    );
  }

  Widget _buildAnswer(String text, int index, ToeicStatePartOne currentState) {
    if (currentState.isAnswer125Correct == null) {
      return _buildAnswerUI(text, index, null, currentState);
    } else {
      final correctAnswer =
          currentState.part125![currentState.currentIndex!].correctAnswer!;
      final answerList = currentState
          .part125![currentState.currentIndex!].answers!
          .map((e) => e.substring(0, 1))
          .toList();

      final correctIndex = answerList.indexOf(correctAnswer);
      if (currentState.isAnswer125Correct == true) {
        if (index != correctIndex) {
          return _buildAnswerUI(text, index, null, currentState);
        } else {
          return Row(
            children: [
              _buildAnswerUI(text, index, AppColor.correctColor, currentState),
              10.horizontalSpace,
              Icon(Icons.check, color: Colors.green, size: 25.r)
            ],
          );
        }
      } else {
        if (index == correctIndex) {
          return Row(
            children: [
              _buildAnswerUI(text, index, AppColor.correctColor, currentState),
              10.horizontalSpace,
              Icon(Icons.check, color: Colors.green, size: 25.r)
            ],
          );
        } else if (index == currentState.chosenIndex125) {
          return Row(
            children: [
              _buildAnswerUI(text, index, Colors.red, currentState),
              10.horizontalSpace,
              Icon(Icons.clear, color: Colors.red, size: 25.r)
            ],
          );
        } else {
          return _buildAnswerUI(text, index, null, currentState);
        }
      }
    }
  }

  Widget _buildAnswerUI(
      String text, int index, Color? color, ToeicStatePartOne currentState) {
    return Align(
      widthFactor: 1,
      heightFactor: 1,
      alignment: Alignment.centerLeft,
      child: Text(
        text.replaceAll(".", ""),
        textAlign: TextAlign.center,
        style: AppTypography.subHeadline,
      ),
    );
  }

  Widget _buildTimer(BuildContext context) {
    if (widget.isReal!) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          BlocConsumer<CountDownCubit, CountDownState>(
            listener: (context, state) async {
              if (state.status == CountDownStatus.done) {
                await context.read<ToeicCubitPartOne>().autoCheckAnswerPart1(
                      widget.audioService,
                      widget.animationController,
                      context,
                    );
              }
            },
            builder: (context, state) {
              return Text(
                "Time ⌛️: ${state.timeLeft}",
                style: AppTypography.subHeadline,
              );
            },
          )
        ],
      );
    } else {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.r),
          child: const SizedBox());
    }
  }
}
