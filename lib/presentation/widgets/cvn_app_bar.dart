import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/app_color.dart';
import '../theme/app_typography.dart';
import 'circle_border_container.dart';

class CVNAppBar extends StatelessWidget {
  const CVNAppBar({
    Key? key,
    this.label,
    this.onBackButtonPress,
    this.onSearchButtonPress,
    this.showNotificationAction = true,
    this.leading,
  }) : super(key: key);

  final String? label;
  final VoidCallback? onBackButtonPress;
  final VoidCallback? onSearchButtonPress;
  final bool showNotificationAction;
  final Widget? leading;

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
          padding: EdgeInsets.only(
            top: topPadding,
            right: 30.r,
            left: onBackButtonPress != null ? 20.r : 30.r,
          ),
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
    return leading != null
        ? leading!
        : CircleBorderContainer(
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
          );
  }

  Widget _buildNotificationIcon(BuildContext context) {
    return Visibility(
      visible: showNotificationAction,
      child: CircleBorderContainer(
        radius: 32.r,
        elevation: 2,
        borderColor: AppColor.iconBorder,
        borderWidth: 3.r,
        onPressed: () {},
        child: SvgPicture.asset(
          'assets/icons/ic_noti_default.svg',
          fit: BoxFit.contain,
          width: 16.r,
          height: 16.r,
        ),
      ),
    );
  }

  Widget _buildSearchIcon(BuildContext context) {
    return Visibility(
      visible: onSearchButtonPress != null,
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
}
