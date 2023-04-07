import 'package:bke/data/models/book/book_listener.dart';
import 'package:bke/data/models/book/book_reader.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/news/news_model.dart';

abstract class NewsListState extends Equatable{}
abstract class NewsState extends Equatable{}

class NewsListLoadingState extends NewsListState{
  NewsListLoadingState(this.category);
  final String category;

  @override
  List<Object?> get props => [category];
}

class NewsListLoadedState extends NewsListState{
  NewsListLoadedState(this.newsList, this.category);
  final List<dynamic> newsList;
  final String category;

  @override
  List<Object?> get props => [newsList, category];
}


class NewsListErrorState extends NewsListState{
  NewsListErrorState(this.e);
  final String e;
  @override
  List<Object?> get props => [e];
}






