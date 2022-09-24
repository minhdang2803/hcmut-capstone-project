import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CVNLoading extends StatelessWidget {
  const CVNLoading({Key? key, required this.width}) : super(key: key);

  final double width;
  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      'assets/lotties/loading.json',
      fit: BoxFit.contain,
      width: width,
    );
  }
}
