import 'package:bke/data/models/vocab/vocab.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/custom_app_bar.dart';
import 'package:bke/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/vocab/vocab_cubit.dart';

class VocabFullInfoPage extends StatefulWidget {
  const VocabFullInfoPage({super.key, required this.vocabInfo});
  final LocalVocabInfo vocabInfo;

  @override
  State<VocabFullInfoPage> createState() => _VocabFullInfoPageState();
}

class _VocabFullInfoPageState extends State<VocabFullInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            BkEAppBar(
              label: widget.vocabInfo.vocab,
              onBackButtonPress: () => Navigator.pop(context),
            ),
            _buildVocabInfoComponent(context)
          ],
        ),
      ),
    );
  }

  Expanded _buildVocabInfoComponent(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVocabTitle(context),
            10.verticalSpace,
            _buildVocabContent(context),
          ],
        ),
      ),
    );
  }

  Widget _buildVocabContent(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        height: double.minPositive,
        padding: EdgeInsets.all(20.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30.r),
          border: Border.all(
            width: 2,
            color: AppColor.primary,
          ),
        ),
        child: ListView(
          children: [
            Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: "- UK: ",
                    style: AppTypography.title.copyWith(
                        color: AppColor.primary, fontWeight: FontWeight.bold)),
                TextSpan(
                  text: widget.vocabInfo.pronounce.uk.toCapitalize(),
                  style: AppTypography.title,
                ),
              ]),
            ),
            Text.rich(
              TextSpan(children: [
                TextSpan(
                    text: "- US: ",
                    style: AppTypography.title.copyWith(
                        color: AppColor.primary, fontWeight: FontWeight.bold)),
                TextSpan(
                  text: widget.vocabInfo.pronounce.us.toCapitalize(),
                  style: AppTypography.title,
                ),
              ]),
            ),
            10.verticalSpace,
            ...widget.vocabInfo.translate.map((e) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    color: AppColor.primary,
                    thickness: 2,
                  ),
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: "- English: ",
                          style: AppTypography.title.copyWith(
                              color: AppColor.primary,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: e.en.toCapitalize(),
                        style: AppTypography.title,
                      ),
                    ]),
                  ),
                  5.verticalSpace,
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: "- Tiếng Việt: ",
                          style: AppTypography.title.copyWith(
                              color: AppColor.primary,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: e.vi.toCapitalize(),
                        style: AppTypography.title,
                      ),
                    ]),
                  ),
                  5.verticalSpace,
                  Text.rich(
                    TextSpan(children: [
                      TextSpan(
                          text: "- Example(ví dụ): ",
                          style: AppTypography.title.copyWith(
                              color: AppColor.primary,
                              fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: e.example.toCapitalize(),
                        style: AppTypography.title,
                      ),
                    ]),
                  ),
                ],
              );
            }).toList()
          ],
        ),
      ),
    );
  }

  Widget _buildVocabTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              widget.vocabInfo.vocab.toCapitalize(),
              style: AppTypography.headline,
            ),
            10.horizontalSpace,
            Text(
              "(${widget.vocabInfo.vocabType})",
              style: AppTypography.headline.copyWith(color: AppColor.primary),
            ),
          ],
        ),
        IconButton(
          onPressed: () {
            context
                .read<VocabCubit>()
                .deleteFromMyDictionary(widget.vocabInfo.id);
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.delete,
            size: 25.r,
          ),
        )
      ],
    );
  }
}
