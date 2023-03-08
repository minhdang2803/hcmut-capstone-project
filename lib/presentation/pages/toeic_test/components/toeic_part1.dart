import 'package:bke/bloc/toeic/toeic_cubit.dart';
import 'package:bke/data/models/toeic/toeic_model_local.dart';
import 'package:bke/data/services/audio_service.dart';
import 'package:bke/presentation/pages/toeic_test/toeic_result_page.dart';
import 'package:bke/presentation/routes/route_name.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/app_typography.dart';

class ToeicPartOneComponent extends StatefulWidget {
  const ToeicPartOneComponent({
    super.key,
    required this.questions,
    required this.animationController,
    required this.audioService,
  });
  final List<ToeicQuestionLocal> questions;
  final AnimationController animationController;
  final AudioService audioService;
  @override
  State<ToeicPartOneComponent> createState() => _ToeicPartOneComponentState();
}

class _ToeicPartOneComponentState extends State<ToeicPartOneComponent>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    final state = context.read<ToeicCubitPartOne>().state;
    widget.audioService.setAudio(state.part125![0].mp3Url!);
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
          return Column(
            children: [
              _buildAudioListener(context),
              10.verticalSpace,
              _buildQuestionContent(context),
            ],
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.primary,
            ),
          );
        }
      },
    );
  }

  Widget _buildQuestionContent(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.9,
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<ToeicCubitPartOne, ToeicStatePartOne>(
            builder: (context, state) {
              return Text(
                state.part125![state.currentIndex!].text ??
                    "Nghe và chọn đáp án đúng",
                style: AppTypography.body,
              );
            },
          ),
          5.verticalSpace,
          const Divider(thickness: 1, color: AppColor.primary),
          5.verticalSpace,
          _buildPicture(context),
          5.verticalSpace,
          const Divider(thickness: 1, color: AppColor.primary),
          5.verticalSpace,
          _buildAnswerContent(context)
        ],
      ),
    );
  }

  Widget _buildPicture(BuildContext context) {
    return BlocBuilder<ToeicCubitPartOne, ToeicStatePartOne>(
      builder: (context, state) {
        return QuizPicture(
          imgData: state.part125![state.currentIndex!].imgUrl!,
          width: MediaQuery.of(context).size.width * 0.9,
          height: MediaQuery.of(context).size.height * 0.25,
          isBorder: false,
        );
      },
    );
  }

  Widget _buildAnswerUI(
      String text, int index, Color? color, ToeicStatePartOne currentState) {
    return Align(
      widthFactor: 1,
      heightFactor: 1,
      alignment: Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.all(10.r),
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.black),
        ),
        child: Text(
          text.replaceAll(".", ""),
          textAlign: TextAlign.center,
          style: AppTypography.body,
        ),
      ),
    );
  }

  Widget _buildAnswer(String text, int index, ToeicStatePartOne currentState) {
    if (currentState.isAnswerCorrect == null) {
      return _buildAnswerUI(text, index, null, currentState);
    } else {
      final correctAnswer =
          currentState.part125![currentState.currentIndex!].correctAnswer!;
      final answerList = currentState
          .part125![currentState.currentIndex!].answers!
          .map((e) => e.replaceAll(".", ""))
          .toList();
      final correctIndex = answerList.indexOf(correctAnswer);
      if (currentState.isAnswerCorrect == true) {
        if (index != correctIndex) {
          return _buildAnswerUI(text, index, null, currentState);
        } else {
          return Row(
            children: [
              _buildAnswerUI(text, index, AppColor.correctColor, currentState),
              10.horizontalSpace,
              Text(
                "Đáp án chính xác!",
                style: AppTypography.body,
              )
            ],
          );
        }
      } else {
        if (index == correctIndex) {
          return Row(
            children: [
              _buildAnswerUI(text, index, AppColor.correctColor, currentState),
              10.horizontalSpace,
              Text(
                "Đáp án chính xác!",
                style: AppTypography.body,
              )
            ],
          );
        } else if (index == currentState.chosenIndex) {
          return Row(
            children: [
              _buildAnswerUI(text, index, Colors.red, currentState),
              10.horizontalSpace,
              Text(
                "Sai rồi!",
                style: AppTypography.body,
              )
            ],
          );
        } else {
          return _buildAnswerUI(text, index, null, currentState);
        }
      }
    }
  }

  Widget _buildAnswerContent(BuildContext context) {
    return BlocBuilder<ToeicCubitPartOne, ToeicStatePartOne>(
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.25,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              final userAnser =
                  state.part125![state.currentIndex!].answers![index];
              return GestureDetector(
                onTap: () async {
                  await context
                      .read<ToeicCubitPartOne>()
                      .checkAnswerPart1(userAnser, index, widget.audioService);
                },
                child: _buildAnswer(userAnser, index, state),
              );
            },
            separatorBuilder: (context, index) => 5.verticalSpace,
            itemCount: state.part125![state.currentIndex!].answers!.length,
          ),
        );
      },
    );
  }

  Widget _buildAudioListener(BuildContext context) {
    return BlocBuilder<ToeicCubitPartOne, ToeicStatePartOne>(
      builder: (context, state) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.9,
          decoration: BoxDecoration(
            border: Border.all(color: AppColor.primary),
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              PlayPauseButton(
                controller: widget.animationController,
                onItemClick: () {
                  if (!widget.audioService.player.isPlaying.value) {
                    widget.audioService.play();
                  } else {
                    widget.audioService.stop();
                  }
                },
              ),
              10.horizontalSpace,
              Expanded(
                child: AudioSeekBar(audioPlayer: widget.audioService.player),
              ),
              10.horizontalSpace,
            ],
          ),
        );
      },
    );
  }
}
