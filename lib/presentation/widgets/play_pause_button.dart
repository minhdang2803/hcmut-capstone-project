import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_color.dart';

class PlayPauseButton extends StatefulWidget {
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
  State<PlayPauseButton> createState() => _PlayPauseButtonState();
}

class _PlayPauseButtonState extends State<PlayPauseButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animatedContainer;
  @override
  void initState() {
    super.initState();
    _animatedContainer = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onItemClick,
      child: Container(
        alignment: Alignment.center,
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: widget.enabled ? AppColor.primary : Colors.grey,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Center(
          child: AnimatedIcon(
            icon: AnimatedIcons.play_pause,
            progress: widget.controller,
            color: Colors.white,
            size: widget.size,
          ),
        ),
      ),
    );
  }
}
