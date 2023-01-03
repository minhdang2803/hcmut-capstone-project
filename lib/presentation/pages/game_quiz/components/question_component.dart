import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QuestionComponent extends StatelessWidget {
  final String? questionText;

  const QuestionComponent(this.questionText, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(30.w),
      decoration: BoxDecoration(
        color: Colors.orange.shade600,
      ),
      margin: const EdgeInsets.all(10),
      child: Text(
        questionText!,
        style: const TextStyle(
          fontSize: 28,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ), //Text
    ); //Contaier
  }
}
