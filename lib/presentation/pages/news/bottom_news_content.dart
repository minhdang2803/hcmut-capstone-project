import 'package:bke/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';
import 'package:translator/translator.dart';

import '../../../data/models/news/news_model.dart';
import '../../../utils/word_processing.dart';
import '../../theme/app_color.dart';
import '../../theme/app_typography.dart';
import '../../widgets/holder_widget.dart';


class BottomNewsContent extends StatelessWidget {
  final NewsInfo news;
  BottomNewsContent({Key? key, required this.news}) : super(key: key);
  final WordProcessing _wordProcessing = WordProcessing.instance();

  String _getPublishTime(String time){
    final now = DateTime.now().toUtc();
    final publishedHour = DateTime.parse(time);

    Duration difference = now.difference(publishedHour);
    if (difference.inDays > 0) {
    return "${difference.inDays} ngày trước";
    } else if (difference.inHours > 0) {
      return "${difference.inHours} giờ trước";
    } else {
      return "Gần đây";
    }
  }
  @override
  Widget build(BuildContext context){
  return 
    Container(
        padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child:  Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      news.title,
                      style: AppTypography.subHeadline.copyWith(fontWeight: FontWeight.w600)
                    ),
                    Text(
                          news.author,
                          style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700)
                        ),
                    Row(
                      children: [
                        Text(
                          " - ${news.source}, ",
                          style: AppTypography.bodySmall
                        ),
                        Text(
                          _getPublishTime(news.publishedAt),
                          style: AppTypography.bodySmall.copyWith(fontStyle: FontStyle.italic)
                        ),
                      ],
                    ),
                    RichText(
                      text: TextSpan(
                        children: _wordProcessing.createTextSpans(
                          context,
                          news.content,
                          AppTypography.title,
                        ),
                      ),
                    ),
                    ],
                )
              )
            ),
          ],
        ),
      );
  }
}
