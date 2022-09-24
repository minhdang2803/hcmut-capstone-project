import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';

class FeatureItem extends StatelessWidget {
  const FeatureItem({
    Key? key,
    required this.asset,
    required this.label,
    required this.iconSize,
    required this.itemSize,
    this.maxLine = 1,
    this.elevation = 2,
    required this.isFavorite,
    required this.labelSize,
    this.onItemClick,
  }) : super(key: key);

  final String asset;
  final String label;
  final double labelSize;
  final double iconSize;
  final double itemSize;
  final int maxLine;
  final double elevation;
  final bool isFavorite;
  final VoidCallback? onItemClick;

  @override
  Widget build(BuildContext context) {
    return UnconstrainedBox(
      child: GestureDetector(
        onTap: onItemClick,
        behavior: HitTestBehavior.translucent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Card(
                  color: Colors.white,
                  elevation: elevation,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        isFavorite ? (itemSize * 0.1).r : (itemSize / 2)),
                  ),
                  child: SizedBox(
                    width: itemSize,
                    height: itemSize,
                  ),
                ),
                SvgPicture.asset(
                  asset,
                  width: iconSize,
                  height: iconSize,
                  fit: BoxFit.fill,
                  color: isFavorite ? null : AppColor.primary,
                ),
              ],
            ),
            SizedBox(
              height: 2.r,
            ),
            Text(
              label,
              maxLines: maxLine,
              style: AppTypography.bodySmall.copyWith(
                fontSize: labelSize,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
