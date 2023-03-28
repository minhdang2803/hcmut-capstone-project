import 'package:auto_size_text/auto_size_text.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../theme/app_typography.dart';

class JoinQuizCard extends StatelessWidget {
  const JoinQuizCard({Key? key, required this.onTap}) : super(key: key);
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.8,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
              color: AppColor.primary,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AutoSizeText(
                    textAlign: TextAlign.center,
                    'Luyện tập kỹ năng TOEIC',
                    style: AppTypography.title.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: AppColor.textPrimary,
                    ),
                    maxLines: 2,
                  ),
                  TextButton(
                    onPressed: onTap,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: size.height * 0.05,
                        width: size.width * 0.4,
                        color: AppColor.secondary,
                        padding: const EdgeInsets.symmetric(vertical: 0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            AutoSizeText(
                              'Tham gia ngay',
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: AppColor.textPrimary,
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ))),
    );
  }
}
