import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_typography.dart';

class HolderWidget extends StatelessWidget {
  const HolderWidget({
    Key? key,
    required this.message,
    required this.asset,
  }) : super(key: key);

  final String asset;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.r),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          30.verticalSpace,
          Image.asset(
            asset,
            width: 0.5.sw,
            height: 0.5.sw,
          ),
          SizedBox(height: 10.r),
          Text(
            message,
            style: AppTypography.title,
          ),
        ],
      ),
    );
  }
}
