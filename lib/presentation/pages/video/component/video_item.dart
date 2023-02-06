import 'package:bke/data/models/video/video_youtube_info_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';

class VideoItem extends StatelessWidget {
  const VideoItem({
    Key? key,
    this.item,
    required this.onItemClick,
  }) : super(key: key);

  final VideoYoutubeInfo? item;

  final VoidCallback onItemClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemClick,
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: 160.r,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                FadeInImage.assetNetwork(
                  placeholder: 'assets/images/default_logo.png',
                  image: item?.thumbUrl ?? '',
                  width: 160.r,
                  height: 70.r,
                  fadeInDuration: const Duration(milliseconds: 350),
                  fit: BoxFit.contain,
                  placeholderFit: BoxFit.contain,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      Image.asset(
                    width: 160.r,
                    height: 70.r,
                    'assets/images/default_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                Text(
                  item?.title ?? '',
                  style: AppTypography.bodySmall
                      .copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.start,
                ),
                10.verticalSpace,
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(078),
                          color: AppColor.primary),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.r, vertical: 3.r),
                        child: Text(
                          'Basic',
                          style: AppTypography.bodySmall
                              .copyWith(color: Colors.white),
                        ),
                      ),
                    ),
                    5.horizontalSpace,
                    Text('${item?.viewCount ?? '100'} views',
                        style: AppTypography.bodySmall),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
