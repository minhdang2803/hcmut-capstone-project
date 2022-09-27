import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../routes/route_name.dart';
import '../../theme/app_color.dart';
import '../../theme/app_typography.dart';
import '../../widgets/rounded_elevated_button.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Stack(
        children: [
          SvgPicture.asset(
            'assets/authentication/welcome_screen.svg',
            width: 1.sw,
            fit: BoxFit.contain,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildHuman(),
              Padding(
                padding: EdgeInsets.all(15.r),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        'Login or Sign Up',
                        style: AppTypography.superHeadline
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      10.verticalSpace,
                      Text(
                        'Login or create an account to learn English, take part in challenges, and more.',
                        style: AppTypography.subHeadline.copyWith(
                          color: AppColor.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      15.verticalSpace,
                      _buildSubButton(context, "Login", true),
                      10.verticalSpace,
                      _buildSubButton(context, "Create an account", false),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHuman() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          'assets/authentication/6.svg',
          width: 180.68.r,
          height: 269.55.r,
        ),
        SvgPicture.asset(
          'assets/authentication/3.svg',
          width: 180.68.r,
          height: 269.55.r,
        ),
      ],
    );
  }

  Widget _buildSubButton(BuildContext context, String title, bool isLogin) {
    return RoundedElevatedButton(
      elevation: 0,
      label: title,
      labelStyle: AppTypography.subHeadline.copyWith(
          color: isLogin ? Colors.white : AppColor.primary,
          fontWeight: FontWeight.bold),
      backgroundColor: isLogin ? AppColor.primary : AppColor.appBackground,
      width: 250.w,
      height: 46.h,
      radius: 17.r,
      onPressed: () {
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteName.authentication,
          (Route<dynamic> route) => false,
          arguments: isLogin ? 0 : 1,
        );
      },
    );
  }
}
