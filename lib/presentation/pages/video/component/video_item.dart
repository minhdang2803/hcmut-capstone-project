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
                    Text.rich(TextSpan(
                      text: "Category: ",
                      children: [
                        TextSpan(
                            text: widget.item!.category.toCapitalize(),
                            style: AppTypography.bodySmall)
                      ],
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColor.primary),
                    )),
                    5.verticalSpace,
                    Text.rich(TextSpan(
                      text: "Title: ",
                      children: [
                        TextSpan(
                            text: widget.item!.title.toCapitalize(),
                            style: AppTypography.bodySmall)
                      ],
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColor.primary),
                    )),
                    5.verticalSpace,
                    Text.rich(TextSpan(
                      text: "Total views: ",
                      children: [
                        TextSpan(
                            text: widget.item!.viewCount,
                            style: AppTypography.bodySmall)
                      ],
                      style: AppTypography.bodySmall
                          .copyWith(color: AppColor.primary),
                    )),
                    5.verticalSpace,
                    Text(
                      widget.item!.description.toCapitalize(),
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
                  image: widget.item?.thumbUrl ?? '',
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
                widget.isLastSeen == true
                    ? SizedBox(
                        height: 5.r,
                        child: LinearProgressIndicator(
                          color: Colors.red,
                          value: widget.item!.checkpoint! / 960,
                        ),
                      )
                    : const SizedBox(),
                Container(
                  color: AppColor.lightGray,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          _showInfo(context);
                        },
                        icon: const FaIcon(FontAwesomeIcons.circleExclamation),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
