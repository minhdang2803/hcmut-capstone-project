import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_color.dart';

class FlipCard extends StatefulWidget {
  FlipCard({
    Key? key,
    this.front,
    this.back,
    this.angle,
  }) : super(key: key);
  final Widget? front;
  final Widget? back;
  double? angle;
  void Function(Offset)? onSwipeLeft;
  void Function(Offset)? onSwipeRight;
  @override
  State<FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> {
  bool isBack = true;

  // void _flip() {
  //   setState(() {
  //     widget.angle = (widget.angle! + pi) % (2 * pi);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(30.r),
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: widget.angle),
        duration: const Duration(milliseconds: 300),
        builder: (BuildContext context, double val, _) {
          //here we will change the isBack val so we can change the content of the card

          if (val >= (pi / 2)) {
            isBack = false;
          } else {
            isBack = true;
          }
          return Container(
            decoration: BoxDecoration(
              color: AppColor.greyBackground,
              borderRadius: BorderRadius.circular(30.r),
            ),
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(val),
              child: _buildCard(
                child: isBack
                    ? _buildEachInterface(
                        child:
                            widget.front ?? const Center(child: Text('Front')),
                      )
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.identity()..rotateY(pi),
                        child: _buildEachInterface(
                          child:
                              widget.back ?? const Center(child: Text('Back')),
                        ),
                      ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      height: 400.h,
      width: 300.w,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.primary, width: 3),
        borderRadius: BorderRadius.circular(30.r),
        color: Colors.white,
      ),
      child: child,
    );
  }

  Widget _buildEachInterface({required Widget child}) {
    return Container(
      height: 400.h,
      width: 300.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: child,
    );
  }
}
