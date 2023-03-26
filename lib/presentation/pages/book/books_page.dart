// ignore_for_file: prefer_const_constructors

import 'package:bke/data/models/search/search_model.dart';
import 'package:bke/presentation/pages/book/widgets/books_section.dart';
import 'package:bke/presentation/pages/book/widgets/books_section_shorten.dart';
import 'package:bke/presentation/pages/book/widgets/menu_sheet.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/book/book_bloc.dart';
import '../../../bloc/book/book_state.dart';
import '../../../bloc/book/book_event.dart';

import '../../widgets/holder_widget.dart';
import '../main/components/monastery_search_delegate.dart';

class BookPage extends StatelessWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => BookListBloc()..add(LoadAllEvent()),
        child: Scaffold(
          backgroundColor: AppColor.appBackground,
          body: SafeArea(
            top: true,
            bottom: false,
            child: Column(
              children: [
                BkEAppBar(
                  label: 'Thư viện',
                  onBackButtonPress: () => Navigator.pop(context),
                  onSearchButtonPress: () {
                    showSearch(
                        context: context,
                        delegate: MonasterySearchDelegate(
                            searchType: SearchType.books,
                            buildContext: context));
                  },
                ),
                // _buildOptionBar(context),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 50, left: 10, right: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColor.primary,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        // topRight: Radius.circular(40),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: _contentSection(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  // Widget _buildOptionBar(BuildContext context) {
  //   return Padding(
  //     padding: EdgeInsets.all(10.r),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         BlocBuilder<BookListBloc, BookListState>(
  //           builder: (context, state) {
  //             return IconButton(
  //               icon: Icon(
  //                 Icons.menu,
  //                 color: AppColor.textPrimary,
  //                 size: 35.r,
  //               ),
  //               onPressed: () => showModalBottomSheet(
  //                 isScrollControlled: true,
  //                 context: context,
  //                 builder: (_) => BlocProvider.value(
  //                   value: BlocProvider.of<BookListBloc>(context),
  //                   child: const MenuSheet(),
  //                 ),
  //               ),
  //             );
  //           },
  //         ),
  //         IconButton(
  //           icon: Icon(
  //             Icons.search,
  //             color: Colors.white,
  //             size: 35.r,
  //           ),
  //           onPressed: () {
  //             showSearch(
  //                 context: context,
  //                 delegate: MonasterySearchDelegate(
  //                     searchType: SearchType.books, buildContext: context));
  //           },
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _contentSection(BuildContext context) {
    late String heading;
    return BlocBuilder<BookListBloc, BookListState>(builder: (context, state) {
      if (state is BookListLoadingState) {
        return Center(
            child: CircularProgressIndicator(color: AppColor.accentBlue));
      }

      if (state is BookListLoadedState) {
        heading = state.category;
        // print(heading);
        List<dynamic> bookList = state.books;

        if (heading == 'Home') {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BookSection(
                  heading: bookList[0].category, bookList: bookList[0].list),
              BookSection(
                  heading: bookList[1].category, bookList: bookList[1].list),
              BookSection(
                  heading: bookList[2].category, bookList: bookList[2].list),
              BookSection(
                  heading: bookList[3].category, bookList: bookList[3].list),
              BookSection(
                  heading: bookList[4].category, bookList: bookList[4].list)
            ],
          ); //Continue reading
        } else {
          return BookSectionDisplayAll(heading: heading, bookList: bookList);
        }
      }

      if (state is BookErrorState) {
        return HolderWidget(
          asset: 'assets/images/error.png',
          onRetry: () => {
            heading != 'Home'
                ? context
                    .read<BookListBloc>()
                    .add(LoadByCategoryEvent(category: heading))
                : context.read<BookListBloc>().add(LoadAllEvent())
          },
        );
      }
      return Container();
    });
  }
}
