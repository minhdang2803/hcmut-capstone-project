import 'package:flutter/material.dart';

class FlyingText extends StatefulWidget {
  @override
  _FlyingTextState createState() => _FlyingTextState();
}

class _FlyingTextState extends State<FlyingText> {
  double _top = 0;
  double _left = 0;

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(seconds: 2),
      curve: Curves.easeInOut,
      top: _top,
      left: _left,
      child: GestureDetector(
        onTap: () {
          setState(() {
            _top = 200;
            _left = 200;
          });
        },
        child: Text(
          "Fly me!",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}