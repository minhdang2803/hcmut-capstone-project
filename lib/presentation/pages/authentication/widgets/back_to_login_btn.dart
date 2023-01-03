import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../utils/enum.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';

class BackToLoginBtn extends StatefulWidget {
  const BackToLoginBtn({super.key, required this.onChangeAction});

  final Function(AuthAction action) onChangeAction;
  @override
  State<BackToLoginBtn> createState() => _BackToLoginBtnState();
}

class _BackToLoginBtnState extends State<BackToLoginBtn> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => widget.onChangeAction(AuthAction.authentication),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.arrow_back_rounded,
            size: 16.r,
            color: AppColor.textSecondary,
          ),
          4.horizontalSpace,
          Text(
            'Trở lại bước đăng nhập',
            style: AppTypography.body.copyWith(
              color: AppColor.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
