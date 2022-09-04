import 'package:flutter/material.dart';

class TextShapeCircle extends StatelessWidget {
  const TextShapeCircle({Key? key, required this.text, required this.color})
      : super(key: key);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.height * 0.1,
      height: size.height * 0.1,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      child: Text(text,
          style: TextStyle(
              color: Colors.white,
              fontSize: size.height * 0.03,
              fontWeight: FontWeight.bold)),
    );
  }
}
