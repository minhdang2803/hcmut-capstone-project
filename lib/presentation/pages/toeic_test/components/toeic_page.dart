import 'package:bke/presentation/pages/toeic_test/components/part_component.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StartToeic extends StatefulWidget {
  const StartToeic({Key? key}) : super(key: key);

  @override
  State<StartToeic> createState() => _StartToeic();
}

class _StartToeic extends State<StartToeic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            BkEAppBar(
              label: "Kiểm tra Toeic",
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
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r))),
        width: double.infinity,
        child: _buildParts(context),
      ),
    );
  }

  Widget _buildParts(BuildContext context) {
    final imgUrls = [
      "assets/texture/part1.svg",
      "assets/texture/part2.svg",
      "assets/texture/part3.svg",
      "assets/texture/part4.svg",
      "assets/texture/part5.svg",
      "assets/texture/part6.svg",
      // "assets/texture/part4.svg",
    ];
    final parts = [1, 2, 3, 4, 5, 6];
    final titles = [
      "Mô Tả Hình Ảnh",
      "Hỏi & Đáp",
      "Đoạn Hội Thoại",
      "Bài nói chuyện Ngắn",
      "Điền Vào Câu",
      "Điền Vào Đoạn Văn"
    ];
    return Column(
      children: [
        20.verticalSpace,
        Expanded(
          child: GridView.builder(
              itemCount: imgUrls.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                return PartComponent(
                  imgUrl: imgUrls[index],
                  part: parts[index],
                  title: titles[index],
                );
              }),
        ),
      ],
    );
  }
}
