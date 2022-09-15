import 'package:flutter/material.dart';

class Utils {
  static Widget buildResponsiveWidget(
      Orientation orientation, Widget widget1, Widget widget2) {
    return orientation == Orientation.portrait ? widget1 : widget2;
  }
}
