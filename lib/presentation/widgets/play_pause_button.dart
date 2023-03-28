import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_color.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    Key? key,
    this.enabled = true,
    required this.controller,
    required this.onItemClick,
    this.size = 24,
  }) : super(key: key);

  final bool enabled;
  final AnimationController controller;
  final double? size;
  final VoidCallback onItemClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemClick,
      child: Container(
        alignment: Alignment.center,
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: enabled ? AppColor.mainPink : Colors.grey,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Center(
          child: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: controller,
            color: Colors.white,
            size: size,
          ),
        ),
      ),
    );
  }
}
