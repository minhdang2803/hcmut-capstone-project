import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
          style: AppTypography.title.copyWith(fontWeight: FontWeight.bold),
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
                  final argument = BookArguments(bookId: book.bookId, id: book.id, title: book.title);
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
              child: Column(
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
                          color: AppColor.primary,
                          child: FadeInImage.assetNetwork(
                            placeholder: 'assets/images/default_logo.png',
                            placeholderFit: BoxFit.contain,
                            image: bookList[i].coverUrl,
                            fadeInDuration: const Duration(milliseconds: 400),
                            fit: BoxFit.fill,
                            // placeholderFit: BoxFit.fill,
                            imageErrorBuilder: (context, error, stackTrace) =>
                                Image.asset(
                              'assets/images/default_logo.png',
                            ),
                          ),
                        ),
                      )
                    ),
                    // Visibility(
                    // visible:  heading == "Tiếp tục đọc",
                    // child: SizedBox(
                    //       height: 5.r,
                    //       child: LinearProgressIndicator(
                    //         color: AppColor.accentBlue,
                    //         value: bookList.elementAt(i).checkpoint! *100 / int.parse(bookList.elementAt(i).totalWords!).toDouble(),
                    //       ),
                    //     )
                    // ),
                  // Visibility(
                  //   visible: bookList.elementAt(i).checkpoint != null,
                  //   child: Container(
                  //     color: AppColor.primary,
                  //     child: Row(
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: [
                  //         IconButton(
                  //           iconSize: 14.r,
                  //           color: AppColor.textPrimary,
                  //           onPressed: () {
                  //             _showInfo(context);
                  //           },
                  //           icon: const FaIcon(FontAwesomeIcons.circleExclamation),
                  //         ),
                  //         IconButton(
                  //           iconSize: 14.r,
                  //           color: AppColor.textPrimary,
                  //           onPressed: () {},
                  //           icon: const FaIcon(FontAwesomeIcons.ellipsisVertical),
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
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