import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/utils/extension.dart';
import 'package:bke/utils/word_processing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class MessageTitle extends StatefulWidget {
  const MessageTitle({
    super.key,
    required this.message,
    required this.sendByMe,
    required this.sender,
    required this.time,
  });
  final String message;
  final bool sendByMe;
  final String sender;
  final int time;
  @override
  State<MessageTitle> createState() => _MessageTitleState();
}

class _MessageTitleState extends State<MessageTitle> {
  bool isVisibleTime = false;
  final WordProcessing wordProcessing = WordProcessing.instance();
  @override
  Widget build(BuildContext context) {
    final clm = DateTime.fromMicrosecondsSinceEpoch(widget.time * 1000);
    final color = widget.sendByMe ? Colors.white : AppColor.textSecondary;
    return GestureDetector(
      onLongPressUp: () {
        setState(() {
          isVisibleTime = !isVisibleTime;
        });
      },
      child: Container(
        margin: widget.sendByMe
            ? EdgeInsets.only(left: 100.r, right: 10.r)
            : EdgeInsets.only(right: 100.r, left: 10.r),
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
                child: Text.rich(
              TextSpan(
                  children: wordProcessing.createTextSpans(
                      context,
                      widget.message,
                      AppTypography.body.copyWith(color: color))),
            )),
            Visibility(
              visible: isVisibleTime,
              child: Column(
                children: [
                  5.verticalSpace,
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      DateFormat('dd/MM/yyyy, HH:mm').format(clm).toString(),
                      style: AppTypography.bodySmall.copyWith(color: color),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
