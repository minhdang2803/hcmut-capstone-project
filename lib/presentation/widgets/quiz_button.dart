import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuizButton extends StatelessWidget {
  const QuizButton({
    super.key,
    required this.text,
    this.iconData,
    this.isBorder = false,
    this.backgroundColor = AppColor.pastelPink,
    this.textColor = Colors.black54,
    this.borderRadius = 20,
    this.width = 150,
    this.height = 57,
    this.splashColor = AppColor.primary,
    this.hightlightColor = AppColor.secondary,
    this.borderColor = Colors.green,
    required this.onTap,
  });
  final bool? isBorder;
  final IconData? iconData;
  final String text;
  final Color? backgroundColor;
  final Color? textColor;
  final double? borderRadius;
  final Color? splashColor;
  final Color? hightlightColor;
  final Color? borderColor;
  final double? width;
  final double? height;
  final void Function()? onTap;

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
              border: isBorder == true
                  ? Border.all(
                      style: BorderStyle.solid, width: 2, color: borderColor!)
                  : null,
              borderRadius: BorderRadius.circular(borderRadius!),
            ),
            child: Center(
              child: iconData != null
                  ? Icon(
                      iconData,
                      color: textColor,
                    )
                  : Text(
                      text,
                      textAlign: TextAlign.center,
                      style: AppTypography.title.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15.h,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
