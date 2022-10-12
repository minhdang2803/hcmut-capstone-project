import 'package:bke/data/models/video/video_youtube_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';

class VideoYoutubeItem extends StatefulWidget {
  const VideoYoutubeItem({
    Key? key,
    required this.videoYoutubeInfo,
    required this.onItemClick,
  }) : super(key: key);

  final VideoYoutubeInfo videoYoutubeInfo;
  final VoidCallback onItemClick;

  @override
  State<VideoYoutubeItem> createState() => _VideoYoutubeItemState();
}

class _VideoYoutubeItemState extends State<VideoYoutubeItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onItemClick,
      behavior: HitTestBehavior.translucent,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.r, vertical: 5.h),
          child: SizedBox(
            child: Row(
              children: [
                FadeInImage.assetNetwork(
                  placeholder: 'assets/images/default_logo.png',
                  image: widget.videoYoutubeInfo.thumbUrl,
                  fadeInDuration: const Duration(milliseconds: 350),
                  width: 120.r,
                  height: 70.r,
                  fit: BoxFit.contain,
                  placeholderFit: BoxFit.contain,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      Image.asset(
                    'assets/images/default_logo.png',
                    width: 36.r,
                    height: 36.r,
                    fit: BoxFit.contain,
                  ),
                ),
                10.horizontalSpace,
                _buildSubYoutubeData(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubYoutubeData() {
    return Expanded(
      child: Column(
        children: [
          Text(
            widget.videoYoutubeInfo.title,
            style:
                AppTypography.bodySmall.copyWith(fontWeight: FontWeight.bold),
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
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.r, vertical: 3.r),
                  child: Text(
                    'Basic',
                    style:
                        AppTypography.bodySmall.copyWith(color: Colors.white),
                  ),
                ),
              ),
              5.horizontalSpace,
              Text('${widget.videoYoutubeInfo.viewCount} views',
                  style: AppTypography.bodySmall),
            ],
          )
        ],
      ),
    );
  }
}
