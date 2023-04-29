import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MessageTitle extends StatefulWidget {
  const MessageTitle(
      {super.key,
      required this.message,
      required this.sendByMe,
      required this.sender});
  final String message;
  final bool sendByMe;
  final String sender;
  @override
  State<MessageTitle> createState() => _MessageTitleState();
}

class _MessageTitleState extends State<MessageTitle> {
  @override
  Widget build(BuildContext context) {
    final color = widget.sendByMe ? Colors.white : AppColor.textSecondary;
    return Container(
      margin: widget.sendByMe
          ? EdgeInsets.only(left: 100.r)
          : EdgeInsets.only(right: 100.r),
      width: MediaQuery.of(context).size.width * 0.5,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: widget.sendByMe ? AppColor.mainPink : AppColor.greyBackground,
        borderRadius: widget.sendByMe
            ? BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
                bottomLeft: Radius.circular(20.r),
              )
            : BorderRadius.only(
                topLeft: Radius.circular(20.r),
                topRight: Radius.circular(20.r),
                bottomRight: Radius.circular(20.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.sender.toCapitalize(),
            style: AppTypography.body.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          5.verticalSpace,
          SizedBox(
            child: Text(widget.message,
                style: AppTypography.body.copyWith(
                  color: color,
                )),
          )
        ],
      ),
    );
  }
}
