import 'package:bke/bloc/toeic/toeic_history/toeic_history_cubit.dart';
import 'package:bke/data/models/toeic/toeic_models.dart';
import 'package:bke/presentation/pages/toeic_test/toeic_instruction_page.dart';
import 'package:bke/presentation/routes/route_name.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../toeic_test/components/part_component.dart';

class StartToeic extends StatefulWidget {
  const StartToeic({Key? key}) : super(key: key);

  @override
  State<StartToeic> createState() => _StartToeic();
}

class _StartToeic extends State<StartToeic> {
  @override
  void initState() {
    super.initState();
    context.read<ToeicHistoryCubit>().getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            BkEAppBar(
              label: "Luyện thi Toeic",
              onBackButtonPress: () => Navigator.pop(context),
            ),
            _buildMainUI(context),
          ],
        ),
      ),
    );
  }

  Widget _buildMainUI(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: AppColor.primary,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r))),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              20.verticalSpace,
              const TextDivider(text: "Luyện tập"),
              _buildParts(context),
              const TextDivider(text: "Lịch sử làm bài"),
              20.verticalSpace,
              _buildHistory(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistory(BuildContext context) {
    return SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.3,
        child: BlocBuilder<ToeicHistoryCubit, ToeicHistoryState>(
          builder: (context, state) {
            if (state.status == ToeicHistoryStatus.loading) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColor.secondary,
                ),
              );
            }
            return ListView.builder(
              itemBuilder: (context, index) {
                final history = state.histories![index];
                return HistoryCard(history: history);
              },
              itemCount: state.histories!.length,
            );
          },
        ));
  }

  Widget _buildParts(BuildContext context) {
    final imgUrls = [
      "assets/texture/part1.svg",
      "assets/texture/part2.svg",
      "assets/texture/part3.svg",
      "assets/texture/part4.svg",
      "assets/texture/part5.svg",
      "assets/texture/part6.svg",
      "assets/texture/part7.svg",
    ];
    final parts = [1, 2, 3, 4, 5, 6, 7];
    final titles = [
      "Mô Tả Hình Ảnh",
      "Hỏi & Đáp",
      "Đoạn Hội Thoại",
      "Bài Nói Chuyện Ngắn",
      "Điền Vào Câu",
      "Điền Vào Đoạn Văn",
      "Đọc Hiểu Đoạn Văn",
    ];
    return Padding(
      padding: EdgeInsets.only(top: 10.r),
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: imgUrls.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
        ),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                RouteName.toeicInstruction,
                arguments: ToeicInstructionParam(
                  imgUrl: imgUrls[index],
                  part: parts[index],
                  title: titles[index],
                  context: context,
                ),
              ).then((value) => context.read<ToeicHistoryCubit>().getHistory());
            },
            child: PartComponent(
              imgUrl: imgUrls[index],
              part: parts[index],
              title: titles[index],
            ),
          );
        },
      ),
    );
  }
}

class HistoryCard extends StatelessWidget {
  HistoryCard({super.key, required this.history});
  final ToeicHistory history;
  final imgUrls = [
    "assets/texture/part1.svg",
    "assets/texture/part2.svg",
    "assets/texture/part3.svg",
    "assets/texture/part4.svg",
    "assets/texture/part5.svg",
    "assets/texture/part6.svg",
    "assets/texture/part7.svg",
  ];
  final parts = [1, 2, 3, 4, 5, 6, 7];
  final titles = [
    "Mô Tả Hình Ảnh",
    "Hỏi & Đáp",
    "Đoạn Hội Thoại",
    "Bài Nói Chuyện Ngắn",
    "Điền Vào Câu",
    "Điền Vào Đoạn Văn",
    "Đọc Hiểu Đoạn Văn",
  ];
  ToeicPart? getScore(ToeicHistoryScore toeicScore) {
    if (toeicScore.part1 != null) {
      return toeicScore.part1;
    } else if (toeicScore.part2 != null) {
      return toeicScore.part2;
    } else if (toeicScore.part3 != null) {
      return toeicScore.part3;
    } else if (toeicScore.part4 != null) {
      return toeicScore.part5;
    } else if (toeicScore.part5 != null) {
      return toeicScore.part5;
    } else if (toeicScore.part6 != null) {
      return toeicScore.part6;
    } else if (toeicScore.part7 != null) {
      return toeicScore.part7;
    } else {
      return null;
    }
  }

  int getPart(ToeicHistoryScore toeicScore) {
    if (toeicScore.part1 != null) {
      return 1;
    } else if (toeicScore.part2 != null) {
      return 2;
    } else if (toeicScore.part3 != null) {
      return 3;
    } else if (toeicScore.part4 != null) {
      return 4;
    } else if (toeicScore.part5 != null) {
      return 5;
    } else if (toeicScore.part6 != null) {
      return 6;
    } else if (toeicScore.part7 != null) {
      return 7;
    } else {
      return 8;
    }
  }

  @override
  Widget build(BuildContext context) {
    int part = getPart(history.score);
    final score = getScore(history.score);
    final percentage = ((score!.noCorrect) / score.total) * 100;
    return ListTile(
      subtitle: const Divider(
        color: AppColor.defaultBorder,
        thickness: 1,
      ),
      leading: SvgPicture.asset(
        imgUrls[part - 1],
        height: 30.r,
        width: 30.r,
        fit: BoxFit.contain,
      ),
      title: Text(
        titles[part - 1],
        style: AppTypography.title,
      ),
      trailing: Text(
        percentage.toStringAsFixed(0).toString() + "%",
        style: AppTypography.title,
      ),
    );
  }
}

class TextDivider extends StatelessWidget {
  const TextDivider({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.r),
      child: Row(
        children: [
          Text(
            text,
            style: AppTypography.title,
          ),
          10.horizontalSpace,
          const Expanded(
            child: Divider(
              color: AppColor.defaultBorder,
              thickness: 1,
            ),
          ),
        ],
      ),
    );
  }
}
