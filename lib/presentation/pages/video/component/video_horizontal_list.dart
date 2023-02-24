import 'package:bke/bloc/video/category_video/category_video_cubit.dart';
import 'package:bke/data/models/video/video_youtube_info_model.dart';
import 'package:bke/presentation/pages/video/video_player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import 'video_item.dart';

class VideoYoutubeHorizontalList extends StatelessWidget {
  const VideoYoutubeHorizontalList(
      {Key? key,
      required this.title,
      required this.data,
      required this.onSeeMore,
      this.isLastSeen = false})
      : super(key: key);

  final String title;
  final List<VideoYoutubeInfo> data;
  final bool? isLastSeen;
  final VoidCallback onSeeMore;

  void onItemClick(BuildContext context, VideoYoutubeInfo item) {
    Navigator.of(context)
        .pushNamed(
          RouteName.videoPlayer,
          arguments: VideoPlayerPageModel(context: context, video: item),
        )
        .then(
          (value) => context.read<CategoryVideoCubit>().getMainActivities(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230.r,
      width: double.infinity,
      padding: EdgeInsets.only(right: 15.r, left: 25.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.r),
            child: Row(
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
          ),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: data.length,
              separatorBuilder: (ctx, index) => 10.horizontalSpace,
              itemBuilder: (ctx, index) => VideoItem(
                isLastSeen: isLastSeen,
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
