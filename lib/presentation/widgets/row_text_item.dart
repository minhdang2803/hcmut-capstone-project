import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/app_color.dart';
import '../theme/app_typography.dart';

class RowTextItem extends StatelessWidget {
  const RowTextItem({
    Key? key,
    required this.assetIcon,
    required this.text,
    this.centerItems = true,
  }) : super(key: key);

  final String assetIcon;
  final String? text;
  final bool centerItems;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment:
          centerItems ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Center(
          child: SizedBox(
            width: 24.r,
            child: Center(
              child: SvgPicture.asset(
                assetIcon,
                height: 20.r,
                width: 20.r,
                fit: BoxFit.contain,
                color: AppColor.primary,
              ),
            ),
          ),
        ),
        SizedBox(width: 16.r),
        Expanded(
          child: Text(
            text ?? '',
            style: AppTypography.body,
          ),
        ),
      ],
    );
  }
}
