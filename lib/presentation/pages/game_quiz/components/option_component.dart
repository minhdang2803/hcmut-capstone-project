import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_html_css/simple_html_css.dart';

class OptionComponent extends StatelessWidget {
  final Function selectHandler;
  final String answerText;

  const OptionComponent(this.selectHandler, this.answerText, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150.w,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.orange.shade500,
          fixedSize: Size(100.w, 80.h),
          elevation: 8,
        ),
        child: RichText(
          text: HTML.toTextSpan(
            context,
            answerText,
            overrideStyle: {
              "u": const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              // specify any tag not just the supported ones,
              // and apply TextStyles to them and/override them
            },
            defaultTextStyle: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.white,
              letterSpacing: 1.0,
            ),
          ),
        ),
        onPressed: () => selectHandler(),
      ),
    );
  }
}
