import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';
import 'package:translator/translator.dart';

import '../../../../bloc/vocab/vocab_cubit.dart';
import '../../../../data/models/vocab/vocab.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/holder_widget.dart';

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
  final List<List<TranslateInfo>> _translateInfoList = [];
  int _currentTab = 0;

  String _translateFromGG = '';

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
          color: Colors.white,
        ),
        child: BlocConsumer<VocabCubit, VocabState>(
          listener: (context, state) async {
            if (state is VocabSuccess) {
              setState(() {
                _vocabInfos = state.data;
                if (_vocabInfos != null) {
                  _vocabTypeList
                      .addAll(_vocabInfos!.list.map((e) => e.vocabType));
                  _translateInfoList
                      .addAll(_vocabInfos!.list.map((e) => e.translate));
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
                : _buildVocabPanel();
          },
        ),
      ),
    );
  }

  Widget _buildVocabPanel() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 18.r),
      child: FadeTransition(
        opacity: _animationEaseIn,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      widget.text,
                      style: AppTypography.headline.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                    10.verticalSpace,
                    // Row(
                    //   children: [
                    //     _buildPronounce(
                    //       "UK",
                    //       _vocabInfos?.list[0].pronounce.uk ?? '',
                    //     ),
                    //   ],
                    // ),
                    _buildTranslate(),
                  ],
                ),
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
                    child: _buildVocabTypes(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPronounce(String textUKUS, String pronounce) {
    return Expanded(
      child: Row(
        children: [
          Text(
            '$textUKUS: ',
            style: AppTypography.bodySmall.copyWith(color: Colors.black45),
          ),
          Text(
            pronounce,
            style: AppTypography.body,
          ),
        ],
      ),
    );
  }

  Widget _buildTranslate() {
    return _translateInfoList.isNotEmpty
        ? Column(
            children: _translateInfoList[_currentTab]
                .map(
                  (e) => Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      10.verticalSpace,
                      Divider(height: 1.r, color: Colors.black38),
                      10.verticalSpace,
                      Text(e.vn, style: AppTypography.title),
                      5.verticalSpace,
                      Text(e.en, style: AppTypography.body),
                      5.verticalSpace,
                      Text(e.example, style: AppTypography.body),
                    ],
                  ),
                )
                .toList(),
          )
        : SizedBox(
            child: Text(_translateFromGG),
          );
  }

  Widget _buildVocabTypes() {
    return Column(
      children: _vocabTypeList
          .map(
            (e) => Expanded(
              child: Column(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() {
                        _currentTab = _vocabTypeList.indexOf(e);
                      }),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColor.secondary,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        width: 28.r,
                        child: Center(
                          child: RotatedBox(
                            quarterTurns: 1,
                            child: Text(
                              e,
                              style: AppTypography.body
                                  .copyWith(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8.r),
                ],
              ),
            ),
          )
          .toList(),
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
                    widget.text,
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
                  Divider(height: 1.r, color: Colors.black38),
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
