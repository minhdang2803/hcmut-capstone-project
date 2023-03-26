import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';

import '../../../../../data/data_source/local/auth_local_source.dart';
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
    final authLocal = GetIt.I.get<AuthLocalSourceImpl>();
    final user = authLocal.getCurrentUser();

    return Container(
      alignment: Alignment.bottomCenter,
      height: 110.r,
      decoration: BoxDecoration(
        color: AppColor.secondary,
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
                user?.fullName ?? "User",
                style: AppTypography.subHeadline
                    .copyWith(color: AppColor.textPrimary, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
