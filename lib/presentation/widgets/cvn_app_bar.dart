import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive_flutter/adapters.dart';

import '../../bloc/authentication/auth_cubit.dart';
import '../routes/route_name.dart';
import '../theme/app_color.dart';
import '../theme/app_typography.dart';
import 'circle_border_container.dart';

class CVNAppBar extends StatelessWidget {
  const CVNAppBar({
    Key? key,
    required this.label,
    required this.hasBackButton,
    required this.hasTrailing,
    this.onBackButtonPress,
    this.onSearchButtonPress,
  }) : super(key: key);

  final String? label;
  final bool hasBackButton;
  final bool hasTrailing;
  final VoidCallback? onBackButtonPress;
  final VoidCallback? onSearchButtonPress;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Material(
      elevation: 3,
      child: Container(
        width: 1.sw,
        height: 63.r + topPadding,
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.only(top: topPadding, right: 30.r, left: 30.r),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildLeading(context),
              10.horizontalSpace,
              _buildLabel(),
              20.horizontalSpace,
              _buildNotificationIcon(context),
              if (onSearchButtonPress != null) 12.horizontalSpace,
              _buildSearchIcon(context),
              // 10.horizontalSpace,
              // _buildUserProfileIcon(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel() {
    return Expanded(
      child: AutoSizeText(
        label ?? '',
        style: AppTypography.title.copyWith(
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    return hasBackButton
        ? CircleBorderContainer(
            radius: 28.r,
            elevation: null,
            borderColor: Colors.transparent,
            borderWidth: null,
            onPressed: onBackButtonPress != null
                ? onBackButtonPress!
                : (() => Navigator.of(context).pop()),
            child: Icon(
              Icons.arrow_back_ios_rounded,
              size: 16.r,
            ),
          )
        : const SizedBox();
  }

  Widget _buildNotificationIcon(BuildContext context) {
    return hasTrailing
        ? CircleBorderContainer(
            radius: 32.r,
            elevation: 2,
            borderColor: AppColor.iconBorder,
            borderWidth: 3.r,
            onPressed: () {
              // TODO: Implement Icon click
            },
            child: SvgPicture.asset(
              'assets/icons/ic_noti_default.svg',
              fit: BoxFit.contain,
              width: 16.r,
              height: 16.r,
            ),
          )
        : const SizedBox();
  }

  Widget _buildSearchIcon(BuildContext context) {
    return Visibility(
      visible: hasTrailing && (onSearchButtonPress != null),
      child: CircleBorderContainer(
        radius: 32.r,
        elevation: 2,
        borderColor: AppColor.iconBorder,
        borderWidth: 3.r,
        onPressed: onSearchButtonPress,
        child: SvgPicture.asset(
          'assets/icons/ic_search.svg',
          fit: BoxFit.contain,
          color: AppColor.primary,
          width: 16.r,
          height: 16.r,
        ),
      ),
    );
  }

  Widget _buildUserProfileIcon(BuildContext context) {
    final authCubit = BlocProvider.of<AuthCubit>(context);
    return Visibility(
      visible: hasTrailing,
      child: CircleBorderContainer(
        radius: 34.r,
        borderColor: AppColor.primary,
        borderWidth: 1,
        onPressed: () {
          Navigator.of(context).pushNamed(RouteName.updateProfile);
        },
        child: ValueListenableBuilder(
          valueListenable: authCubit.getUserBox().listenable(),
          builder: (ctx, Box userBox, child) {
            final image = authCubit.getCurrentUser()?.photoUrl;
            return CachedNetworkImage(
              imageUrl: image ?? '',
              fadeInDuration: const Duration(milliseconds: 350),
              fit: BoxFit.cover,
              errorWidget: (ctx, url, error) => Image.asset(
                'assets/images/error_profile_image_holder.png',
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
