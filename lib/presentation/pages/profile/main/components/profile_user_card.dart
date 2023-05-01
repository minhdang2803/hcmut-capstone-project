import 'dart:io';

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
    // return Stack(
    //   alignment: Alignment.center,
    //   children: [],
    // );
    return _buildUserScore(context);
  }

  Container _buildUserScore(BuildContext context) {
    final authLocal = GetIt.I.get<AuthLocalSourceImpl>();
    final user = authLocal.getCurrentUser();
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      padding: EdgeInsets.only(top: topPadding),
      alignment: Alignment.bottomCenter,
      height: 110.r + topPadding,
      decoration: BoxDecoration(
        color: AppColor.secondary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40.r),
          bottomRight: Radius.circular(40.r),
        ),
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                backgroundColor: AppColor.appBackground,
                radius: 50,
                backgroundImage: authLocal.getCurrentUser()?.photoUrl != null ? FileImage(File(authLocal.getCurrentUser()?.photoUrl??"")): null,
            ),

            12.horizontalSpace,
            Text(
              user?.fullName ?? "User",
              style: AppTypography.subHeadline.copyWith(
                  color: AppColor.textPrimary, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
