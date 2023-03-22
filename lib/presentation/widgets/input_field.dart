import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/models/search/search_model.dart';
import '../pages/main/components/monastery_search_delegate.dart';

class InputField extends StatelessWidget {
  const InputField({
    Key? key,
    this.hintText,
    this.hintStyle,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.onChange,
    this.focusNode,
    this.color
  }) : super(key: key);

  final String? hintText;
  final TextStyle? hintStyle;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final Function(String)? onChange;
  final FocusNode? focusNode;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      
      onTap: () {
                showSearch(
                  context: context,
                  delegate: MonasterySearchDelegate(searchType: SearchType.all),
                );
              },
      decoration: InputDecoration(
        filled: true,
        fillColor: color,
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(15.r),  
        ),

        hintText: hintText,
        hintStyle: hintStyle,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
      ),
      textInputAction: TextInputAction.search,
      keyboardType: TextInputType.text,
    );
  }
}
