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

  String _getPublishTime(String time) {
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
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.r),
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackButton(onPressed: () => Navigator.pop(context)),
          5.verticalSpace,
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                news.title,
                style: AppTypography.subHeadline
                    .copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.left,
              ),
              15.verticalSpace,
              Text(
                news.author,
                style: AppTypography.body.copyWith(fontWeight: FontWeight.w700),
                textAlign: TextAlign.left,
              ),
              15.verticalSpace,
              Row(
                children: [
                  Text(
                    " - ${news.source}, ",
                    style: AppTypography.bodySmall,
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    _getPublishTime(news.publishedAt),
                    style: AppTypography.bodySmall
                        .copyWith(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
              10.verticalSpace,
              ClipRRect(
                borderRadius: BorderRadius.circular(
                  20.r,
                ),
                child: FadeInImage.assetNetwork(
                  fit: BoxFit.contain,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      Image.network(
                    'https://static.wikia.nocookie.net/otonari-no-tenshi/images/c/c9/No_images_available.jpg/revision/latest?cb=20220104141308',
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.contain,
                  ),
                  placeholder: "assets/images/default_logo.png",
                  image: news.urlToImage.isEmpty
                      ? news.urlToImage
                      : "https://lh3.googleusercontent.com/drive-viewer/AAOQEOSNan7V6kMFqB0eeYCVQJiAUyn8nGpA9fCjFywBjqiCpxxxBG8eECkDciAEoCWLA6s5UW2Hjczs7Toh9_-UwmiSlKh2=s2560",
                ),
              ),
              15.verticalSpace,
              Text.rich(
                TextSpan(
                  children: _wordProcessing.createTextSpans(
                    context,
                    news.content,
                    AppTypography.title,
                  ),
                ),
                textAlign: TextAlign.justify,
              ),
            ],
          ))),
        ],
      ),
    );
  }
}
