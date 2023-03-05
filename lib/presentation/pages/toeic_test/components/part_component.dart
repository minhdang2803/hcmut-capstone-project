import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PartComponent extends StatelessWidget {
  const PartComponent({
    super.key,
    required this.imgUrl,
    required this.part,
    required this.title,
    // required this.onTap,
  });
  final String imgUrl;
  final int part;
  final String title;
  // final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: onTap,
      child: Column(
        children: [
          SizedBox(
            width: 120.r,
            height: 120.r,
            child: Card(
              elevation: 1.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    imgUrl,
                    height: 50.r,
                    width: 50.r,
                    fit: BoxFit.contain,
                  ),
                  5.verticalSpace,
                  Text(
                    "Part $part",
                    style: AppTypography.body
                        .copyWith(fontWeight: FontWeight.w700),
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            width: 100.r,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.body.copyWith(fontWeight: FontWeight.w700),
            ),
          )
        ],
      ),
    );
  }
}
