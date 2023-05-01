import 'package:flutter/material.dart';

import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';

class AuthInputField extends StatefulWidget {
  const AuthInputField({
    Key? key,
    required this.hintText,
    required this.inputAction,
    required this.inputType,
    required this.validator,
    required this.onChange,
    this.capitalization,
    this.focusNode,
    this.enableErrorText = false,
    this.obscure = false,
    this.showHintError = false,
  }) : super(key: key);

  final String hintText;
  final TextInputAction inputAction;
  final TextInputType inputType;
  final FormFieldValidator<String> validator;
  final Function(String) onChange;
  final bool obscure;
  final bool enableErrorText;
  final bool showHintError;
  final FocusNode? focusNode;
  final TextCapitalization? capitalization;

  @override
  State<AuthInputField> createState() => _AuthInputFieldState();
}

class _AuthInputFieldState extends State<AuthInputField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscure;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: AppColor.textSecondary,
      focusNode: widget.focusNode,
      textCapitalization: widget.capitalization ?? TextCapitalization.none,
      
      decoration: InputDecoration(
      
        border: const UnderlineInputBorder(
          
            borderSide: BorderSide(color: AppColor.secondary)),
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColor.secondary)),
        hintText: widget.hintText,
        hintStyle: widget.showHintError
            ? AppTypography.body.copyWith(color: AppColor.falseColor)
            : AppTypography.body.copyWith(color: AppColor.textSecondary),
        suffixIcon: widget.obscure
            ? IconButton(
                focusNode: FocusNode(skipTraversal: true),
                icon: Icon(
                  _isObscure ? Icons.visibility : Icons.visibility_off,
                  color: AppColor.defaultBorder,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              )
            : null,
        errorStyle: widget.enableErrorText ? null : const TextStyle(height: 0),
        counterText: widget.enableErrorText ? ' ' : null,
      ),
      textInputAction: widget.inputAction,
      keyboardType: widget.inputType,
      validator: widget.validator,
      onChanged: widget.onChange,
      obscureText: _isObscure,
      maxLines: 1,
      style: widget.showHintError
          ? AppTypography.body.copyWith(color: AppColor.falseColor)
          : AppTypography.body.copyWith(color: AppColor.textSecondary),
    );
  }
}
