import 'package:flutter/material.dart';

import '../presentation/theme/app_typography.dart';

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
}
