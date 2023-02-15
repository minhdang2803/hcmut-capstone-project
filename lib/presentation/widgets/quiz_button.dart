import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizButton extends StatelessWidget {
  const QuizButton({
    super.key,
    required this.text,
    this.backgroundColor = AppColor.pastelPink,
    this.textColor = Colors.black54,
    this.borderRadius = 20,
    this.width = 150,
    this.height = 57,
    this.splashColor = AppColor.primary,
    this.hightlightColor = AppColor.secondary,
    required this.onTap,
  });
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final Color? splashColor;
  final Color? hightlightColor;

  final double? width;
  final double? height;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius!),
      child: Material(
        child: InkWell(
          highlightColor: hightlightColor!.withOpacity(0.3),
          splashColor: splashColor!.withOpacity(0.4),
          onTap: onTap,
          child: Ink(
            width: width,
            height: height,
            padding: EdgeInsets.all(10.r),
            decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(borderRadius!)),
            child: Center(
              child: Text(
                text,
                textAlign: TextAlign.center,
                style: AppTypography.subHeadline.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
