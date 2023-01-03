import 'package:flutter/material.dart';

class CircleBorderContainer extends StatelessWidget {
  const CircleBorderContainer({
    Key? key,
    required this.radius,
    required this.borderColor,
    required this.borderWidth,
    this.backgroundColor,
    this.elevation,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  final double radius;
  final Color borderColor;
  final Color? backgroundColor;
  final double? borderWidth;
  final Widget child;
  final VoidCallback? onPressed;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: PhysicalModel(
        color: backgroundColor ?? Colors.white,
        shape: BoxShape.circle,
        elevation: elevation ?? 0,
        child: Container(
          width: radius,
          height: radius,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: borderColor,
              width: borderWidth ?? 0,
              style: BorderStyle.solid,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
