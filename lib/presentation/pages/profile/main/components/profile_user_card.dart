import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../theme/app_color.dart';

class ProfileUserCard extends StatelessWidget {
  const ProfileUserCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        _buildUserScore(context),
      ],
    );
  }

  Container _buildUserScore(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      height: 130.r,
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/peace.png',
              width: 50.r,
              height: 50.r,
              fit: BoxFit.cover,
            ),
            12.horizontalSpace,
            Text(
              "BkE",
              style: AppTypography.superHeadline
                  .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
