import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:translator/translator.dart';

import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';

class TranslateIconButton extends StatelessWidget {
  final String text;

  const TranslateIconButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () async {
        final translation = await GoogleTranslator().translate(text, to: 'vi');
        String translateFromGG = translation.text;
        // ignore: use_build_context_synchronously
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => Container(
            height: 200.h,
            padding: EdgeInsets.symmetric(vertical: 16.r),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: AppColor.primary,
            ),
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        height: 70.h,
                        child: AutoSizeText.rich(
                          TextSpan(
                              text: "English: ",
                              style: AppTypography.body
                                  .copyWith(color: AppColor.mainPink),
                              children: [
                                TextSpan(text: text, style: AppTypography.body)
                              ]),
                        )),
                    SizedBox(
                        height: 70.h,
                        child: AutoSizeText.rich(
                          TextSpan(
                              text: "Vietnamese: ",
                              style: AppTypography.body
                                  .copyWith(color: AppColor.mainPink),
                              children: [
                                TextSpan(
                                    text: translateFromGG,
                                    style: AppTypography.body)
                              ]),
                        )),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      icon: Icon(Icons.g_translate, size: 14.r, color: AppColor.darkGray),
    );
  }
}
