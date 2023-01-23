import 'package:bke/data/models/flashcard/flashcard_collection_model.dart';
import 'package:bke/presentation/pages/flashcard/components/flashcard_collection_component.dart';
import 'package:bke/presentation/pages/flashcard/flashcard_page.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../bloc/flashcard/flashcard_collection/flashcard_collection_cubit.dart';
import '../../routes/route_name.dart';
import '../../widgets/widgets.dart';

class FlashcardCollectionScreen extends StatefulWidget {
  const FlashcardCollectionScreen({super.key});

  @override
  State<FlashcardCollectionScreen> createState() =>
      _FlashcardCollectionScreenState();
}

class _FlashcardCollectionScreenState extends State<FlashcardCollectionScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FlashcardCollectionCubit>().getFlashcardCollections();
  }

  @override
  void dispose() {
    _editTitle.dispose();
    _addFlashcardCollection.dispose();

    super.dispose();
  }

  final _editTitle = TextEditingController();
  final _addFlashcardCollection = TextEditingController();
  Offset _position = Offset.zero;
  void _getTapPosition(TapDownDetails tapPosition) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    setState(() {
      _position = renderBox.globalToLocal(tapPosition.globalPosition);
    });
  }

  void _showContextMenu(BuildContext context, int index) async {
    final RenderObject? overlay =
        Overlay.of(context)?.context.findRenderObject();
    final result = await showMenu(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0.r))),
      context: context,
      position: RelativeRect.fromRect(
        Rect.fromLTWH(_position.dx, _position.dy, 100.r, 100.r),
        Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
            overlay.paintBounds.size.height),
      ),
      items: [
        PopupMenuItem(
          value: "delete",
          child: Text(
            "Xoá bộ sưu tập",
            style: AppTypography.title,
          ),
        ),
        PopupMenuItem(
          value: "changetitle",
          child: Text(
            "Thay đổi tiêu đề",
            style: AppTypography.title,
          ),
        ),
        PopupMenuItem(
          value: "changepicture",
          child: Text(
            "Thay đổi hình ảnh",
            style: AppTypography.title,
          ),
        ),
      ],
    );

    switch (result) {
      case "delete":
        _deleteCollection(context, index);
        break;
      case "changetitle":
        _changeTitle(context, index);
        break;
      case "changepicture":
        _changePicture(context, index);
        break;
    }
  }

  void _deleteCollection(BuildContext context, int current) {
    context.read<FlashcardCollectionCubit>().deleteFlashCardCollection(current);
  }

  void _changePicture(BuildContext context, int current) {
    final cubit = context.read<FlashcardCollectionCubit>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Thay đổi hình ảnh",
            style: AppTypography.title.copyWith(fontWeight: FontWeight.w700),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              20.r,
            ),
          ),
          content: SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: MediaQuery.of(context).size.height * 0.2,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    cubit.updateImg(cubit.pictures[index], current);
                    Navigator.pop(context);
                  },
                  child: Image(image: AssetImage(cubit.pictures[index])),
                );
              },
              itemCount: cubit.pictures.length,
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r)),
              ),
              onPressed: () => Navigator.pop(context),
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

  void _changeTitle(BuildContext context, int current) {
    final cubit = context.read<FlashcardCollectionCubit>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Thay đổi tiêu đề",
            style: AppTypography.title.copyWith(fontWeight: FontWeight.w700),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              20.r,
            ),
          ),
          content: CustomTextField(
            controller: _editTitle,
            borderRadius: 30.r,
          ),
          actions: [
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: _editTitle,
              builder: (context, value, child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r)),
                  ),
                  onPressed: value.text.isEmpty
                      ? null
                      : () {
                          cubit.updateTitle(_editTitle.text, current);
                          _editTitle.clear();
                          Navigator.pop(context);
                        },
                  child: Text(
                    "Thay đổi",
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
                _editTitle.clear();
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

  void _addCollection(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            BkEAppBar(
              label: "Bộ sưu tập Flashcard",
              onBackButtonPress: () => Navigator.pop(context),
              trailing: IconButton(
                  onPressed: () async {
                    final flashcardCollections = context
                        .read<FlashcardCollectionCubit>()
                        .state
                        .listOfFlashcardColection!
                        .map((e) => e.toJson())
                        .toList();
                    await context
                        .read<FlashcardCollectionCubit>()
                        .updateToServer(flashcardCollections);
                  },
                  icon: Icon(
                    Icons.sync,
                    color: Colors.white,
                    size: 25.r,
                  )),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: AppColor.greyBackground,
                  borderRadius:
                      BorderRadius.only(topLeft: Radius.circular(30.r)),
                ),
                child: _buildCollection(context),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addCollection(context),
        backgroundColor: AppColor.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
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
              onLongPress: () {
                _showContextMenu(context, index);
              },
              onTapDown: (details) {
                _getTapPosition(details);
              },
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(
                  context,
                  RouteName.flashCardScreen,
                  arguments: FlashcardPageModel(
                    collectionTitle:
                        state.listOfFlashcardColection![index].title,
                    currentCollection: index,
                  ),
                ),
                child: FlashcardComponent(
                  imgUrl: state.listOfFlashcardColection![index].imgUrl,
                  title: state.listOfFlashcardColection![index].title,
                ),
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
