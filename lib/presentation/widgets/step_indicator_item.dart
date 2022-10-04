import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_color.dart';
import '../theme/app_typography.dart';

class StepIndicatorItem extends StatelessWidget {
  const StepIndicatorItem({
    Key? key,
    required this.step,
    required this.isSelected,
    required this.isLastItem,
    required this.onItemClick,
    this.isSolved,
  }) : super(key: key);

  final int step;
  final bool isSelected;
  final bool isLastItem;
  final VoidCallback onItemClick;
  final bool? isSolved;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onItemClick,
          child: Container(
            width: 36.r,
            height: 36.r,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: AppColor.primary,
                width: 1.5.r,
              ),
              borderRadius: BorderRadius.circular(18.r),
              color: isSelected
                  ? AppColor.primary
                  : (isSolved ?? false ? Colors.green : Colors.white),
            ),
            child: Text(
              '$step',
              style: AppTypography.body.copyWith(
                color: isSelected ? Colors.white : AppColor.primary,
              ),
            ),
          ),
        ),
        if (!isLastItem)
          Container(
            width: 20.r,
            height: 1.2.r,
            color: AppColor.primary,
          ),
      ],
    );
  }
}
