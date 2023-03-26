import 'package:bke/bloc/flashcard/flashcard_collection_thumb/flashcard_collection_thumb_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';
import '../flashcard_page.dart';
import 'flashcard_collection_component.dart';

class RandomComponent extends StatefulWidget {
  const RandomComponent({super.key});
  @override
  State<RandomComponent> createState() => _RandomComponentState();
}

class _RandomComponentState extends State<RandomComponent> {
  @override
  void initState() {
    super.initState();
    context.read<FlashcardCollectionThumbCubit>().getFlashcardCollections();
  }

  @override
  Widget build(BuildContext context) {
    return _buildUserColleciton();
  }

  Widget _buildUserColleciton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: _buildCollection(context),
    );
  }

  Widget _buildCollection(BuildContext context) {
    return BlocSelector<FlashcardCollectionThumbCubit,
        FlashcardCollectionThumbState, bool>(
      selector: (state) {
        return state.listOfFlashcardColection!.isEmpty;
      },
      builder: (context, isEmpty) {
        return Padding(
          padding: EdgeInsets.all(20.r),
          child: isEmpty ? _buildEmptyScreen() : _buildFlashcardScreen(),
        );
      },
    );
  }

  Widget _buildFlashcardScreen() {
    return BlocBuilder<FlashcardCollectionThumbCubit,
        FlashcardCollectionThumbState>(
      builder: (context, state) {
        if (state.status == FlashcardCollectionThumbStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.accentBlue),
          );
        }
        return GridView.builder(
          itemCount: state.listOfFlashcardColection!.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 10.r,
            crossAxisSpacing: 10.r,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  RouteName.flashCardRandomScreen,
                  arguments: FlashcardPageModel(
                    collectionTitle:
                        state.listOfFlashcardColection![index].category,
                    currentCollection: index,
                  ),
                );
              },
              child: FlashcardRandomComponent(
                imgUrl: state.listOfFlashcardColection![index].imgUrl,
                title: state.listOfFlashcardColection![index].category,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyScreen() {
    return const Center(
      child: CircularProgressIndicator(color: AppColor.accentBlue),
    );
    // return Column(
    //   mainAxisAlignment: MainAxisAlignment.start,
    //   children: [
    //     150.verticalSpace,
    //     Image(
    //       image: const AssetImage("assets/images/no.png"),
    //       height: 200.r,
    //       width: 200.r,
    //     ),
    //     SizedBox(
    //       width: 200.w,
    //       child: Text(
    //         "Bộ sưu tập flashcard trống!",
    //         style:
    //             AppTypography.subHeadline.copyWith(fontWeight: FontWeight.w700),
    //         textAlign: TextAlign.center,
    //       ),
    //     )
    //   ],
    // );
  }
}
