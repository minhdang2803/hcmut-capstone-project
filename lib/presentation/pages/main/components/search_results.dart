import 'package:bke/presentation/pages/main/components/result_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/search/search_bloc.dart';
import '../../../../bloc/search/search_state.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';

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

    return BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchLoadedState){
                final books = state.books??[];
                final videos = state.videos??[];
                if (videos.isEmpty){// search book only
                  return Column(
                    children: [
                      ResultList(data: books, isBook: true),
                    ],
                  );
                }
                else if (books.isEmpty){
                  return Column(
                    children: [
                      ResultList(data: videos, isBook: false),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Video',
                      style: AppTypography.title.copyWith(color: AppColor.textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    ResultList(data: videos, isBook: false),
                    SizedBox(height: 0.02.sh),
                    Text(
                      'Sách',
                      style: AppTypography.title.copyWith(color: AppColor.textPrimary, fontSize: 20, fontWeight: FontWeight.w600),
                    ),
                    ResultList(data: books, isBook: true)
                  ],
                );
            }
            return const Center(
                  child: CircularProgressIndicator(color: AppColor.secondary));
          }
    );
  }
}
