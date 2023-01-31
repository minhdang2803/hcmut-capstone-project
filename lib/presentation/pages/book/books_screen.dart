// ignore_for_file: prefer_const_constructors

import 'package:bke/data/models/book/book_listener.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../data/models/book/book_info.dart';
import '../../../bloc/book/book_bloc.dart';
import '../../../bloc/book/book_state.dart';
import '../../../bloc/book/book_event.dart';
import '../../routes/route_name.dart';
import '../../widgets/holder_widget.dart';

class BookPage extends StatelessWidget {
  const BookPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => BookListBloc()..add(LoadAllEvent()),
        child: Scaffold(
          backgroundColor: AppColor.primary,
          body: SafeArea(
            top: true,
            bottom: false,
            child: Column(
              children: [
                BkEAppBar(
                  label: 'Thư viện',
                  onBackButtonPress: () => Navigator.pop(context),
                ),
                _buildOptionBar(),
                Expanded(
                  child: Container(
                    padding:
                        const EdgeInsets.only(top: 50, left: 10, right: 10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(40),
                        // topRight: Radius.circular(40),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: contentSection(context),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildOptionBar() {
    return Padding(
      padding: EdgeInsets.all(10.r),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BlocBuilder<BookListBloc, BookListState>(
            builder: (context, state) {
              return IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                  size: 35.r,
                ),
                onPressed: () => showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (_) => BlocProvider.value(
                    value: BlocProvider.of<BookListBloc>(context),
                    child: const MenuSheet(),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
              size: 35.r,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget contentSection(BuildContext context) {
    late String heading;
    return BlocBuilder<BookListBloc, BookListState>(builder: (context, state) {
      if (state is BookListLoadingState) {
        return Center(
            child: CircularProgressIndicator(color: AppColor.primary));
      }

      if (state is BookListLoadedState) {
        heading = state.category;
        // print(heading);
        List<BookInfo> bookList = state.books;

        if (heading == 'Home') {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BookSection(heading: 'Tiếp tục xem', bookList: bookList),
              BookSection(heading: 'Danh sách của tôi', bookList: bookList),
              //BookSection(); //Discover more
              //BookSection(); //Adventures
              //BookSection(); //Romance
              //.etc
            ],
          ); //Continue reading
        } else if (heading == 'Continue Reading') {
        } else if (heading == 'My List') {
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

class MenuSheet extends StatefulWidget {
  const MenuSheet({Key? key}) : super(key: key);

  @override
  State<MenuSheet> createState() => _MenuSheetState();
}

class _MenuSheetState extends State<MenuSheet> {
  bool picked = false;
  int at = 0;
  final String category = 'Home';
  final List<String> menuList = <String>['adventure', 'detective', 'non-fiction', 'short-story', 'biography', 'fantasy', 'Classics', 'thriller', 'fairytale', 'fiction', 'Technology & Science', 'human interest', 'documentary', 'science', 'Biography', 'crime', 'science fiction', 'mystery', 'Human interest', 'classics', 'horror', 'novella', 'business', 'novel', 'love story', 'Romance', 'drama', 'gothic horror', 'Horror', 'satire', 'romance', 'historical', 'Historical', 'Culture', 'Historical fiction', 'folk tale', 'Young life/adventure', 'Movies', 'Thriller', 'comedy', 'Adventure', 'movies', 'tale', 'Short stories', 'Science fiction'];
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      color: AppColor.appBackground,
      padding: EdgeInsets.only(top: size.height * 0.1),
      child: ListView.builder(
        itemBuilder: (ctx, i) => GestureDetector(
            onTap: () {
              setState(() {
                picked = true;
                at = i;
              });
              var category = menuList[i];
              context
                  .read<BookListBloc>()
                  .add(LoadByCategoryEvent(category: category));
              Navigator.of(context).pop();
            },
            child: SizedBox(
              height: size.height * 0.1,
              child: Text(
                menuList[i],
                style: picked && i == at
                    ? Theme.of(context).textTheme.headline4!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColor.primary,
                        )
                    : Theme.of(context).textTheme.headline5!.copyWith(
                          fontWeight: FontWeight.w200,
                          color: Theme.of(context).hintColor,
                        ),
                textAlign: TextAlign.center,
              ),
            )),
        itemCount: menuList.length,
      ),
    );
  }
}

class BookSection extends StatelessWidget {
  final String heading;
  final List bookList;
  const BookSection({Key? key, required this.heading, required this.bookList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: Theme.of(context).textTheme.headline5,
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            vertical: 5,
          ),
          height: size.height * 0.3,
          child: ListView.builder(
            itemBuilder: (ctx, i) => GestureDetector(
              onTap: () {
                final book = bookList.elementAt(i);
                // assert(book.mode==2);
                if (book.mode == Mode.start.index) {
                  Navigator.of(context)
                      .pushNamed(RouteName.bookDetails, arguments: book.bookId);
                } else if (book.mode == Mode.reading.index) {
                  Navigator.of(context)
                      .pushNamed(RouteName.bookRead, arguments: book.bookId);
                } else {
                  var argument = BookListenArguments(
                      book.bookId, book.title, book.coverUrl, book.mp3Url);
                  Navigator.of(context)
                      .pushNamed(RouteName.bookListen, arguments: argument);
                }
              },
              child: Row(
                children: [
                  Container(
                      margin: const EdgeInsets.only(
                        left: 10,
                      ),
                      width: size.width * 0.3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          height: size.height * 0.25,
                          color: AppColor.lightGray,
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/default_logo.png',
                            image: bookList[i].coverUrl,
                            fadeInDuration: const Duration(milliseconds: 350),
                            fit: BoxFit.fill,
                            // placeholderFit: BoxFit.fill,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/images/default_logo.png',
                            ),
                          ),
                        ),
                      )),
                ],
              ),
            ),
            itemCount: bookList.length,
            scrollDirection: Axis.horizontal,
          ),
        )
      ],
    );
  }
}

class BookSectionDisplayAll extends StatelessWidget {
  final String heading;
  final List bookList;
  const BookSectionDisplayAll(
      {Key? key, required this.heading, required this.bookList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: Theme.of(context).textTheme.headline5,
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
          height: size.height,
          child: GridView.builder(
            itemBuilder: (ctx, i) => GestureDetector(
              onTap: () {
                final argument = bookList.elementAt(i).bookId;
                Navigator.of(context)
                    .pushNamed(RouteName.bookDetails, arguments: argument);
              },
              child: Row(
                children: [
                  SizedBox(
                    height: size.height * 0.4,
                    width: size.width * 0.3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/default_logo.png',
                            image: bookList[i].coverUrl,
                            fadeInDuration: const Duration(milliseconds: 350),
                            fit: BoxFit.fill,
                            // placeholderFit: BoxFit.fill,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/images/default_logo.png',
                            ),
                          )
                        ),
                        const SizedBox(height: 10),
                        Text(
                          bookList[i].title,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  fontWeight: FontWeight.w100, fontSize: 13),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        Text(
                          bookList[i].author,
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(
                                  fontWeight: FontWeight.w100,
                                  color: Theme.of(context).hintColor,
                                  fontSize: 10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: bookList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 0.52),
          ),
        ),
      ],
    );
  }
}
