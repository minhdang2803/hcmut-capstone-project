import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../routes/route_name.dart';
import '../../theme/app_color.dart';
import '../../theme/app_typography.dart';
import '../../widgets/holder_widget.dart';
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
            color: AppColor.accentBlue
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildHuman(),
              Padding(
                padding: EdgeInsets.all(30.r),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColor.defaultBorder, width: 1.5),
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Column(
                    children: [
                      10.verticalSpace,
                      Text(
                        'Bắt đầu học cùng Casper',
                        style: AppTypography.subHeadline
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      10.verticalSpace,
                      Text(
                        'Đăng nhập hoặc tạo một tài khoản để bắt đầu cuộc hành trình nào!',
                        style: AppTypography.title.copyWith(
                          color: AppColor.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      15.verticalSpace,
                      _buildSubButton(context, "Đăng nhập", true),
                      10.verticalSpace,
                      _buildSubButton(context, "Tạo tài khoản", false),
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
      children: const [HolderWidget(asset: 'assets/images/peace.png')],
    );
  }

  Widget _buildSubButton(BuildContext context, String title, bool isLogin) {
    return RoundedElevatedButton(
      elevation: 0,
      label: title,
      labelStyle: AppTypography.subHeadline.copyWith(
          color: AppColor.textPrimary,
          fontWeight: FontWeight.bold),
      backgroundColor: isLogin ?AppColor.accentBlue : AppColor.darkGray,
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
