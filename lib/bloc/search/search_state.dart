import 'package:equatable/equatable.dart';
import '../../data/models/book/book_info.dart';
import '../../data/models/video/video_youtube_info_model.dart';

abstract class SearchState extends Equatable{}

class SearchLoadingState extends SearchState{
  SearchLoadingState();

  @override
  List<Object?> get props => [];
}

class SearchLoadedState extends SearchState{
  SearchLoadedState({this.books, this.videos, required this.query});
  final List<BookInfo>? books;
  final List<VideoYoutubeInfo>? videos;
  final String query;

  @override
  List<Object?> get props => [books, videos, query];
}


class SearchErrorState extends SearchState{
  SearchErrorState(this.e);
  final String e;
  @override
  List<Object?> get props => [e];
}


