import 'package:flutter/material.dart';

class RoundedElevatedButton extends StatelessWidget {
  const RoundedElevatedButton({
    Key? key,
    required this.label,
    required this.width,
    required this.height,
    required this.radius,
    required this.onPressed,
    this.labelStyle,
    this.elevation,
    this.backgroundColor,
    this.labelColor,
  }) : super(key: key);

  final String label;
  final TextStyle? labelStyle;
  final double radius;
  final double width;
  final double height;
  final double? elevation;
  final Color? backgroundColor;
  final Color? labelColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: labelColor,
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius), // <-- Radius
          ),
          elevation: elevation,
        ),
        onPressed: onPressed,
        child: FittedBox(
          child: Text(
            label,
            style: labelStyle,
          ),
        ),
      ),
    );
  }
}
