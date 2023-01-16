import 'dart:math';
import 'package:bke/bloc/flashcard/flashcard_collection/flashcard_collection_cubit.dart';
import 'package:bke/data/models/vocab/vocab.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:bke/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../routes/route_name.dart';

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
  double angle = 0;
  late List<FlipCard> item;
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    context
        .read<FlashcardCollectionCubit>()
        .getFlashcardCollections(currentCollection: widget.currentCollection);
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
        child: BlocSelector<FlashcardCollectionCubit, FlashcardCollectionState,
            List<LocalVocabInfo>>(
          selector: (state) {
            return state.flashcards!;
          },
          builder: (context, listOfFlashcard) {
            return Column(
              children: [
                _buildAppBar(context),
                listOfFlashcard.isNotEmpty
                    ? _buildFlashcard()
                    : const EmptyScreen(title: "Không có thẻ ghi nhớ nào!"),
              ],
            );
          },
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
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: AppColor.greyBackground,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BlocSelector<FlashcardCollectionCubit, FlashcardCollectionState,
                List<LocalVocabInfo>>(
              selector: (state) {
                return state.flashcards!;
              },
              builder: (context, listOfFlashcard) {
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, RouteName.flashCardInfoScreen,
                      arguments: listOfFlashcard[_currentIndex]),
                  child: Draggable(
                      onDragEnd: (details) {
                        if (details.velocity.pixelsPerSecond.dx < 0) {
                          setState(() {
                            _currentIndex =
                                _currentIndex + 1 < widget.vocabInfo.length
                                    ? _currentIndex + 1
                                    : 0;
                          });
                          print("currentIndex: " + _currentIndex.toString());
                          print("length: " + listOfFlashcard.length.toString());
                        }
                        if (details.velocity.pixelsPerSecond.dx > 0) {
                          setState(() {
                            _currentIndex = _currentIndex > 0
                                ? _currentIndex - 1
                                : widget.vocabInfo.length - 1;
                          });
                          print("currentIndex: " + _currentIndex.toString());
                          print("length: " + listOfFlashcard.length.toString());
                        }
                      },
                      feedback: _buildCard(listOfFlashcard),
                      childWhenDragging: FlipCard(
                        angle: 0,
                        front: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        back: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                      ),
                      child: _buildCard(listOfFlashcard)),
                );
              },
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

  Widget _buildCard(List<LocalVocabInfo> listOfFlashcard) {
    return FlipCard(
      angle: angle,
      front: _buildFront(listOfFlashcard),
      back: _buildBack(listOfFlashcard),
    );
  }

  String concatMeaning(List<TranslateInfo> list) {
    String temp = '';
    for (var trans in list) {
      temp += " ${trans.vi.toCapitalize()}; ";
    }
    return temp;
  }

  Widget _buildBack(List<LocalVocabInfo> listOfFlashcard) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: () {
              context
                  .read<FlashcardCollectionCubit>()
                  .deleteFlashcard(widget.currentCollection, _currentIndex);
              setState(() {
                if (_currentIndex > 0) {
                  _currentIndex = _currentIndex - 1;
                }
              });
            },
            icon: Icon(
              Icons.close,
              color: AppColor.primary,
              size: 25.r,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              concatMeaning(listOfFlashcard[_currentIndex].translate),
              textAlign: TextAlign.center,
              style: AppTypography.subHeadline
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFront(List<LocalVocabInfo> listOfFlashcard) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: () {
              context
                  .read<FlashcardCollectionCubit>()
                  .deleteFlashcard(widget.currentCollection, _currentIndex);
              setState(() {
                if (_currentIndex > 0) {
                  _currentIndex = _currentIndex - 1;
                }
              });
            },
            icon: Icon(
              Icons.close,
              color: AppColor.primary,
              size: 25.r,
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  listOfFlashcard[_currentIndex].vocab.toCapitalize(),
                  style: AppTypography.subHeadline
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  '(${listOfFlashcard[_currentIndex].vocabType.toCapitalize()})',
                  style: AppTypography.title.copyWith(
                      fontWeight: FontWeight.bold, color: AppColor.primary),
                ),
                5.verticalSpace,
                Text.rich(
                  TextSpan(
                      text: "UK: ",
                      style:
                          AppTypography.title.copyWith(color: AppColor.primary),
                      children: [
                        TextSpan(
                          text: listOfFlashcard[_currentIndex].pronounce.uk,
                          style: AppTypography.title,
                        )
                      ]),
                ),
                5.verticalSpace,
                Text.rich(
                  TextSpan(
                    text: "US: ",
                    style:
                        AppTypography.title.copyWith(color: AppColor.primary),
                    children: [
                      TextSpan(
                        text: widget.vocabInfo[_currentIndex].pronounce.us,
                        style: AppTypography.title,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
