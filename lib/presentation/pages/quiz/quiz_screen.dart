import 'package:bke/bloc/quiz/quiz/quiz_cubit.dart';
import 'package:bke/bloc/quiz/quiz_timer/quiz_timer_cubit.dart';
import 'package:bke/data/models/quiz/quiz_model.dart';
import 'package:bke/presentation/pages/quiz/component/quiz_game_01.dart';
import 'package:bke/presentation/pages/quiz/component/quiz_game_02.dart';
// import 'package:bke/presentation/pages/uitest/component/quiz_game_01.dart';
// import 'package:bke/presentation/pages/uitest/component/quiz_game_02.dart';
import 'package:bke/presentation/routes/route_name.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/utils/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

class QuizScreenParam {
  int level;
  BuildContext context;
  QuizScreenParam(this.context, this.level);
}

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      appBar: _buildAppbar(),
      body: SafeArea(
        bottom: false,
        child: BlocConsumer<QuizCubit, QuizState>(
          listener: (context, state) {
            if (state.status == QuizStatus.finished) {
              Navigator.pushReplacementNamed(context, RouteName.quizDoneScreen,
                  arguments: context);
            }
          },
          builder: (context, state) {
            if (state.status == QuizStatus.loading) {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: _buildLoadingSkeleton(),
              );
            } else if (state.status == QuizStatus.finished) {
              return const Center(
                  child: CircularProgressIndicator(color: Colors.white));
            } else {
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: state.type == GameType.type1
                    ? const QuizGame01()
                    : const QuizGame02(),
              );
            }
          },
        ),
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
              context.read<TimerCubit>().pauseCountdown();
              WidgetUtil.showDialog(
                context: context,
                title: 'Thoát khỏi màn chơi',
                message: 'Quá trình sẽ bị huỷ bỏ!',
                onAccepted: () => Navigator.pop(context),
                onDismissed: () => context.read<TimerCubit>().resumeCountdown(),
              );
            },
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              "Câu đố cấp độ ${widget.level}",
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
    double height = 55.w;
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
