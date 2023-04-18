import 'package:bke/presentation/theme/app_color.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.controller,
    this.borderRadius = 30,
    this.onChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final double? borderRadius;
  final void Function(String)? onChanged;
  final void Function(String)? onSubmitted;
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      expands: false,
      maxLength: 40,
      controller: widget.controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius!),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius!),
          borderSide: BorderSide.none,
        ),
      ),
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );
  }
}

class CustomLookupTextField extends StatefulWidget {
  const CustomLookupTextField(
      {super.key,
      required this.controller,
      this.borderRadius = 30,
      this.onChanged,
      required this.onSubmitted,
      this.hintText});

  final TextEditingController controller;
  final double? borderRadius;
  final void Function(String)? onChanged;
  final void Function(String) onSubmitted;
  final String? hintText;
  @override
  State<CustomLookupTextField> createState() => _CustomLookupTextFieldState();
}

class _CustomLookupTextFieldState extends State<CustomLookupTextField> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      child: TextField(
        controller: widget.controller,
        cursorColor: AppColor.secondary,
        decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () => widget.onSubmitted!(widget.controller.text),
            icon: Icon(Icons.search),
          ),
          hintText: widget.hintText ?? "Nhập từ vựng cần tìm kiếm",
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius!),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.borderRadius!),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
      ),
    );
  }
}
