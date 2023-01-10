import 'dart:math';

import 'package:bke/data/models/vocab/vocab.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/custom_app_bar.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FlashcardPageModel {
  final String collectionTitle;
  final List<LocalVocabInfo> vocabInfo;
  final int currentCollection;

  FlashcardPageModel({
    required this.collectionTitle,
    required this.vocabInfo,
    required this.currentCollection,
  });
}

class FlashCardScreen extends StatefulWidget {
  const FlashCardScreen({
    super.key,
    required this.vocabInfo,
    required this.currentCollection,
    required this.collectionTitle,
  });

  final String collectionTitle;
  final List<LocalVocabInfo> vocabInfo;
  final int currentCollection;
  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int _newIndex = 0;
  double angle = 0;
  late List<FlashcardComponentItem> item;
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildAppBar(context),
            _buildFlashcard(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return BkEAppBar(
      label: widget.collectionTitle,
      onBackButtonPress: () => Navigator.pop(context),
    );
  }

  Widget _buildFlashcard() {
    _newIndex =
        _currentIndex + 1 < widget.vocabInfo.length ? _currentIndex + 1 : 0;
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {},
              child: Draggable(
                  onDragEnd: (details) {
                    if (details.velocity.pixelsPerSecond.dx < 0) {
                      setState(() {
                        _currentIndex =
                            _currentIndex + 1 < widget.vocabInfo.length
                                ? _currentIndex + 1
                                : 0;
                      });
                    }
                    if (details.velocity.pixelsPerSecond.dx > 0) {
                      setState(() {
                        _currentIndex = _currentIndex > 0
                            ? _currentIndex - 1
                            : widget.vocabInfo.length - 1;
                      });
                    }
                  },
                  feedback: _buildCard(_currentIndex),
                  childWhenDragging: _buildCard(_newIndex),
                  child: _buildCard(_currentIndex)),
            ),
            _buildRoundedLinearProcessIndicator(),
            CustomButton(
              title: angle == 0 ? "Lập úp thẻ ghi nhớ" : "Lật ngửa thẻ ghi nhớ",
              onTap: () {
                setState(() => angle = (angle + pi) % (2 * pi));
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    return FlashcardComponentItem(
      angle: angle,
      front: Center(
        child: Text(widget.vocabInfo[index].vocab),
      ),
      back: Center(
        child: Text(widget.vocabInfo[index].id.toString()),
      ),
    );
  }

  Widget _buildRoundedLinearProcessIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 300.w,
          height: 15.h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.r),
            child: LinearProgressIndicator(
              backgroundColor: AppColor.secondary.withOpacity(0.5),
              value: (_currentIndex + 1) / widget.vocabInfo.length,
            ),
          ),
        ),
        5.verticalSpace,
        Text(
          "${_currentIndex + 1}/${widget.vocabInfo.length}",
          style: AppTypography.title.copyWith(
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }
}

// ignore: must_be_immutable
class FlashcardComponentItem extends StatefulWidget {
  FlashcardComponentItem({
    Key? key,
    this.front,
    this.back,
    this.angle,
  }) : super(key: key);
  final Widget? front;
  final Widget? back;
  double? angle;
  void Function(Offset)? onSwipeLeft;
  void Function(Offset)? onSwipeRight;
  @override
  State<FlashcardComponentItem> createState() => _FlashcardComponentItemState();
}

class _FlashcardComponentItemState extends State<FlashcardComponentItem> {
  bool isBack = true;

  // void _flip() {
  //   setState(() {
  //     widget.angle = (widget.angle! + pi) % (2 * pi);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TweenAnimationBuilder(
        tween: Tween<double>(begin: 0, end: widget.angle),
        duration: const Duration(milliseconds: 300),
        builder: (BuildContext context, double val, __) {
          //here we will change the isBack val so we can change the content of the card
          if (val >= (pi / 2)) {
            isBack = false;
          } else {
            isBack = true;
          }
          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(val),
            child: _buildInterface(
              child: isBack
                  ? _buildInterface(
                      child: widget.front ?? const Center(child: Text('Front')),
                    )
                  : Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()..rotateY(pi),
                      child: _buildInterface(
                        child: widget.back ?? const Center(child: Text('Back')),
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Container _buildInterface({required Widget child}) {
    return Container(
      height: 400.h,
      width: 300.w,
      decoration: BoxDecoration(
        border: Border.all(color: AppColor.primary, width: 2),
        borderRadius: BorderRadius.circular(30.r),
      ),
      child: child,
    );
  }
}
