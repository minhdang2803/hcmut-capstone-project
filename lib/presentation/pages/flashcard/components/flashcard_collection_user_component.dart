import 'package:bke/bloc/flashcard/flashcard_collection/flashcard_collection_cubit.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import '../flashcard_page.dart';
import 'flashcard_collection_component.dart';

class UserComponent extends StatefulWidget {
  const UserComponent({
    super.key,
    required this.getTapPosition,
    required this.showContextMenu,
  });
  final void Function(TapDownDetails) getTapPosition;
  final void Function(BuildContext, int) showContextMenu;
  @override
  State<UserComponent> createState() => _UserComponentState();
}

class _UserComponentState extends State<UserComponent> {
  @override
  void initState() {
    super.initState();
    context.read<FlashcardCollectionCubit>().getFlashcardCollections();
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
    return BlocSelector<FlashcardCollectionCubit, FlashcardCollectionState,
        bool>(
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
    return BlocBuilder<FlashcardCollectionCubit, FlashcardCollectionState>(
      builder: (context, state) {
        if (state.status == FlashcardCollectionStatus.loading) {
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
              onLongPress: () {
                // _showContextMenu(context, index);
                widget.showContextMenu(context, index);
              },
              onTapDown: (details) {
                // _getTapPosition(details);
                widget.getTapPosition(details);
              },
              onTap: () => Navigator.pushNamed(
                context,
                RouteName.flashCardScreen,
                arguments: FlashcardPageModel(
                  collectionTitle: state.listOfFlashcardColection![index].title,
                  currentCollection: index,
                ),
              ),
              child: FlashcardComponent(
                imgUrl: state.listOfFlashcardColection![index].imgUrl,
                title: state.listOfFlashcardColection![index].title,
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        150.verticalSpace,
        Image(
          image: const AssetImage("assets/images/no.png"),
          height: 200.r,
          width: 200.r,
        ),
        SizedBox(
          width: 200.w,
          child: Text(
            "Bộ sưu tập flashcard trống!",
            style:
                AppTypography.subHeadline.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
