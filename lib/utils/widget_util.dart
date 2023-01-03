import 'package:flutter/material.dart';

import '../presentation/theme/app_typography.dart';
import '../presentation/widgets/cvn_dialog.dart';

class WidgetUtil {
  static void showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: AppTypography.body.copyWith(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget buildThemeButton(
      {required Widget widget,
      required Color color,
      double? elevation,
      double? width,
      double? height,
      double? borderRadius,
      required void Function()? function}) {
    return SizedBox(
      height: height,
      width: width,
      child: ElevatedButton(
        style: ButtonStyle(
          elevation: MaterialStateProperty.all<double?>(elevation),
          backgroundColor: MaterialStateProperty.all<Color>(color),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius ?? 18.0),
              side: const BorderSide(color: Colors.transparent),
            ),
          ),
        ),
        onPressed: function,
        child: widget,
      ),
    );
  }

  static Future<bool?> showDialog({
    VoidCallback? onAccepted,
    VoidCallback? onDismissed,
    required BuildContext context,
    required String title,
    required String message,
  }) {
    return showGeneralDialog<bool?>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'label',
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, _, __) {
        return CVNDialog(
          title: title,
          message: message,
          onAccepted: () {
            Navigator.of(ctx).pop(true);
            if (onAccepted != null) {
              onAccepted();
            }
          },
          onDismissed: () {
            Navigator.of(ctx).pop(false);
            if (onDismissed != null) {
              onDismissed();
            }
          },
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }
        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
}
