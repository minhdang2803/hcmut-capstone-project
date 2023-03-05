// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:ui';

import 'package:bke/presentation/pages/book/widgets/like.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter/material.dart';
import '../../../bloc/book/book_bloc.dart';
import '../../../bloc/book/book_state.dart';
import '../../../bloc/book/book_event.dart';

import '../../../data/models/book/book_info.dart';
import '../../../data/models/book/book_listener.dart';

import '../../routes/route_name.dart';

import '../../theme/app_color.dart';

class BookDetails extends StatefulWidget {
  const BookDetails({super.key, required this.bookId});
  final String bookId;

  @override
  State<BookDetails> createState() => _BookDetails();
}

class _BookDetails extends State<BookDetails> {
  late final BookBloc _bookBloc;
  late final BookInfo _bookInfo;
  late bool _isLiked;
  @override
  void initState() {
    super.initState();
    _bookBloc = BookBloc();
    _bookBloc.add(LoadDetailsEvent(bookId: widget.bookId));
  }

  @override
  void dispose() {
    _bookBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocProvider(
        create: (context) => _bookBloc,
        child: BlocBuilder<BookBloc, BookState>(builder: (context, state) {
          if (state is BookLoadedState) {
            try {
              _bookInfo = state.book;
              _isLiked = _bookInfo.isLiked!;
              return Scaffold(
                  body: Container(
                      height: size.height,
                      width: size.width,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(_bookInfo.coverUrl),
                            fit: BoxFit.cover),
                      ),
                      child: BackdropFilter(
                          filter: ImageFilter.blur(
                            sigmaX: 5,
                            sigmaY: 5,
                          ),
                          child: Container(
                              alignment: Alignment.center,
                              color: Colors.black.withOpacity(0.1),
                              child: SafeArea(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    _appBar(),
                                    Container(
                                      margin: const EdgeInsets.only(
                                        bottom: 20,
                                      ),
                                      height: size.height * 0.4,
                                      width: size.width * 0.53,
                                      child: Stack(
                                        children: [
                                          SizedBox(
                                            width: double.infinity,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              child: Image.network(
                                                _bookInfo.coverUrl,
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Expanded(
                                        child: Container(
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: AppColor.appBackground,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(50),
                                          topRight: Radius.circular(50),
                                        ),
                                      ),
                                      padding: const EdgeInsets.only(
                                          left: 30, right: 30, top: 30),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _bookInfo.author,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge!
                                                .copyWith(
                                                  fontWeight: FontWeight.normal,
                                                  color: Theme.of(context)
                                                      .hintColor,
                                                ),
                                          ),
                                          const SizedBox(
                                            height: 8,
                                          ),
                                          Text(
                                            _bookInfo.title,
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall,
                                          ),
                                          const SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                _bookInfo.mp3Url != ''
                                                    ? MainAxisAlignment
                                                        .spaceAround
                                                    : MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                width: size.width * 0.4,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(70),
                                                  color: AppColor.primary,
                                                ),
                                                child: TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pushNamed(
                                                        RouteName.bookRead,
                                                        arguments:
                                                            BookArguments(
                                                                bookId:
                                                                    _bookInfo
                                                                        .bookId,
                                                                id: _bookInfo
                                                                    .id,
                                                                title: _bookInfo
                                                                    .title));
                                                  },
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceEvenly,
                                                    children: [
                                                      const Icon(
                                                          Icons.menu_book,
                                                          size: 20,
                                                          color: AppColor
                                                              .appBackground),
                                                      const Text(
                                                        "Read",
                                                        style: TextStyle(
                                                          color: AppColor
                                                              .appBackground,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontSize: 15,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Visibility(
                                                visible: _bookInfo.mp3Url != '',
                                                child: Container(
                                                  width: size.width * 0.4,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            70),
                                                    color: AppColor.primary,
                                                  ),
                                                  child: TextButton(
                                                    onPressed: () {
                                                      final argument =
                                                          BookArguments(
                                                              bookId: _bookInfo
                                                                  .bookId,
                                                              id: _bookInfo.id,
                                                              title: _bookInfo
                                                                  .title,
                                                              coverUrl:
                                                                  _bookInfo
                                                                      .coverUrl,
                                                              mp3Url: _bookInfo
                                                                  .mp3Url);
                                                      Navigator.of(context)
                                                          .pushNamed(
                                                              RouteName
                                                                  .bookListen,
                                                              arguments:
                                                                  argument);
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        Icon(Icons.headphones,
                                                            size: 20,
                                                            color: AppColor
                                                                .appBackground),
                                                        Text(
                                                          "Listen",
                                                          style: TextStyle(
                                                            color: AppColor
                                                                .appBackground,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 15,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ))
                                  ],
                                ),
                              )))));
            } catch (e) {
              return Center(
                  child: CircularProgressIndicator(color: AppColor.primary));
            }
          }
          return Center(
              child: CircularProgressIndicator(color: AppColor.primary));
        }));
  }

  Widget _appBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColor.appBackground,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          LikeButton(isLiked: _bookInfo.isLiked!, id: _bookInfo.id)
        ],
      ),
    );
  }
}
