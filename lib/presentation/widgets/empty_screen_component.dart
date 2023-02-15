import 'package:bke/presentation/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_typography.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key, required this.title, this.isLoading = false});
  final String title;
  final bool? isLoading;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r))),
        child: !isLoading!
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  150.verticalSpace,
                  Image(
                    image: const AssetImage("assets/images/no.png"),
                    height: 200.r,
                    width: 200.r,
                  ),
                  SizedBox(
                    width: 200.w,
                    child: Text(
                      title,
                      style: AppTypography.subHeadline
                          .copyWith(fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              )
            : const Center(
                child: CircularProgressIndicator(
                color: AppColor.primary,
              )),
      ),
    );
  }
}
