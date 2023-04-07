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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(height: 70.h, child: AutoSizeText(text, style: AppTypography.bodySmall)),
                  SizedBox(height: 70.h, child: AutoSizeText(translateFromGG, style: AppTypography.body.copyWith(fontWeight: FontWeight.bold),)),
                ],
              ),
            ),
          ),
        );
      },
      icon: Icon(Icons.g_translate, size: 14.r, color: AppColor.darkGray),
    );
  }
}
