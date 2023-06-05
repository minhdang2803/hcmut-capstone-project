import 'package:bke/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';
import 'package:translator/translator.dart';

import '../../../../bloc/vocab/vocab_cubit.dart';
import '../../../../data/models/vocab/vocab.dart';
import '../../../../utils/constants.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/holder_widget.dart';
import 'vocabulary_tab.dart';

class BottomVocab extends StatefulWidget {
  const BottomVocab({super.key, required this.text});

  final String text;
  @override
  State<BottomVocab> createState() => _BottomVocabState();
}

class _BottomVocabState extends State<BottomVocab>
    with SingleTickerProviderStateMixin {
  VocabInfos? _vocabInfos;
  final List<String> _vocabTypeList = [];
  final List<List<VocabInfo>> _translateInfoList = [];
  int _currentTab = 0;

  String _translateFromGG = '';

  bool isLiked = true;

  // for animation loading //////////
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  )..forward();

  late final Animation<double> _animationEaseIn = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  late final Animation<double> _animationEaseOut = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );
  ///////////////////////////////////

  @override
  void initState() {
    super.initState();

    // context.read<VocabCubit>().getVocab('can');
    context.read<VocabCubit>().getVocab(widget.text);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: Container(
        height: 290.h,
        padding: EdgeInsets.symmetric(vertical: 16.r),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: AppColor.primary,
        ),
        child: BlocConsumer<VocabCubit, VocabState>(
          listener: (context, state) async {
            if (state is VocabSuccess) {
              setState(() {
                _vocabInfos = state.data;
                if (_vocabInfos != null) {
                  for (var element in _vocabInfos!.list) {
                    if (!_vocabTypeList.contains(element.vocabType)) {
                      // if (element.vocabType.isEmpty) {
                      //   _vocabTypeList.add("Idiom");
                      // } else {
                      //   _vocabTypeList.add(element.vocabType);
                      // }
                      _vocabTypeList.add(element.vocabType);
                    }
                  }

                  // map data thành list các tab, động từ, giới từ ,....
                  for (var element in _vocabTypeList) {
                    final wordTab = _vocabInfos!.list.where((e) {
                      // if (e.vocabType.isEmpty) {
                      //   return element == "Idiom";
                      // }
                      return e.vocabType == element;
                    }).toList();

                    _translateInfoList.add(wordTab);
                  }
                }
              });

              if (_vocabTypeList.isEmpty) {
                // https://www.youtube.com/watch?v=zwrC2vigls8
                final translation = await widget.text.translate(to: 'vi');
                setState(() {
                  _translateFromGG = translation.text;
                });
              }
            }
          },
          builder: (context, state) {
            if (state is VocabFailure) {
              return const HolderWidget(
                asset: 'assets/images/default_logo.png',
                message: 'Fail to load dictionary!',
              );
            }
            return _vocabInfos == null
                ? _buildLoadingSkeleton()
                : _buildVocabPanel(context);
          },
        ),
      ),
    );
  }

  Widget _buildVocabPanel(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.r),
      child: FadeTransition(
        opacity: _animationEaseIn,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.text
                            .toCapitalize()
                            .replaceAll(Constants.charactersToRemove, ''),
                        style: AppTypography.headline.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColor.textPrimary,
                        ),
                      ),
                      5.verticalSpace,
                      _buildVocabTypes(),
                    ],
                  ),
                ],
              ),
              10.verticalSpace,
              _buildTranslate(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTranslate() {
    return _translateInfoList.isNotEmpty
        ? Column(
            children: _translateInfoList[_currentTab]
                .map((e) => VocabularyTab(vocabInfo: e))
                .toList(),
          )
        : SizedBox(
            child: Text(
            _translateFromGG,
            style: AppTypography.title,
          ));
  }

  Widget _buildVocabTypes() {
    return SizedBox(
      width: 250.w,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: _vocabTypeList
              .map(
                (e) => Padding(
                  padding: EdgeInsets.only(right: 10.r),
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _currentTab = _vocabTypeList.indexOf(e);
                    }),
                    child: Container(
                      decoration: BoxDecoration(
                        color: _vocabTypeList[_currentTab] == e
                            ? AppColor.secondary
                            : AppColor.darkGray,
                        border:
                            Border.all(width: 1.r, color: AppColor.secondary),
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 6.r, vertical: 2.r),
                        child: Center(
                          child: Text(
                              e.isEmpty ? "Function word" : e.toCapitalize(),
                              style: _vocabTypeList.length > 2
                                  ? AppTypography.bodySmall.copyWith(
                                      color: _vocabTypeList[_currentTab] == e
                                          ? AppColor.textPrimary
                                          : AppColor.textSecondary)
                                  : AppTypography.body.copyWith(
                                      color: _vocabTypeList[_currentTab] == e
                                          ? AppColor.textPrimary
                                          : AppColor.textSecondary)),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return FadeTransition(
      opacity: _animationEaseOut,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.r),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    widget.text.replaceAll(Constants.charactersToRemove, ''),
                    style: AppTypography.headline.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary,
                    ),
                  ),
                  10.verticalSpace,
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 17.r,
                      borderRadius: BorderRadius.circular(8),
                      minLength: 110.r,
                      maxLength: 130.r,
                    ),
                  ),
                  10.verticalSpace,
                  Divider(height: 1.r, color: AppColor.defaultBorder),
                  10.verticalSpace,
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 19.r,
                      borderRadius: BorderRadius.circular(8),
                      minLength: 110.r,
                      maxLength: 130.r,
                    ),
                  ),
                  5.verticalSpace,
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 18.r,
                      borderRadius: BorderRadius.circular(8),
                      width: double.infinity,
                    ),
                  ),
                  5.verticalSpace,
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 18.r,
                      borderRadius: BorderRadius.circular(8),
                      minLength: 200.r,
                      maxLength: 220.r,
                    ),
                  ),
                  10.verticalSpace,
                  Divider(height: 1.r, color: Colors.black38),
                  10.verticalSpace,
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 19.r,
                      borderRadius: BorderRadius.circular(8),
                      minLength: 110.r,
                      maxLength: 140.r,
                    ),
                  ),
                  5.verticalSpace,
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 18.r,
                      borderRadius: BorderRadius.circular(8),
                      width: double.infinity,
                    ),
                  ),
                  5.verticalSpace,
                  SkeletonLine(
                    style: SkeletonLineStyle(
                      height: 18.r,
                      borderRadius: BorderRadius.circular(8),
                      minLength: 200.r,
                      maxLength: 220.r,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 50.r,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "US",
                    style: AppTypography.title,
                  ),
                  6.verticalSpace,
                  Text(
                    "UK",
                    style: AppTypography.title,
                  ),
                  20.verticalSpace,
                  Expanded(
                    child: SizedBox(
                      width: 30.r,
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: SkeletonLine(
                            style: SkeletonLineStyle(
                              height: double.infinity,
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
