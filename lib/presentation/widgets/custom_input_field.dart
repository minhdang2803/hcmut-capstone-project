import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_color.dart';
import '../theme/app_typography.dart';

class CVNInputField extends StatelessWidget {
  const CVNInputField({
    Key? key,
    this.obscureText = false,
    required this.label,
    this.initialValue,
    this.textInputAction,
    this.maxLine = 1,
    this.textStyle,
    this.labelStyle,
    this.textInputType,
    this.textCapitalization,
    this.validator,
    this.onChanged,
  }) : super(key: key);

  final bool obscureText;
  final String label;
  final String? initialValue;
  final TextInputAction? textInputAction;
  final int maxLine;
  final TextStyle? textStyle;
  final TextStyle? labelStyle;
  final TextInputType? textInputType;
  final TextCapitalization? textCapitalization;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText,
      textInputAction: textInputAction,
      maxLines: maxLine,
      style: textStyle ?? AppTypography.body,
      keyboardType: textInputType ?? TextInputType.text,
      textCapitalization: textCapitalization ?? TextCapitalization.none,
      initialValue: initialValue,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(
            color: AppColor.primary,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(
            color: AppColor.inputTextBorder,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedErrorBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.r),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        labelText: label,
        labelStyle: labelStyle ?? AppTypography.bodySmall.copyWith(
          color: AppColor.textSecondary,
        ),
        floatingLabelStyle:  AppTypography.title.copyWith(
          color: AppColor.primary,
        ),
      ),
    );
  }
}
