import 'package:bke/utils/extension.dart';
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
  
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading.toCapitalize(),
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
                if (book.checkpoint != null && heading == "Tiếp tục đọc") {
                  final argument = BookArguments(bookId: book.bookId, id: book.id);
                  Navigator.of(context).pushNamed(RouteName.bookRead, arguments: argument);
                }
                else if (book.checkpoint != null && heading == "Tiếp tục nghe") {
                  final argument = BookArguments(
                                                  bookId: book.bookId,
                                                  id: book.id,
                                                  title: book.title,
                                                  coverUrl: book.coverUrl,
                                                  mp3Url: book.mp3Url
                                    );
                    Navigator.of(context).pushNamed(RouteName.bookListen, arguments: argument);
                }
                else{
                  Navigator.of(context)
                      .pushNamed(RouteName.bookDetails, arguments: book.bookId);
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