import 'package:bke/bloc/toeic/toeic_cubit.dart';
import 'package:bke/data/models/toeic/toeic_models.dart';
import 'package:bke/data/services/audio_service.dart';
import 'package:bke/presentation/pages/toeic_test/toeic_result_page.dart';
import 'package:bke/presentation/routes/route_name.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToeicDoTestPageParam {
  final BuildContext context;
  final int part;
  final String title;
  ToeicDoTestPageParam({
    required this.context,
    required this.part,
    required this.title,
  });
}

class ToeicDoTestPage extends StatefulWidget {
  const ToeicDoTestPage({super.key, required this.part, required this.title});
  final int part;
  final String title;
  @override
  State<ToeicDoTestPage> createState() => _ToeicDoTestPageState();
}

class _ToeicDoTestPageState extends State<ToeicDoTestPage>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  late final AudioService _audio;

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _audio = AudioService();
    _audio.player.isPlaying.listen((isPlaying) {
      isPlaying
          ? _animationController.forward()
          : _animationController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BackButton(
              onPressed: () {
                context.read<ToeicCubitPartOne>().exit();
                Navigator.pop(context);
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                widget.title,
                style: AppTypography.subHeadline
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(width: 35.r)
          ],
        ),
      ),
      body: SafeArea(
        child: BlocBuilder<ToeicCubitPartOne, ToeicStatePartOne>(
          builder: (context, state) {
            return SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  10.verticalSpace,
                  ToeicPartOneComponent(
                    questions: state.part125!,
                    audioService: _audio,
                    animationController: _animationController,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

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
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ToeicCubitPartOne, ToeicStatePartOne>(
      builder: (context, state) {
        return Column(
          children: [
            _buildAudio(),
            10.verticalSpace,
            _buildQuestionContent(context),
          ],
        );
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
      child: BlocListener<ToeicCubitPartOne, ToeicStatePartOne>(
        listener: (context, state) {
          if (state.status == ToeicStatus.finish) {
            Navigator.pushReplacementNamed(
              context,
              RouteName.resultToeic,
              arguments: ToeicResultPageParam(context),
            );
          }
        },
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
                      .checkAnswerPart1(userAnser, index);
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

  Widget _buildAudio() {
    return BlocBuilder<ToeicCubitPartOne, ToeicStatePartOne>(
        builder: (context, state) {
      return _buildAudioListener(
        context,
        state.part125![state.currentIndex!].mp3Url!,
      );
    });
  }

  Widget _buildAudioListener(BuildContext context, String audioUrl) {
    widget.audioService.setAudio(audioUrl);
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
  }
}
