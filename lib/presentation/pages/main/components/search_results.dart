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

    return BlocBuilder<SearchBloc, SearchState>(
            builder: (context, state) {
              if (state is SearchLoadedState){
                final books = state.books;
                final videos = state.videos;
                return ListView.builder(
                itemCount: books.length, // Replace with your actual data length
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            left: 10,
                          ),
                          width: size.width * 0.1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Container(
                              height: size.height * 0.1,
                              color: AppColor.lightGray,
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/default_logo.png',
                                placeholderFit: BoxFit.contain,
                                image: books.elementAt(index).coverUrl,
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
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              books.elementAt(index).title, // Replace with your actual title
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              books.elementAt(index).author, // Replace with your actual description
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            }
            return Center(
                  child: CircularProgressIndicator(color: AppColor.primary));
          }
    );
  }
}
