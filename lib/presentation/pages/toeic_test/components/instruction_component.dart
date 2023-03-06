import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InstructionData {
  Map<String, String> instructionText;
  int part;
  InstructionData(this.instructionText, this.part);
}

class InstructionComponent extends StatelessWidget {
  const InstructionComponent({super.key, required this.instructionComponent});
  final InstructionData instructionComponent;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.9,
      height: MediaQuery.of(context).size.height * 0.4,
      child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          child: Padding(
            padding: EdgeInsets.all(20.r),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Instruction:",
                    style: AppTypography.title.apply(color: AppColor.primary),
                  ),
                  5.verticalSpace,
                  Text(
                    instructionComponent.instructionText['eng']!,
                    style: AppTypography.title,
                  ),
                  5.verticalSpace,
                  const Divider(thickness: 1, color: AppColor.primary),
                  Text(
                    "Hướng Dẫn:",
                    style: AppTypography.title.apply(color: AppColor.primary),
                  ),
                  5.verticalSpace,
                  Text(
                    instructionComponent.instructionText['vie']!,
                    style: AppTypography.title,
                  ),
                  5.verticalSpace,
                ],
              ),
            ),
          )),
    );
  }
}
