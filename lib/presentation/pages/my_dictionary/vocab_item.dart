import 'package:auto_size_text/auto_size_text.dart';
import 'package:bke/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/vocab/vocab.dart';
import '../../theme/app_color.dart';
import '../../theme/app_typography.dart';

class VocabDictionaryItem extends StatefulWidget {
  const VocabDictionaryItem(
      {super.key,
      required this.vocab,
      this.color = Colors.white,
      this.textColor = AppColor.primary});

  final LocalVocabInfo vocab;
  final Color? color;
  final Color? textColor;

  @override
  State<VocabDictionaryItem> createState() => _VocabDictionaryItemState();
}

class _VocabDictionaryItemState extends State<VocabDictionaryItem> {
  String _translation = "";
  @override
  void initState() {
    super.initState();
    concat();
  }

  void concat() {
    for (var trans in widget.vocab.translate) {
      _translation += " ${trans.vi};";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.r),
      height: 60.h,
      decoration: BoxDecoration(
        color: widget.color,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: _buildVocabPanel(),
    );
  }

  Widget _buildVocabPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              widget.vocab.vocab.toCapitalize(),
              style: AppTypography.title.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColor.primary,
              ),
            ),
            5.horizontalSpace,
            Text(
              "(${widget.vocab.vocabType})",
              style: AppTypography.body.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColor.secondary,
              ),
            ),
          ],
        ),
        5.verticalSpace,
        Flexible(
          child: Text(
            _translation,
            style: AppTypography.body,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
