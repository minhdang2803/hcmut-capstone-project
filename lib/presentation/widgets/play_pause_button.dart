import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_color.dart';

class PlayPauseButton extends StatelessWidget {
  const PlayPauseButton({
    Key? key,
    this.enabled = true,
    required this.controller,
    required this.onItemClick,
  }) : super(key: key);

  final bool enabled;
  final AnimationController controller;
  final VoidCallback onItemClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemClick,
      child: Container(
        alignment: Alignment.center,
        width: 28.r,
        height: 28.r,
        decoration: BoxDecoration(
          color: enabled ? AppColor.primary : Colors.grey,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: AnimatedIcon(
          icon: AnimatedIcons.play_pause,
          progress: controller,
          color: Colors.white,
          size: 24.r,
        ),
      ),
    );
  }
}
