

import '../data_source/remote/search/search_source.dart';
import '../models/book/book_info.dart';
import '../models/network/base_response.dart';
import '../models/search/search_model.dart';
import '../models/video/video_youtube_info_model.dart';

class SearchRepository{
  late final SearchSource _searchSource;
  // late final SearchLocalSource _SearchLocalSource;

  SearchRepository._internal() {
    _searchSource = SearchSourceImpl();
    // _SearchLocalSource = SearchLocalSourceImpl();
  }
  static final _instance = SearchRepository._internal();

  factory SearchRepository.instance() => _instance;
  
  Future<BaseResponse<SearchResponse>> searchAll(String query) async {
    return await _searchSource.searchAll(query);
  }

  Future<BaseResponse<BookInfos>> searchBooks(String query) async {
    return await _searchSource.searchBooks(query);
  }

  Future<BaseResponse<VideoYoutubeInfos>> searchVideos(String query) async {
    return await _searchSource.searchVideos(query);
  }

}

