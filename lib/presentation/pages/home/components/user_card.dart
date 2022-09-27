import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';

import '../../../../bloc/authentication/auth_cubit.dart';
import '../../../../utils/string_util.dart';
import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';

class UserCard extends StatelessWidget {
  const UserCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return ValueListenableBuilder(
      valueListenable: authCubit.getUserBox().listenable(),
      builder: (ctx, Box userBox, child) {
        final currentUser = authCubit.getCurrentUser();
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.r),
          child: currentUser != null
              ? Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/authentication/default_user.svg',
                      width: 1.sw,
                      fit: BoxFit.contain,
                    ),
                    Row(
                      children: [
                        SizedBox(width: 16.r),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.r),
                          child: CachedNetworkImage(
                            width: 72.r,
                            height: 72.r,
                            imageUrl: currentUser.photoUrl ?? '',
                            fadeInDuration: const Duration(milliseconds: 350),
                            fit: BoxFit.cover,
                            errorWidget: (ctx, url, error) => Image.asset(
                              'assets/images/error_profile_image_holder.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.r),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                StringUtil.getUserIdentify(currentUser),
                                style: AppTypography.title.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.r),
                              Text(
                                currentUser.id ?? '',
                                style: AppTypography.body.copyWith(
                                  color: AppColor.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Stack(
                  alignment: Alignment.center,
                  children: [
                    SvgPicture.asset(
                      'assets/authentication/default_user.svg',
                      width: 1.sw,
                      fit: BoxFit.contain,
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 2.0,
                        sigmaY: 2.0,
                      ),
                      child: Container(
                        color: Colors.black.withOpacity(0),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          "Để sử dụng toàn bộ tính năng:",
                          style: AppTypography.title
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.r),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildLoginSignup("Đăng kí", false, context),
                            SizedBox(width: 10.r),
                            _buildLoginSignup("Đăng nhập", true, context),
                          ],
                        )
                      ],
                    )
                  ],
                ),
        );
      },
    );
  }

  Widget _buildLoginSignup(String text, bool isLogin, BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => {
        Navigator.of(context).pushNamedAndRemoveUntil(
          RouteName.authentication,
          (Route<dynamic> route) => false,
          arguments: isLogin ? 0 : 1,
        )
      },
      child: Container(
        width: 110.r,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          border: Border.all(color: AppColor.primary),
          color: !isLogin ? AppColor.primary : Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15.r),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 5.r),
          child: Text(
            text,
            style: AppTypography.body.copyWith(
              color: !isLogin ? Colors.white : AppColor.primary,
            ),
          ),
        ),
      ),
    );
  }
}
