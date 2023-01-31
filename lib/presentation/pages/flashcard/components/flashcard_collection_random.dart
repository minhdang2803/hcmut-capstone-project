import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/flashcard/flashcard_collection_random/flashcard_collection_random_cubit.dart';
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
    context.read<FlashcardCollectionRandomCubit>().getFlashcardCollections();
  }

  @override
  Widget build(BuildContext context) {
    return _buildUserColleciton();
  }

  Widget _buildUserColleciton() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.greyBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30.r),
          topRight: Radius.circular(30.r),
        ),
      ),
      child: _buildCollection(context),
    );
  }

  Widget _buildCollection(BuildContext context) {
    return BlocSelector<FlashcardCollectionRandomCubit,
        FlashcardCollectionRandomState, bool>(
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
    return BlocBuilder<FlashcardCollectionRandomCubit,
        FlashcardCollectionRandomState>(
      builder: (context, state) {
        if (state.status == FlashcardCollectionRandomStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.primary),
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
              onTap: () => Navigator.pushNamed(
                context,
                RouteName.flashCardScreen,
                arguments: FlashcardPageModel(
                  collectionTitle:
                      state.listOfFlashcardColection![index].category,
                  currentCollection: index,
                ),
              ),
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
      child: CircularProgressIndicator(color: AppColor.primary),
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
