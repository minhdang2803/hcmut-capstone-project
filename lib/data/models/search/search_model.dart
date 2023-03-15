import 'package:bke/data/models/video/video_youtube_info_model.dart';
import 'package:bke/utils/log_util.dart';
import '../book/book_info.dart';

class SearchResponse{
  SearchResponse({required this.books, required this.videos});

  List<BookInfo> books = [];
  List<VideoYoutubeInfo> videos = [];

  SearchResponse.fromJson(Map<String, dynamic> json) {

    for (var e in (json['books'] as List)) {
      books.add(BookInfo.fromJson(e));
    }

    for (var e in (json['videos'] as List)) {
      videos.add(VideoYoutubeInfo.fromJson(e));
    }

    // metadata = MetaDataModel.fromJson(json['meta_data']);
  }
}