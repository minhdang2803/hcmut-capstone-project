import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:skeletons/skeletons.dart';

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
          listener: (context, state) {
            if (state is VocabSuccess) {
              setState(() {
                _vocabInfos = state.data;
              });
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
                      _vocabInfos?.list[0].vocab ?? '',
                      style: AppTypography.headline.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary,
                      ),
                    ),
                    10.verticalSpace,
                    Row(
                      children: [
                        _buildPronounce(
                          "UK",
                          _vocabInfos?.list[0].pronounce.uk ?? '',
                        ),
                      ],
                    ),
                    10.verticalSpace,
                    Divider(height: 1.r, color: Colors.black38),
                    10.verticalSpace,
                    Text(
                      _vocabInfos?.list[0].translate[0].vn ?? '',
                      style: AppTypography.title,
                    ),
                    5.verticalSpace,
                    Text(
                      _vocabInfos?.list[0].translate[0].en ?? '',
                      style: AppTypography.body,
                    ),
                    5.verticalSpace,
                    Text(
                      _vocabInfos?.list[0].translate[0].example ?? '',
                      style: AppTypography.body,
                    ),
                    10.verticalSpace,
                    Divider(height: 1.r, color: Colors.black38),
                    10.verticalSpace,
                    Text(
                      _vocabInfos?.list[0].translate[0].vn ?? '',
                      style: AppTypography.title,
                    ),
                    5.verticalSpace,
                    Text(
                      _vocabInfos?.list[0].translate[0].en ?? '',
                      style: AppTypography.body,
                    ),
                    5.verticalSpace,
                    Text(
                      _vocabInfos?.list[0].translate[0].example ?? '',
                      style: AppTypography.body,
                    ),
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
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColor.secondary,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      width: 30.r,
                      child: Center(
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: Text(
                            _vocabInfos?.list[0].vocabType ?? '',
                            style: AppTypography.subHeadline,
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
                    _vocabInfos?.list[0].vocab ?? '',
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
