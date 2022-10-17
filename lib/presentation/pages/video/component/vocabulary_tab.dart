import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:like_button/like_button.dart';

import '../../../../bloc/vocab/vocab_cubit.dart';
import '../../../../data/models/vocab/vocab.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';

class VocabularyTab extends StatefulWidget {
  const VocabularyTab({super.key, required this.vocabInfo});

  final VocabInfo vocabInfo;

  @override
  State<VocabularyTab> createState() => _VocabularyTabState();
}

class _VocabularyTabState extends State<VocabularyTab> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.r),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 3.r, color: AppColor.secondary),
              borderRadius: BorderRadius.circular(16.h),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: _buildTranslateTab(widget.vocabInfo),
            ),
          ),
          _buildLikeButton(widget.vocabInfo),
        ],
      ),
    );
  }

  Widget _buildTranslateTab(VocabInfo vocabInfo) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: vocabInfo.translate
          .map(
            (e) => Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                10.verticalSpace,
                Text(e.vi, style: AppTypography.title),
                5.verticalSpace,
                Text(e.en, style: AppTypography.body),
                5.verticalSpace,
                Text(e.example, style: AppTypography.body),
                10.verticalSpace,
                Divider(height: 1.r, color: Colors.black38),
              ],
            ),
          )
          .toList(),
    );
  }

  Widget _buildLikeButton(VocabInfo vocabInfo) {
    final myDictionary = BlocProvider.of<VocabCubit>(context).getAll();

    final vocabIdList = myDictionary.map((e) => e.id).toList();
    final isLiked = vocabIdList.contains(vocabInfo.id);
    return LikeButton(
      likeBuilder: (isLiked) {
        return Icon(
          Icons.star_rounded,
          size: 25.r,
          color: isLiked ? Colors.amber : Colors.black38,
        );
      },
      likeCountPadding: EdgeInsets.zero,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      isLiked: isLiked,
      onTap: (isLiked) async {
        if (isLiked == true) {
          context.read<VocabCubit>().deleteFromMyDictionary(vocabInfo.id);
        } else {
          context.read<VocabCubit>().saveToMyDictionary(LocalVocabInfo.fromJson(
              {"vocab": vocabInfo.vocab, "id": vocabInfo.id}));
        }
        setState(() {
          isLiked = !isLiked;
        });
        return isLiked;
      },
    );
  }
}
