import 'package:bke/data/models/video/video_youtube_info_model.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../theme/app_typography.dart';

class VideoItem extends StatefulWidget {
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
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  Offset _position = Offset.zero;

  void _getTapPosition(TapDownDetails tapPosition) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _position = renderBox.globalToLocal(tapPosition.globalPosition);
    });
  }

  void _showInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Thông tin video",
              style: AppTypography.title.copyWith(fontWeight: FontWeight.w700)),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          content: SizedBox(
              width: MediaQuery.of(context).size.width * 0.7,
              height: MediaQuery.of(context).size.height * 0.3,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text.rich(TextSpan(
                    //   text: ": ",
                    //   children: [
                    //     TextSpan(
                    //         text: widget.item!.category!.toCapitalize(),
                    //         style: AppTypography.bodySmall)
                    //   ],
                    //   style: AppTypography.bodySmall
                    //       .copyWith(color: AppColor.primary),
                    // )),
                    // 5.verticalSpace,
                    Text.rich(TextSpan(
                      text: "Tựa đề: ",
                      children: [
                        TextSpan(
                            text: widget.item!.title.toCapitalize(),
                            style: AppTypography.bodySmall)
                      ],
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColor.textPrimary),
                    )),
                    5.verticalSpace,
                    Text.rich(TextSpan(
                      text: "Lượt xem: ",
                      children: [
                        TextSpan(
                            text: widget.item!.viewCount,
                            style: AppTypography.bodySmall)
                      ],
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColor.textPrimary),
                    )),
                    5.verticalSpace,
                    Text(
                      widget.item!.description!.toCapitalize(),
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
              )),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r)),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                "Huỷ",
                style: AppTypography.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double getLength(String length) {
      final listLength = length.split(":");
      return double.parse(listLength[0]) * 60 + double.parse(listLength[1]);
    }

    return GestureDetector(
      onTap: widget.onItemClick,
      behavior: HitTestBehavior.translucent,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12.r),
            child: SizedBox(
              width: 150.r,
              height: 140.r,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 150.r,
                        height: widget.isLastSeen == true ? 110.r : 140.r,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/images/default_logo.png',
                          image: widget.item?.thumbUrl ?? 'assets/images/default_logo.png',
                          width: 150.r,
                          height: widget.isLastSeen == true ? 110.r : 140.r,
                          fadeInDuration: const Duration(milliseconds: 350),
                          fit: BoxFit.fill,
                          placeholderFit: BoxFit.fill,
                          imageErrorBuilder: (context, error, stackTrace) =>
                              Image.asset(
                            width: 150.r,
                            height: 110.r,
                            'assets/images/default_logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      widget.isLastSeen == true
                          ? SizedBox(
                              height: 5.r,
                              child: LinearProgressIndicator(
                                color: AppColor.accentBlue,
                                value: widget.item!.checkpoint! / 960,
                              ),
                            )
                          : const Visibility(visible: false, child: SizedBox()),
                      widget.isLastSeen == true?
                        Container(
                          color: AppColor.darkGray,
                          height: 23.r,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                iconSize: 13.r,
                                color: AppColor.textPrimary,
                                onPressed: () {
                                  _showInfo(context);
                                },
                                icon: const FaIcon(FontAwesomeIcons.circleExclamation),
                              ),
                              IconButton(
                                iconSize: 13.r,
                                color: AppColor.textPrimary,
                                onPressed: () {},
                                icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
                              )
                            ],
                          ),
                        ):const Visibility(visible: false, child: const SizedBox()),
                      
                      
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
              width: 150.r,
              child: Text(
                        widget.item!.title, // Replace with your actual title
                        style: AppTypography.bodySmall.copyWith(color: AppColor.textPrimary, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
          ),
        ],
      ),
      
    );
  }
}
