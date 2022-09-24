import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Align(
        alignment: Alignment.topCenter,
        child: Image.asset(
          'assets/images/auth_header_bg.png',
          width: 1.sw,
          fit: BoxFit.fitWidth,
        ),
      ),
      Align(
        alignment: Alignment.bottomRight,
        child: KeyboardVisibilityBuilder(builder: (ctx, isKeyboardVisible) {
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 100),
            child: isKeyboardVisible
                ? const SizedBox()
                : Image.asset(
                    'assets/images/auth_footer_bg.png',
                    height: 0.15.sh,
                    fit: BoxFit.fitHeight,
                  ),
          );
        }),
      )
    ]);
  }
}
