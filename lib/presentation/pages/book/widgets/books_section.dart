import 'package:flutter/material.dart';

import '../../../routes/route_name.dart';

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