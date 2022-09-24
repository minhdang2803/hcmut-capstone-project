import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';

class MonasterySearchDelegate extends SearchDelegate {
  final List<String> _historySearch = [];

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear_rounded),
        onPressed: () {
          if (query.isNotEmpty) {
            query = '';
            showSuggestions(context);
          } else {
            close(context, null);
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_rounded),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: Text(query),
    );
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
    return ListView.separated(
      padding: EdgeInsets.symmetric(vertical: 20.r),
      separatorBuilder: (context, index) => 10.verticalSpace,
      itemCount: _historySearch.length,
      itemBuilder: (context, index) => ListTile(
        leading: Image.asset(
          'assets/images/default_monastery.png',
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
    );
  }

  @override
  String get searchFieldLabel => 'Tìm kiếm chùa';

  @override
  TextStyle? get searchFieldStyle =>
      AppTypography.body.copyWith(color: AppColor.textSecondary);

  @override
  TextInputType? get keyboardType => TextInputType.name;

  @override
  ThemeData appBarTheme(BuildContext context) {
    final theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: AppBarTheme(
        toolbarHeight: 63.r,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: AppColor.textSecondary,
        ),
        elevation: 3,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
      )
    );
  }
}
