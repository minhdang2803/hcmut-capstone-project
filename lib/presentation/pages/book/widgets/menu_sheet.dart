import 'package:bke/utils/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/book/book_bloc.dart';
import '../../../../bloc/book/book_event.dart';
import '../../../theme/app_color.dart';

class MenuSheet extends StatefulWidget {
  const MenuSheet({Key? key}) : super(key: key);

  @override
  State<MenuSheet> createState() => _MenuSheetState();
}

class _MenuSheetState extends State<MenuSheet> {
  bool picked = false;
  int at = 0;
  final String category = 'Home';
  final List<String> menuList = <String>[
    'Home',
    'Tiếp tục đọc',
    'Tiếp tục nghe',
    'Danh sách yêu thích',
    'adventure',
    'detective',
    'non-fiction',
    'short-story',
    'biography',
    'fantasy',
    'Classics',
    'thriller',
    'fairytale',
    'fiction',
    'Technology & Science',
    'human interest',
    'documentary',
    'science',
    'Biography',
    'crime',
    'science fiction',
    'mystery',
    'Human interest',
    'classics',
    'horror',
    'novella',
    'business',
    'novel',
    'love story',
    'Romance',
    'drama',
    'gothic horror',
    'Horror',
    'satire',
    'romance',
    'historical',
    'Historical',
    'Culture',
    'Historical fiction',
    'folk tale',
    'Young life/adventure',
    'Movies',
    'Thriller',
    'comedy',
    'Adventure',
    'movies',
    'tale',
    'Short stories',
    'Science fiction'
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Container(
      color: AppColor.appBackground,
      padding: EdgeInsets.only(top: size.height * 0.05),
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
                menuList[i].toCapitalize(),
                style: picked && i == at
                    ? Theme.of(context).textTheme.headlineMedium!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: AppColor.primary,
                        )
                    : Theme.of(context).textTheme.headlineSmall!.copyWith(
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
