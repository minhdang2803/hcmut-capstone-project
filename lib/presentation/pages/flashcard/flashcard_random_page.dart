import 'dart:math';

import 'package:bke/bloc/flashcard/flashcard_collection_random/flashcard_collection_random_cubit.dart';
import 'package:bke/presentation/routes/route_name.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/vocab/vocab.dart';
import '../../theme/app_color.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/empty_screen_component.dart';
import '../../widgets/flipped_card.dart';

class FlashcardRandomScreen extends StatefulWidget {
  const FlashcardRandomScreen({
    super.key,
    required this.currentCollection,
    required this.collectionTitle,
  });

  final String collectionTitle;
  final int currentCollection;
  @override
  State<FlashcardRandomScreen> createState() => _FlashcardRandomScreenState();
}

class _FlashcardRandomScreenState extends State<FlashcardRandomScreen>
    with SingleTickerProviderStateMixin {
  double angle = 0;

  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    context
        .read<FlashcardRandomCubit>()
        .getRandomFlashcards(widget.collectionTitle);
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
      backgroundColor: AppColor.appBackground,
      body: SafeArea(
        bottom: false,
        child: BlocSelector<FlashcardRandomCubit, FlashcardRandomState, bool>(
          selector: ((state) {
            return state.status! == FlashcardRandomStatus.loading;
          }),
          builder: (context, isLoading) {
            return Column(
              children: [
                _buildAppBar(context),
                isLoading
                    ? const EmptyScreen(
                        title: "Không có thẻ ghi nhớ nào!",
                        isLoading: true,
                      )
                    : _buildFlashcard(),
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
      onBackButtonPress: () {
        context.read<FlashcardRandomCubit>().exit();
        Navigator.pop(context);
      },
    );
  }

  Widget _buildFlashcard() {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Container(
        width: size.width,
        decoration: BoxDecoration(
          color: AppColor.primary,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30.r)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            BlocBuilder<FlashcardRandomCubit, FlashcardRandomState>(
              builder: (context, state) {
                return GestureDetector(
                  onTap: () => Navigator.pushNamed(
                      context, RouteName.flashCardInfoScreen,
                      arguments: state.flashcards![state.index!]),
                  child: Draggable(
                      onDragEnd: (details) {
                        if (details.velocity.pixelsPerSecond.dx < 0) {
                          context.read<FlashcardRandomCubit>().increaseIndex();
                        }
                        if (details.velocity.pixelsPerSecond.dx > 0) {
                          context.read<FlashcardRandomCubit>().decreaseIndex();
                        }
                      },
                      feedback: _buildCard(state.index!, state.flashcards!),
                      childWhenDragging: FlipCard(
                        angle: 0,
                        front: Container(
                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                        back: Container(
                          decoration: BoxDecoration(
                            color: AppColor.primary,
                            borderRadius: BorderRadius.circular(30.r),
                          ),
                        ),
                      ),
                      child: _buildCard(state.index!, state.flashcards!)),
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
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: BlocBuilder<FlashcardRandomCubit, FlashcardRandomState>(
              builder: (context, state) {
                return Text(
                  concatMeaning(state.flashcards![state.index!].translate),
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
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: BlocBuilder<FlashcardRandomCubit, FlashcardRandomState>(
              builder: (context, state) {
                if (state.status == FlashcardRandomStatus.success) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.flashcards![state.index!].vocab.toCapitalize(),
                        style: AppTypography.subHeadline
                            .copyWith(fontWeight: FontWeight.bold, color: AppColor.textPrimary),
                      ),
                      Text(
                        '(${state.flashcards![state.index!].vocabType.toCapitalize()})',
                        style: AppTypography.title.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColor.textPrimary),
                      ),
                      5.verticalSpace,
                      Text.rich(
                        TextSpan(
                            text: "UK: ",
                            style: AppTypography.title
                                .copyWith(color: AppColor.textPrimary),
                            children: [
                              TextSpan(
                                text: state
                                    .flashcards![state.index!].pronounce.uk,
                                style: AppTypography.title
                                .copyWith(color: AppColor.textPrimary),
                              )
                            ]),
                      ),
                      5.verticalSpace,
                      Text.rich(
                        TextSpan(
                          text: "US: ",
                          style: AppTypography.title
                              .copyWith(color: AppColor.textPrimary),
                          children: [
                            TextSpan(
                              text:
                                  state.flashcards![state.index!].pronounce.us,
                              style: AppTypography.title
                              .copyWith(color: AppColor.textPrimary),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRoundedLinearProcessIndicator() {
    return BlocBuilder<FlashcardRandomCubit, FlashcardRandomState>(
      builder: (context, state) {
        if (state.status == FlashcardRandomStatus.success) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 300.w,
                height: 15.h,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30.r),
                  child: LinearProgressIndicator(
                    color: AppColor.secondary,
                    backgroundColor: AppColor.secondary.withOpacity(0.5),
                    value: (state.index! + 1) / state.flashcards!.length,
                  ),
                ),
              ),
              5.verticalSpace,
              Text(
                "${state.index! + 1}/${state.flashcards!.length}",
                style: AppTypography.title.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              )
            ],
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
