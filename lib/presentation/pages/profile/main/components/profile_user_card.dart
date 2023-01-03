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
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.white),
                  borderRadius: BorderRadius.all(Radius.circular(40.r))),
              child: Padding(
                padding: EdgeInsets.all(3.r),
                child: Image.asset(
                  'assets/images/default_logo.png',
                  width: 40.r,
                  height: 40.r,
                  fit: BoxFit.cover,
                ),
              ),
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
