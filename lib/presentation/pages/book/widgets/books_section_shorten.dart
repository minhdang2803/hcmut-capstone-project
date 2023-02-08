import 'package:flutter/material.dart';

import '../../../../data/models/book/book_info.dart';
import '../../../../data/models/book/book_listener.dart';
import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';

class BookSection extends StatelessWidget {
  final String heading;
  final List<BookInfo> bookList;

  const BookSection({Key? key, required this.heading, required this.bookList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    print(bookList);
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
                // if (book.mode == Mode.start.index) {
                  Navigator.of(context)
                      .pushNamed(RouteName.bookDetails, arguments: book.bookId);
                // } else if (book.mode == Mode.reading.index) {
                //   Navigator.of(context)
                //       .pushNamed(RouteName.bookRead, arguments: book.bookId);
                // } else {
                //   var argument = BookListenArguments(
                //       book.bookId, book.title, book.coverUrl, book.mp3Url);
                //   Navigator.of(context)
                //       .pushNamed(RouteName.bookListen, arguments: argument);
                // }
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