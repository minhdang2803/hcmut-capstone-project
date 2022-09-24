import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../../bloc/authentication/auth_cubit.dart';
import '../../../../../utils/string_util.dart';
import '../../../../theme/app_color.dart';
import '../../../../theme/app_typography.dart';

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
      height: 165.r,
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: SizedBox(
        width: 1.sw,
        height: 57.r,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.r),
          child: Row(
            children: [],
          ),
        ),
      ),
    );
  }
}
