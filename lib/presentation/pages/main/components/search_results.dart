import 'package:bke/presentation/pages/main/components/result_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/search/search_bloc.dart';
import '../../../../bloc/search/search_state.dart';
import '../../../theme/app_color.dart';

class SearchResultsPage extends StatefulWidget {
  @override
  _SearchResultsPageState createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocBuilder<SearchBloc, SearchState>(builder: (context, state) {
      if (state is SearchLoadedState) {
        final books = state.books ?? [];
        final videos = state.videos ?? [];
        if (videos.isEmpty) {
          // search book only
          return ResultList(data: books, isBook: true);
        } else if (books.isEmpty) {
          return ResultList(data: videos, isBook: false);
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Video',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(
                height: size.height * 0.2,
                child: ResultList(data: videos, isBook: false)),
            SizedBox(height: size.height * 0.02),
            Text(
              'Sách',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(
                height: size.height * 0.2,
                child: ResultList(data: books, isBook: true)),
          ],
        );
      }
      return Center(child: CircularProgressIndicator(color: AppColor.primary));
    });
  }
}
