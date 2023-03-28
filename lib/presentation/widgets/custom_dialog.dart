import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_color.dart';
import '../theme/app_typography.dart';

class BKEDialog extends StatelessWidget {
  const BKEDialog({
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
          height: 0.5.sw,
          decoration: BoxDecoration(
            color: AppColor.primary,
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
                        child: Image.asset(
                          'assets/images/sad.png',
                          width: 65.r,
                          height: 65.r,
                          fit: BoxFit.contain,
                        ),
                      ),
                      AutoSizeText(
                        title,
                        textAlign: TextAlign.center,
                        style: AppTypography.title.copyWith(
                          color: AppColor.textPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                      AutoSizeText(
                        message,
                        textAlign: TextAlign.center,
                        style: AppTypography.body,
                        maxLines: 2,
                      ),
                      2.verticalSpace
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
                            border:
                                Border.all(color: AppColor.secondary, width: 1),
                            color: AppColor.secondary,
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Huỷ',
                            style: AppTypography.body.copyWith(
                              color: AppColor.textPrimary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 48.r,
                      width: 2.r,
                      color: AppColor.appBackground,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: onAccepted,
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: AppColor.secondary,
                            border:
                                Border.all(color: AppColor.secondary, width: 1),
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(20),
                            ),
                          ),
                          child: Text(
                            'Đồng ý',
                            style: AppTypography.body
                                .copyWith(color: AppColor.textPrimary),
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
