import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatefulWidget {
  const CustomButton({
    super.key,
    this.color = AppColor.secondary,
    required this.title,
    this.width,
    this.height,
    this.borderRadius,
    this.onTap,
    this.isLoading = false,
    this.icon,
  });
  final Color? color;
  final String title;
  final double? width;
  final double? height;
  final double? borderRadius;
  final void Function()? onTap;
  final bool? isLoading;
  final IconData? icon;

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? 327.w,
      height: widget.height ?? 50.h,
      decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(widget.borderRadius ?? 20.r)),
      child: ElevatedButton(
        onPressed: widget.onTap,
        style: ButtonStyle(
            elevation: MaterialStateProperty.all<double>(0.0),
            backgroundColor: MaterialStateProperty.all<Color>(widget.color!),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ))),
        child: widget.isLoading!
            ? const CircularProgressIndicator(
                color: Colors.white,
              )
            : widget.icon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [Icon(widget.icon, size: 24.r), _buildText()],
                  )
                : _buildText(),
      ),
    );
  }

  Text _buildText() {
    return Text(
      widget.title,
      textAlign: TextAlign.center,
      style: AppTypography.title.copyWith(
        color: AppColor.textPrimary,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
