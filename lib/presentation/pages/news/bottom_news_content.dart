import 'package:bke/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';
import 'package:translator/translator.dart';

import '../../../data/models/news/news_model.dart';
import '../../theme/app_color.dart';
import '../../theme/app_typography.dart';
import '../../widgets/holder_widget.dart';


class BottomNewsContent extends StatelessWidget {
  final NewsInfo news;
  const BottomNewsContent({Key? key, required this.news}) : super(key: key);

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
  return Container(
        height: 1000.h,
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      this.news.title,
                      style: AppTypography.subHeadline.copyWith(fontWeight: FontWeight.w600)
                    ),
                    Text(
                          this.news.author,
                          style: AppTypography.bodySmall.copyWith(fontWeight: FontWeight.w700)
                        ),
                    Row(
                      children: [
                        Text(
                          " - ${this.news.source}, ",
                          style: AppTypography.bodySmall
                        ),
                        Text(
                          _getPublishTime(this.news.publishedAt),
                          style: AppTypography.bodySmall.copyWith(fontStyle: FontStyle.italic)
                        ),
                      ],
                    ),
                    Text(
                          this.news.content,
                          style: AppTypography.body
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
