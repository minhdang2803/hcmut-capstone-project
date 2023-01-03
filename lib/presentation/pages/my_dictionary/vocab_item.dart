import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/vocab/vocab_cubit.dart';
import '../../../data/models/vocab/vocab.dart';
import '../../theme/app_color.dart';
import '../../theme/app_typography.dart';
import '../../widgets/holder_widget.dart';

class VocabDictionaryItem extends StatefulWidget {
  const VocabDictionaryItem({super.key, required this.vocab, this.borderColor});

  final LocalVocabInfo vocab;
  final Color? borderColor;

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
        height: 60.h,
        padding: EdgeInsets.symmetric(vertical: 5.r),
        decoration: BoxDecoration(
          borderRadius: widget.borderColor != null
              ? BorderRadius.circular(5.r)
              : BorderRadius.circular(0),
          border: Border.all(
              width: 1.r,
              color: widget.borderColor != null
                  ? AppColor.primary
                  : AppColor.lightGray),
        ),
        child: _buildVocabPanel());
  }

  Widget _buildVocabPanel() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  widget.vocab.vocab,
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
          ],
        ),
        5.verticalSpace,
        AutoSizeText(
          _translation,
          style: AppTypography.bodySmall,
          maxLines: 2,
        ),
      ],
    );
  }
}
