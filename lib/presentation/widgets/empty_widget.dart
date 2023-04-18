import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key, this.text, this.paddingHeight});
  final String? text;
  final double? paddingHeight;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: paddingHeight),
        Image(
          image: const AssetImage("assets/images/angry.png"),
          height: 200.r,
          width: 200.r,
        ),
        Text(
          text ?? "Bạn chưa lưu từ vựng nào!",
          style: AppTypography.subHeadline.copyWith(
            color: AppColor.textPrimary,
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }
}
