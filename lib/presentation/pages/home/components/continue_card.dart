import 'package:auto_size_text/auto_size_text.dart';
import 'package:bke/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../data/models/book/book_listener.dart';
import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import '../../video/video_player_page.dart';

class ContinueCard extends StatelessWidget {
  const ContinueCard({Key? key, required this.recentAction, required this.item})
      : super(key: key);

  final RecentAction recentAction;
  final dynamic item;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    late final String action;
    switch (recentAction.index) {
      case 0:
        action = 'xem';
        break;
      case 1:
        action = 'đọc';
        break;
      case 2:
        action = 'nghe';
        break;
      case 3:
        action = 'học từ vựng';
        break;
      case 4:
        action = 'làm bài';
        break;
      case 5:
        action = 'chơi';
        break;
    }
    return SizedBox(
      height: 0.15.sh,
      width: 0.9.sw,
      // child: Stack(
      //     children: [
      //       SvgPicture.asset(
      //         'assets/texture/card.svg',
      //         width: size.width,
      //         fit: BoxFit.contain,
      //       ),
      child: Padding(
        padding: EdgeInsets.all(5.0.r),
        child: GestureDetector(
          onTap: () {
            recentAction == RecentAction.readBook
                ? Navigator.of(context).pushNamed(RouteName.bookRead,
                    arguments: BookArguments(
                        bookId: item.bookId, id: item.id, title: item.title))
                : Navigator.of(context).pushNamed(RouteName.videoPlayer,
                    arguments:
                        VideoPlayerPageModel(context: context, video: item));
          },
          child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                  color: AppColor.primary,
                  padding: EdgeInsets.all(10.0.r),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: size.width * 0.4,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AutoSizeText(
                              'Tiếp tục $action',
                              style: AppTypography.body.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColor.textPrimary,
                              ),
                              maxLines: 1,
                            ),
                            AutoSizeText(item.title,
                                style: AppTypography.body.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColor.textPrimary,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      Stack(
                        alignment: AlignmentDirectional.center,
                        children: [
                          // SizedBox(
                          //   width: size.width*0.12,
                          //   child: ClipRRect(
                          //     borderRadius: BorderRadius.circular(10),
                          //     child: Container(
                          //       color: Colors.white)
                          //   ),
                          // ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.r),
                            child: Container(
                              padding: EdgeInsets.all(1.0.r),
                              height: recentAction == RecentAction.readBook
                                  ? 0.3.sw
                                  : 0.18.sw,
                              color: AppColor.primary,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/default_logo.png',
                                placeholderFit: BoxFit.contain,
                                image: recentAction == RecentAction.readBook
                                    ? item.coverUrl
                                    : item.thumbUrl,
                                fadeInDuration:
                                    const Duration(milliseconds: 400),
                                fit: BoxFit.fill,
                                // placeholderFit: BoxFit.fill,
                                imageErrorBuilder:
                                    (context, error, stackTrace) => Image.asset(
                                  'assets/images/default_logo.png',
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ))),
        ),
      ),
    );
  }
}
