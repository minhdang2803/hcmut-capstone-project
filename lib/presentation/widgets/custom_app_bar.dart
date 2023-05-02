import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../theme/app_color.dart';
import '../theme/app_typography.dart';
import 'circle_border_container.dart';

class BkEAppBar extends StatelessWidget {
  const BkEAppBar({
    Key? key,
    this.label,
    this.onBackButtonPress,
    this.onSearchButtonPress,
    this.showNotificationAction = false,
    this.leading,
    this.trailing,
    this.color = AppColor.appBackground,
  }) : super(key: key);

  final String? label;
  final VoidCallback? onBackButtonPress;
  final VoidCallback? onSearchButtonPress;
  final bool showNotificationAction;
  final Widget? leading;
  final Widget? trailing;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;
    return Container(
      width: MediaQuery.of(context).size.width,
      // height: 63.r + topPadding,
      height: 50.h,
      color: color,
      child: Padding(
        padding: EdgeInsets.only(
          // top: topPadding,
          top: 0,
          right: 18.r,
          left: onBackButtonPress != null ? 20.r : 30.r,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildLeading(context),
            10.horizontalSpace,
            _buildLabel(),
            20.horizontalSpace,
            _buildNotificationIcon(context),
            if (onSearchButtonPress != null) 12.horizontalSpace,
            _buildSearchIcon(context),
            _buildOptions(context)
          ],
        ),
      ),
    );
  }

  Widget _buildOptions(BuildContext context) {
    return Visibility(
        visible: trailing != null,
        child: Row(
          children: [
            trailing ?? const SizedBox.shrink(),
          ],
        ));
  }

  Widget _buildLabel() {
    return Expanded(
      child: AutoSizeText(
        label ?? '',
        textAlign: TextAlign.center,
        style: AppTypography.headline.copyWith(
            fontWeight: FontWeight.w900,
            color: AppColor.textPrimary,
            fontSize: 25),
        maxLines: 1,
      ),
    );
  }

  Widget _buildLeading(BuildContext context) {
    return leading != null
        ? leading!
        : Visibility(
            visible: onBackButtonPress != null,
            child: BackButton(
              color: AppColor.textPrimary,
              onPressed: onBackButtonPress,
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
        borderColor: Colors.transparent,
        borderWidth: 3.r,
        onPressed: onSearchButtonPress,
        child: SvgPicture.asset(
          'assets/icons/ic_search.svg',
          fit: BoxFit.contain,
          color: AppColor.textPrimary,
          width: 16.r,
          height: 16.r,
        ),
      ),
    );
  }
}
