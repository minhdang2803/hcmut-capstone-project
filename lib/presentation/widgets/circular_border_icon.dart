import 'package:flutter/material.dart';

class CircularBorderIcon extends StatelessWidget {
  const CircularBorderIcon({
    Key? key,
    required this.icon,
    required this.borderColor,
    required this.onIconClick,
    this.borderWidth = 1.0,
    this.iconPadding = 10,
  }) : super(key: key);

  final Widget icon;
  final Color borderColor;
  final double iconPadding;
  final double borderWidth;
  final VoidCallback onIconClick;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onIconClick,
      child: Container(
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: borderColor,
              width: borderWidth,
            )),
        child: Padding(
          padding: EdgeInsets.all(iconPadding),
          child: icon,
        ),
      ),
    );
  }
}
