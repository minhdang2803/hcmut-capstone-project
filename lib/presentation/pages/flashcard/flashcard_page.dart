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
import '../../../bloc/flashcard/flashcard_card/flashcard_cubit.dart';
import '../../routes/route_name.dart';

class FlashcardPageModel {
  final String collectionTitle;
  final int currentCollection;

  FlashcardPageModel({
    required this.collectionTitle,
    required this.currentCollection,
  });
}

class FlashCardScreen extends StatefulWidget {
  const FlashCardScreen({
    super.key,
    required this.currentCollection,
    required this.collectionTitle,
  });

  final String collectionTitle;
  final int currentCollection;
  @override
  State<FlashCardScreen> createState() => _FlashCardScreenState();
}

class _FlashCardScreenState extends State<FlashCardScreen>
    with SingleTickerProviderStateMixin {
  double angle = 0;

  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    context.read<FlashcardCubit>().getFlashcard(widget.currentCollection);
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
        child: BlocSelector<FlashcardCubit, FlashcardState, bool>(
          selector: (state) {
            return state.flashcards.isEmpty;
          },
          builder: (context, isEmpty) {
            return Column(
              children: [
                _buildAppBar(context),
                !isEmpty
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
            BlocBuilder<FlashcardCubit, FlashcardState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, RouteName.flashCardInfoScreen,
                      arguments: state.flashcards[state.index]),
                  child: Draggable(
                      onDragEnd: (details) {
                        if (details.velocity.pixelsPerSecond.dx < 0) {
                          context.read<FlashcardCubit>().increaseIndex();
                        }
                        if (details.velocity.pixelsPerSecond.dx > 0) {
                          context.read<FlashcardCubit>().decreaseIndex();
                        }
                      },
                      feedback: _buildCard(state.index, state.flashcards),
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
                      child: _buildCard(state.index, state.flashcards)),
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

  Widget _buildCard(int index, List<LocalVocabInfo> listOfFlashcard) {
    return FlipCard(
      angle: angle,
      front: _buildFront(index, listOfFlashcard),
      back: _buildBack(index, listOfFlashcard),
    );
  }

  String concatMeaning(List<TranslateInfo> list) {
    String temp = '';
    for (var trans in list) {
      temp += " ${trans.vi.toCapitalize()}, ";
    }
    return temp;
  }

  Widget _buildBack(int index, List<LocalVocabInfo> listOfFlashcard) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: () {
              context
                  .read<FlashcardCubit>()
                  .deleteFlashcard(widget.currentCollection, index);
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
            child: BlocBuilder<FlashcardCubit, FlashcardState>(
              builder: (context, state) {
                return Text(
                  concatMeaning(state.flashcards[state.index].translate),
                  textAlign: TextAlign.center,
                  style: AppTypography.subHeadline
                      .copyWith(fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFront(int index, List<LocalVocabInfo> listOfFlashcard) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
            onPressed: () => context
                .read<FlashcardCubit>()
                .deleteFlashcard(widget.currentCollection, index),
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
            child: BlocBuilder<FlashcardCubit, FlashcardState>(
              builder: (context, state) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.flashcards[state.index].vocab.toCapitalize(),
                      style: AppTypography.subHeadline
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '(${state.flashcards[state.index].vocabType.toCapitalize()})',
                      style: AppTypography.title.copyWith(
                          fontWeight: FontWeight.bold, color: AppColor.primary),
                    ),
                    5.verticalSpace,
                    Text.rich(
                      TextSpan(
                          text: "UK: ",
                          style: AppTypography.title
                              .copyWith(color: AppColor.primary),
                          children: [
                            TextSpan(
                              text: state.flashcards[state.index].pronounce.uk,
                              style: AppTypography.title,
                            )
                          ]),
                    ),
                    5.verticalSpace,
                    Text.rich(
                      TextSpan(
                        text: "US: ",
                        style: AppTypography.title
                            .copyWith(color: AppColor.primary),
                        children: [
                          TextSpan(
                            text: state.flashcards[state.index].pronounce.us,
                            style: AppTypography.title,
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoundedLinearProcessIndicator() {
    return BlocBuilder<FlashcardCubit, FlashcardState>(
      builder: (context, state) {
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
                  value: (state.index + 1) / state.flashcards.length,
                ),
              ),
            ),
            5.verticalSpace,
            Text(
              "${state.index + 1}/${state.flashcards.length}",
              style: AppTypography.title.copyWith(
                fontWeight: FontWeight.w700,
              ),
            )
          ],
        );
      },
    );
  }
}
