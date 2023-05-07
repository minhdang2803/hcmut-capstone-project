import 'dart:io';

import 'package:bke/presentation/theme/app_typography.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
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
    final googleImage = FirebaseAuth.instance.currentUser?.photoURL ??
        "https://lh3.googleusercontent.com/drive-viewer/AFGJ81qQfSbK-RvsJd_b-fbUmfVpxD1eTBrVvEVh88F0LsENgFxF7rkLY2jbH8MRvKl9ZH_KS38Ndwt7_Apoiyk9NRquO3Lt=s2560";
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
            Container(
              padding: EdgeInsets.all(5.r),
              height: 65.r,
              width: 65.r,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(360),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(360),
                child: Image.network(
                  googleImage,
                  fit: BoxFit.fill,
                ),
              ),
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
