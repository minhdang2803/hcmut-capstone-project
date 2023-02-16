
import 'package:bke/bloc/quiz/quiz/quiz_cubit.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class QuizDoneScreen extends StatelessWidget {
  const QuizDoneScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(context),
            30.verticalSpace,
            _buildPicture(context),
            30.verticalSpace,
            _buildStatistics(context)
          ],
        ),
      ),
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
          Text(
            'Chúc mừng bạn!',
            style:
                AppTypography.subHeadline.copyWith(fontWeight: FontWeight.w700),
          ),
          const Spacer(flex: 1),
          IconButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<QuizCubit>().exit();
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

  Widget _buildPicture(BuildContext context) {
    return Container(
      width: 327.r,
      height: 318.r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: AppColor.mainPink,
      ),
      child: Padding(
        padding: EdgeInsets.all(20.r),
        child: Column(
          children: [
            SvgPicture.asset(
              "assets/texture/trophy.svg",
              fit: BoxFit.cover,
              width: 214.r,
              height: 158.r,
            ),
            10.verticalSpace,
            BlocBuilder<QuizCubit, QuizState>(
              builder: (context, state) {
                return Text(
                  "Bạn hoàn thành cấp độ ${state.quizId}",
                  style: AppTypography.subHeadline.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w700),
                );
              },
            ),
            20.verticalSpace,
            QuizButton(
              text: "Cấp độ tiếp theo",
              onTap: () {},
              width: 237.r,
              height: 56.r,
              textColor: Colors.white,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics(BuildContext context) {
    return Container(
      width: 327.r,
      height: 121.r,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Column(
              children: [
                Text(
                  "Đáp án đúng",
                  style: AppTypography.title.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: AppColor.darkGray,
                  ),
                ),
                BlocBuilder<QuizCubit, QuizState>(
                  builder: (context, state) {
                    return Text(
                      "${state.totalCorrect} đáp án",
                      style: AppTypography.title.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Column(
              children: [
                Text(
                  "Hoàn thành",
                  style: AppTypography.title.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: AppColor.darkGray,
                  ),
                ),
                BlocBuilder<QuizCubit, QuizState>(
                  builder: (context, state) {
                    return Text(
                      "${((state.totalCorrect! / state.total!) * 100).toStringAsFixed(0)} %",
                      style: AppTypography.title.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  "Hoàn thành",
                  style: AppTypography.title.copyWith(
                    fontSize: 25,
                    fontWeight: FontWeight.w700,
                    color: AppColor.darkGray,
                  ),
                ),
                BlocBuilder<QuizCubit, QuizState>(
                  builder: (context, state) {
                    return Text(
                      "${((state.totalCorrect! / state.total!) * 100).toStringAsFixed(0)} %",
                      style: AppTypography.title.copyWith(
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
