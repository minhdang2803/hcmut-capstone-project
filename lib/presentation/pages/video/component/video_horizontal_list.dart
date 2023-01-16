import 'package:bke/data/models/video/video_youtube_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import 'video_item.dart';

class VideoYoutubeHorizontalList extends StatelessWidget {
  const VideoYoutubeHorizontalList({
    Key? key,
    required this.title,
    required this.data,
    required this.onSeeMore,
  }) : super(key: key);

  final String title;
  final List<VideoYoutubeInfo> data;
  final VoidCallback onSeeMore;

  void onItemClick(BuildContext context, VideoYoutubeInfo item) {
    Navigator.of(context).pushNamed(
      RouteName.videoPlayer,
      arguments: item,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230.r,
      width: double.infinity,
      padding: EdgeInsets.only(left: 16.r, right: 8.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.title.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                icon: Icon(
                  Icons.keyboard_arrow_right_rounded,
                  size: 24.r,
                  color: AppColor.primary,
                ),
                onPressed: onSeeMore,
              ),
            ],
          ),
          SizedBox(height: 10.r),
          Expanded(
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              separatorBuilder: (ctx, index) => SizedBox(width: 16.r),
              itemBuilder: (ctx, index) => VideoItem(
                item: data[index],
                onItemClick: () => onItemClick(context, data[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
