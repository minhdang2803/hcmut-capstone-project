import 'package:bke/presentation/theme/app_typography.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BkECustomDropdown extends StatefulWidget {
  const BkECustomDropdown({
    super.key,
    required this.items,
    required this.onSelected,
    this.textStyle,
  });
  final List<int> items;
  final void Function(int) onSelected;
  final TextStyle? textStyle;
  @override
  State<BkECustomDropdown> createState() => _BkECustomDropdownState();
}

class _BkECustomDropdownState extends State<BkECustomDropdown> {
  IconData iconData = Icons.arrow_drop_down;
  int selectedValue = 1;
  @override
  Widget build(BuildContext context) {
    return DropdownButton2(
      underline: SizedBox(),
      style: widget.textStyle ?? AppTypography.title,
      customButton: Container(
        padding: EdgeInsets.all(5.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.r),
          border: Border.all(color: Colors.black),
        ),
        height: 30.r,
        width: 50.r,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text(selectedValue.toString()), Icon(iconData)],
        ),
      ),
      onMenuStateChange: (isOpen) {
        setState(() {
          iconData = isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down;
        });
      },
      iconStyleData: IconStyleData(icon: Icon(iconData)),
      dropdownStyleData: DropdownStyleData(
        maxHeight: 150.h,
        elevation: 1,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r)),
        direction: DropdownDirection.textDirection,
      ),
      alignment: AlignmentDirectional.bottomEnd,
      items: widget.items
          .map((e) => DropdownMenuItem<int>(
              alignment: AlignmentDirectional.center,
              value: e,
              child: Text(
                e.toString(),
                style: widget.textStyle ?? AppTypography.title,
              )))
          .toList(),
      value: selectedValue,
      onChanged: (value) {
        setState(() {
          selectedValue = value!;
          widget.onSelected(value);
        });
      },
    );
  }
}
