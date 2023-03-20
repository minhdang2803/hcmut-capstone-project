import 'package:auto_size_text/auto_size_text.dart';
import 'package:bke/bloc/cubit/count_down_cubit.dart';
import 'package:bke/bloc/toeic/toeic_cubit.dart';
import 'package:bke/data/models/toeic/toeic_models.dart';
import 'package:bke/data/services/audio_service.dart';
import 'package:bke/presentation/pages/toeic_test/toeics.dart';
import 'package:bke/presentation/routes/route_name.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ToeicPartSixComponent extends StatefulWidget {
  const ToeicPartSixComponent({
    super.key,
    required this.animationController,
    required this.audioService,
    this.isReal = false,
    required this.part,
  });

  final AnimationController animationController;
  final AudioService audioService;
  final bool? isReal;
  final int part;

  @override
  State<ToeicPartSixComponent> createState() => _ToeicPartSixComponentState();
}

class _ToeicPartSixComponentState extends State<ToeicPartSixComponent>
    with TickerProviderStateMixin {
  late final Animation<Offset> _slideAnimation;
  late final AnimationController _slideAnimationController;
  late final TabController _tabController;
  static const tabs = <Tab>[
    Tab(child: FittedBox(child: Text('Đoạn văn'))),
    Tab(child: FittedBox(child: Text('Câu hỏi'))),
  ];
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
    _tabController = TabController(length: tabs.length, vsync: this);
    _slideAnimationController.forward();
    widget.audioService.play();
    context
        .read<ToeicCubitPartOne>()
        .setTimer(widget.part, widget.isReal!, widget.audioService);
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
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildTimer(context),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  child: TabBar(
                    labelStyle: AppTypography.body,
                    labelColor: AppColor.primary,
                    unselectedLabelStyle: AppTypography.body,
                    unselectedLabelColor: AppColor.primary,
                    indicatorColor: AppColor.primary,
                    // indicator: BoxDecoration(
                    //   color: AppColor.primary,
                    //   borderRadius: BorderRadius.circular(16.r),
                    // ),
                    tabs: tabs,
                    controller: _tabController,
                  ),
                ),
                _buildQuestionContent(context),
              ],
            ),
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
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 5.r),
        width: MediaQuery.of(context).size.width * 0.9,
        child: TabBarView(
          controller: _tabController,
          children: [
            _buildContentParagraph(context),
            _buildTestContent(context)
          ],
        ),
      ),
    );
  }

  Widget _buildContentParagraph(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: BlocBuilder<ToeicCubitPartOne, ToeicStatePartOne>(
        builder: (context, state) {
          return Container(
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
              border: Border.all(width: 1, color: AppColor.primary),
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Text(
              state.part3467![state.currentIndex!].text ??
                  "Nghe và chọn đáp án đúng",
              style: AppTypography.title,
              textAlign: TextAlign.justify,
            ),
          );
        },
      ),
    );
  }

  Widget _buildTestContent(BuildContext context) {
    return BlocBuilder<ToeicCubitPartOne, ToeicStatePartOne>(
      builder: (context, state) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              if (index <=
                  state.part3467![state.currentIndex!].questions!.length - 1) {
                final question =
                    state.part3467![state.currentIndex!].questions![index];
                return _buildQuestions(
                  question: question,
                  currentState: state,
                  questionIndex: index,
                );
              } else {
                return 100.verticalSpace;
              }
            },
            separatorBuilder: (context, index) => 20.verticalSpace,
            itemCount:
                state.part3467![state.currentIndex!].questions!.length + 1,
          ),
        );
      },
    );
  }

  Widget _buildQuestions({
    required ToeicQuestionLocal question,
    required ToeicStatePartOne currentState,
    required int questionIndex,
  }) {
    final answerList = question.answers;

    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(width: 1, color: AppColor.primary)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Question: ${questionIndex + 1}",
            style: AppTypography.body,
          ),
          const Divider(thickness: 1, color: AppColor.primary),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, answerIndex) {
              return GestureDetector(
                onTap: () async {
                  await context.read<ToeicCubitPartOne>().checkAnswerPart3(
                        userAnswer: question.answers![answerIndex],
                        questionIndex: questionIndex,
                        answerIndex: answerIndex,
                        audio: widget.audioService,
                        animation: _slideAnimationController,
                        totalQuestion: 4,
                      );
                },
                child: _buildAnswerOptions(
                  questionIndex: questionIndex,
                  question: question,
                  answerIndex: answerIndex,
                  currentState: currentState,
                ),
              );
            },
            separatorBuilder: (context, index) => 5.verticalSpace,
            itemCount: answerList!.length,
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerOptions({
    required ToeicQuestionLocal question,
    required int answerIndex,
    required int questionIndex,
    required ToeicStatePartOne currentState,
  }) {
    final answerContent =
        question.answers![answerIndex].replaceFirst(" ", ") ", 1);

    //case 1: Have not chosen any answer
    if (currentState.isAnswer3467Correct?[questionIndex] == null) {
      return _buildAnswerUI(answerContent, null, currentState);
    } else {
      // get the answer of questions
      final correctAnswer = question.correctAnswer!;
      final answerList = question.answers!.map((e) => e[0]).toList();
      final correctIndex = answerList.indexOf(correctAnswer);

      // Case 2: when user choose correct answer
      if (currentState.isAnswer3467Correct![questionIndex] == true) {
        if (answerIndex != correctIndex) {
          // những câu không chọn sẽ không có tíck
          return _buildAnswerUI(answerContent, null, currentState);
        } else {
          // câu chọn đúng sẽ có tick
          return Row(
            children: [
              _buildAnswerUI(
                  answerContent, AppColor.correctColor, currentState),
              10.horizontalSpace,
              Icon(Icons.check, color: Colors.green, size: 25.r)
            ],
          );
        }
      } else {
        if (answerIndex == correctIndex) {
          return Row(
            children: [
              _buildAnswerUI(
                  answerContent, AppColor.correctColor, currentState),
              10.horizontalSpace,
              Icon(Icons.check, color: Colors.green, size: 25.r),
            ],
          );
        } else if (answerIndex ==
            currentState.chosenIndex3467![questionIndex]) {
          return Row(
            children: [
              _buildAnswerUI(answerContent, Colors.red, currentState),
              10.horizontalSpace,
              Icon(Icons.clear, color: Colors.red, size: 25.r)
            ],
          );
        } else {
          return _buildAnswerUI(answerContent, null, currentState);
        }
      }
    }
  }

  Widget _buildAnswerUI(
      String text, Color? color, ToeicStatePartOne currentState) {
    return SizedBox(
      width: 200.r,
      child: AutoSizeText(
        text.replaceAll(".", ""),
        textAlign: TextAlign.left,
        style: AppTypography.body,
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
                await context.read<ToeicCubitPartOne>().autoCheckAnswerPart3(
                      widget.audioService,
                      _slideAnimationController,
                      context,
                    );
              }
            },
            builder: (context, state) {
              return Text(
                "Time ⌛️: ${state.timeLeft}",
                style: AppTypography.body,
              );
            },
          )
        ],
      );
    } else {
      return SizedBox();
    }
  }
}
