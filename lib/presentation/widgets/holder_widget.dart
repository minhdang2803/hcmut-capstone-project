import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_typography.dart';
import 'rounded_elevated_button.dart';

class HolderWidget extends StatelessWidget {
  const HolderWidget({
    Key? key,
    this.message,
    required this.asset,
    this.onRetry,
  }) : super(key: key);

  final String asset;
  final String? message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          asset,
          width: 0.5.sw,
          height: 0.5.sw,
        ),
        SizedBox(height: 10.r),
        message != null
            ? Column(
                children: [
                  Text(
                    message ?? '',
                    style: AppTypography.title,
                  ),
                  SizedBox(height: 10.r),
                ],
              )
            : const SizedBox(),
        if (onRetry != null)
          RoundedElevatedButton(
            label: 'Retry',
            labelStyle: AppTypography.title.copyWith(color: Colors.white),
            width: 100.w,
            height: 44.h,
            radius: 22.r,
            onPressed: onRetry,
          ),
      ],
    );
  }
}
