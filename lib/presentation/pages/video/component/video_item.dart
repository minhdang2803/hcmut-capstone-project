import 'package:bke/data/models/video/video_youtube_info_model.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class VideoItem extends StatelessWidget {
  const VideoItem({
    Key? key,
    this.item,
    required this.onItemClick,
    this.isLastSeen = false,
  }) : super(key: key);

  final VideoYoutubeInfo? item;
  final bool? isLastSeen;
  final VoidCallback onItemClick;

  @override
  Widget build(BuildContext context) {
    double getLength(String length) {
      final listLength = length.split(":");
      return double.parse(listLength[0]) * 60 + double.parse(listLength[1]);
    }

    return GestureDetector(
      onTap: onItemClick,
      behavior: HitTestBehavior.translucent,
      child: SizedBox(
        width: 150.r,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FadeInImage.assetNetwork(
                  placeholder: 'assets/images/default_logo.png',
                  image: item?.thumbUrl ?? '',
                  width: 150.r,
                  height: 125.r,
                  fadeInDuration: const Duration(milliseconds: 350),
                  fit: BoxFit.fill,
                  placeholderFit: BoxFit.fill,
                  imageErrorBuilder: (context, error, stackTrace) =>
                      Image.asset(
                    width: 150.r,
                    height: 120.r,
                    'assets/images/default_logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                isLastSeen == true
                    ? SizedBox(
                        height: 5.r,
                        child: LinearProgressIndicator(
                          color: Colors.red,
                          value: item!.checkpoint! / 960,
                        ),
                      )
                    : const SizedBox(),
                Container(
                  color: AppColor.lightGray,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.circleExclamation),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
                      )
                    ],
                  ),
                )
                // 5.verticalSpace,
                // Text(
                //   item?.title ?? '',
                //   style: AppTypography.bodySmall
                //       .copyWith(fontWeight: FontWeight.bold),
                //   textAlign: TextAlign.start,
                // ),
                // 10.verticalSpace,
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     Container(
                //       decoration: BoxDecoration(
                //           borderRadius: BorderRadius.circular(10.r),
                //           color: AppColor.primary),
                //       child: Padding(
                //         padding: EdgeInsets.symmetric(
                //             horizontal: 12.r, vertical: 3.r),
                //         child: Text(
                //           'Basic',
                //           style: AppTypography.bodySmall
                //               .copyWith(color: Colors.white),
                //         ),
                //       ),
                //     ),
                //     // 5.horizontalSpace,
                //     Text('${item?.viewCount ?? '100'} views',
                //         style: AppTypography.bodySmall),
                //   ],
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
