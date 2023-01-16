import 'package:bke/bloc/flashcard/flashcard_card/flashcard_cubit.dart';
import 'package:bke/data/models/flashcard/flashcard_collection_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:like_button/like_button.dart';

import '../../../../bloc/flashcard/flashcard_collection/flashcard_collection_cubit.dart';
import '../../../../bloc/vocab/vocab_cubit.dart';
import '../../../../data/models/vocab/vocab.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import '../../../widgets/text_field_custom.dart';

class VocabularyTab extends StatefulWidget {
  const VocabularyTab({super.key, required this.vocabInfo});

  final VocabInfo vocabInfo;

  @override
  State<VocabularyTab> createState() => _VocabularyTabState();
}

class _VocabularyTabState extends State<VocabularyTab> {
  bool isLiked = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.r),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: 3.r, color: AppColor.primary),
              borderRadius: BorderRadius.circular(16.h),
            ),
            child: Padding(
              padding: EdgeInsets.all(8.r),
              child: _buildTranslateTab(widget.vocabInfo),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: Row(
              children: [
                _buildLikeButton(widget.vocabInfo),
                _buildAddToFlashcard(widget.vocabInfo),
              ],
            ),
          ),
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
    setState(() {
      isLiked = vocabIdList.contains(vocabInfo.id);
    });
    return LikeButton(
      padding: EdgeInsets.all(5.r),
      likeBuilder: (isLiked) {
        return Icon(
          Icons.favorite,
          size: 25.r,
          color: isLiked ? Colors.red : Colors.black38,
        );
      },
      likeCountPadding: EdgeInsets.zero,
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      isLiked: isLiked,
      onTap: (liked) async {
        if (liked == true) {
          context.read<VocabCubit>().deleteFromMyDictionary(vocabInfo.id);
          return false;
        } else {
          context.read<VocabCubit>().saveToMyDictionary(
                LocalVocabInfo(
                  vocab: vocabInfo.vocab,
                  vocabType: vocabInfo.vocabType,
                  id: vocabInfo.id,
                  pronounce: vocabInfo.pronounce,
                  translate: vocabInfo.translate,
                ),
              );
          return true;
        }
      },
    );
  }

  Widget _buildAddToFlashcard(VocabInfo vocabInfo) {
    return IconButton(
      onPressed: () => showFlashcardCollectionList(vocabInfo),
      icon: Icon(
        Icons.queue,
        size: 25.r,
        color: Colors.black38,
      ),
    );
  }

  void showFlashcardCollectionList(VocabInfo vocabInfo) {
    final flashcardCubit = context.read<FlashcardCollectionCubit>();
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child: Text(
                "Thêm vào bộ sưu tập Flashcard",
                textAlign: TextAlign.center,
                style:
                    AppTypography.title.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                20.r,
              ),
            ),
            content: GestureDetector(
              onTap: () => flashcardCubit.getFlashcardCollections(),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.height * 0.1,
                child: BlocSelector<FlashcardCollectionCubit,
                    FlashcardCollectionState, List<FlashcardCollectionModel>?>(
                  selector: (state) {
                    return state.listOfFlashcardColection;
                  },
                  builder: (context, list) {
                    return ListView.builder(
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Padding(
                            padding: EdgeInsets.zero,
                            child: Text(
                              list[index].title,
                              style: AppTypography.body,
                            ),
                          ),
                          trailing: IconButton(
                            splashColor: AppColor.secondary,
                            splashRadius: 20.r,
                            padding: EdgeInsets.zero,
                            onPressed: () =>
                                context.read<FlashcardCubit>().addFlashcard(
                                      LocalVocabInfo(
                                        vocab: vocabInfo.vocab,
                                        vocabType: vocabInfo.vocabType,
                                        id: vocabInfo.id,
                                        pronounce: vocabInfo.pronounce,
                                        translate: vocabInfo.translate,
                                      ),
                                      index,
                                    ),
                            icon: Icon(
                              Icons.add,
                              color: Colors.black38,
                              size: 16.r,
                            ),
                          ),
                        );
                      },
                      itemCount: list!.length,
                    );
                  },
                ),
              ),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r)),
                ),
                onPressed: () => _addCollection(context),
                child: Text(
                  "Bộ sưu tập mới",
                  style: AppTypography.body.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.r)),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  "Huỷ",
                  style: AppTypography.body.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _addCollection(BuildContext context) {
    final TextEditingController _addFlashcardCollection =
        TextEditingController();
    ValueNotifier<int> selected = ValueNotifier<int>(-1);
    String name = "";
    String imgUrl = "";
    final cubit = context.read<FlashcardCollectionCubit>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Thêm mới bộ sưu tập",
            style: AppTypography.title.copyWith(fontWeight: FontWeight.w700),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              20.r,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Tên bộ sưu tập: ", style: AppTypography.title),
                5.verticalSpace,
                CustomTextField(
                  controller: _addFlashcardCollection,
                  borderRadius: 30.r,
                  onChanged: (value) => name = value,
                ),
                10.verticalSpace,
                Text("Chọn ảnh bìa", style: AppTypography.title),
                5.verticalSpace,
                Expanded(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          selected.value = index;
                          imgUrl = cubit.pictures[index];
                        },
                        child: ValueListenableBuilder(
                          valueListenable: selected,
                          builder: (context, value, child) {
                            return _buildHoverIcon(value, index, cubit);
                          },
                        ),
                      );
                    },
                    itemCount: cubit.pictures.length,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _addFlashcardCollection,
              builder: (context, value, child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r)),
                  ),
                  onPressed: value.text.isEmpty
                      ? null
                      : () {
                          context
                              .read<FlashcardCollectionCubit>()
                              .addFlashcardCollection(
                                FlashcardCollectionModel(
                                  imgUrl: imgUrl,
                                  title: name,
                                  flashcards: [],
                                ),
                              );

                          _addFlashcardCollection.clear();
                          Navigator.pop(context);
                        },
                  child: Text(
                    "Thêm",
                    style: AppTypography.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r)),
              ),
              onPressed: () {
                _addFlashcardCollection.clear();
                Navigator.pop(context);
              },
              child: Text(
                "Huỷ",
                style: AppTypography.body.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHoverIcon(int value, int index, FlashcardCollectionCubit cubit) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
            color: value == index ? AppColor.primary : Colors.transparent,
            width: 2.0),
      ),
      child: Image(
        image: AssetImage(cubit.pictures[index]),
      ),
    );
  }
}
