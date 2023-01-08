import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../theme/app_typography.dart';

class ProfileSettingItem extends StatelessWidget {
  const ProfileSettingItem({
    Key? key,
    required this.asset,
    required this.label,
    this.iconColor,
    this.onPress,
  }) : super(key: key);

  final String asset;
  final String label;
  final Color? iconColor;
  final VoidCallback? onPress;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onPress,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            asset,
            width: 30.r,
            height: 30.r,
            fit: BoxFit.contain,
            color: iconColor,
          ),
          SizedBox(height: 10.r),
          Text(
            label,
            style: AppTypography.body.copyWith(fontSize: 13.r),
            textAlign: TextAlign.center,
          )
        ],
      ),
    );
  }
}
