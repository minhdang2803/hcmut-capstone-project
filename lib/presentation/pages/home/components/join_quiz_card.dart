import 'package:auto_size_text/auto_size_text.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../theme/app_typography.dart';

class JoinQuizCard extends StatelessWidget {
  const JoinQuizCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.8,
      child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
              color: Colors.white.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AutoSizeText(
                    textAlign: TextAlign.center,
                    'Tham gia giải đố Tiếng Anh cùng bạn bè',
                    style: AppTypography.title.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                    maxLines: 2,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        height: size.height * 0.05,
                        width: size.width * 0.4,
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 0.1),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/ic_locate.svg',
                              color: AppColor.darkGray,
                              width: 20,
                              height: 20,
                            ),
                            AutoSizeText(
                              'Tham gia ngay',
                              style: AppTypography.bodySmall.copyWith(
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                                color: AppColor.darkGray,
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
