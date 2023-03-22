import 'package:bke/presentation/pages/main/components/search_results.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/search/search_bloc.dart';
import '../../../../bloc/search/search_event.dart';
import '../../../../data/models/search/search_model.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';

class MonasterySearchDelegate extends SearchDelegate {
  MonasterySearchDelegate({required this.searchType});

  final List<String> _historySearch = [];
  final SearchType searchType;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [SizedBox(width: 20.r)];
    // return [
    //   IconButton(
    //     icon: const Icon(Icons.clear_rounded, color: Colors.white),
    //     onPressed: () {
    //       if (query.isNotEmpty) {
    //         query = '';
    //         showSuggestions(context);
    //       } else {
    //         close(context, null);
    //       }
    //     },
    //   ),
    // ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(
        color: AppColor.primary,
        padding: const EdgeInsets.only(top: 20.0),
        child: Container(
            padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: BlocProvider(
                create: (context) {
                  if (searchType == SearchType.all) {
                    return SearchBloc()..add(SearchAllEvent(query: query));
                  } else if (searchType == SearchType.videos) {
                    return SearchBloc()..add(SearchVideosEvent(query: query));
                  }
                  return SearchBloc()..add(SearchBooksEvent(query: query));
                },
                child: SearchResultsPage())));
  }

  @override
  void showResults(BuildContext context) {
    if (!_historySearch.contains(query) && query.isNotEmpty) {
      _historySearch.insert(0, query);
    }
    if (query.isNotEmpty) {
      super.showResults(context);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(
      color: AppColor.primary,
      padding: EdgeInsets.only(top: 10.0.r),
      child: Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r),
            topRight: Radius.circular(30.r),
          ),
        ),
        child: ListView.separated(
          padding: EdgeInsets.symmetric(vertical: 20.r),
          separatorBuilder: (context, index) => 10.verticalSpace,
          itemCount: _historySearch.length,
          itemBuilder: (context, index) => ListTile(
            leading: Image.asset(
              'assets/images/default_logo.png',
              width: 36.r,
              height: 36.r,
              fit: BoxFit.contain,
            ),
            title: Text(_historySearch[index], style: AppTypography.body),
            trailing: const Icon(Icons.history_rounded),
            onTap: () {
              query = _historySearch[index];
              showResults(context);
            },
          ),
        ),
      ),
    );
  }

  @override
  String get searchFieldLabel => searchType == SearchType.all
      ? 'Tra từ vựng, video, sách,...'
      : searchType == SearchType.books
          ? 'Tra sách'
          : 'Tra video';

  @override
  TextStyle? get searchFieldStyle =>
      AppTypography.body.copyWith(color: AppColor.lightGray);

  @override
  TextInputType? get keyboardType => TextInputType.name;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
          toolbarHeight: 50.r,
          backgroundColor: AppColor.primary,
          titleSpacing: 0,
          iconTheme: const IconThemeData(
            color: Colors.white,
          ),
          elevation: 0),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: AppTypography.body.copyWith(color: AppColor.lightGray),
        filled: true,
        fillColor: Colors.black.withOpacity(0.1),
        border: UnderlineInputBorder(
          borderRadius: BorderRadius.circular(
            15.r,
          ),
        ),
      ),
    );
  }
}
