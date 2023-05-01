import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/circular_border_icon.dart';
import '../../../../bloc/authentication/auth_cubit.dart';

class Option extends StatelessWidget {
  const Option({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Hoặc',
              style: AppTypography.body.copyWith(
                color: AppColor.textSecondary,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularBorderIcon(
                  icon: SvgPicture.asset(
                    'assets/icons/ic_facebook.svg',
                    width: 24.r,
                    height: 24.r,
                  ),
                  borderColor: Colors.grey[400]!,
                  onIconClick: () {
                    // context.read<AuthCubit>().doFacebookLogin();
                  },
                ),
                14.horizontalSpace,
                CircularBorderIcon(
                  icon: SvgPicture.asset(
                    'assets/icons/ic_google.svg',
                    width: 24.r,
                    height: 24.r,
                  ),
                  borderColor: Colors.grey[400]!,
                  onIconClick: () {
                    context.read<AuthCubit>().doGoogleLogin();
                  },
                ),
              ],
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).pushReplacementNamed(RouteName.main);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Đăng nhập ẩn danh',
                    style: AppTypography.body.copyWith(
                      color: AppColor.textSecondary,
                    ),
                  ),
                  Icon(
                    Icons.arrow_right_alt_rounded,
                    size: 32.r,
                  )
                ]
              )
            )
          ]
        );
      }
    );
  }
}
