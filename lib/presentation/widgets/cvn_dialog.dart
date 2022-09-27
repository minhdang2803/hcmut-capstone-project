import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../theme/app_color.dart';
import '../theme/app_typography.dart';

class CVNDialog extends StatelessWidget {
  const CVNDialog({
    Key? key,
    required this.title,
    required this.message,
    this.onAccepted,
    this.onDismissed,
  }) : super(key: key);

  final String title;
  final String message;
  final VoidCallback? onAccepted;
  final VoidCallback? onDismissed;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 0.8.sw,
          height: 0.6.sw,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
          ),
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10.r),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Center(
                        child: SvgPicture.asset(
                          'assets/icons/ic_delacc.svg',
                          width: 56.r,
                          height: 56.r,
                          fit: BoxFit.contain,
                        ),
                      ),
                      AutoSizeText(
                        title,
                        style: AppTypography.title.copyWith(
                          color: AppColor.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        textAlign: TextAlign.center,
                      ),
                      AutoSizeText(
                        message,
                        style: AppTypography.body,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 48.r,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: onDismissed,
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColor.secondary.withOpacity(0.5),
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Hủy bỏ',
                            style: AppTypography.body.copyWith(
                              color: AppColor.onSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: onAccepted,
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: const BoxDecoration(
                            color: AppColor.secondary,
                            borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Đồng ý',
                            style: AppTypography.body
                                .copyWith(color: AppColor.onPrimary),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
