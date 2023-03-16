import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable{
  const SearchEvent();
}


class SearchAllEvent extends SearchEvent{
  final String query;
  const SearchAllEvent({required this.query});
  @override
  List<Object> get props => [query];
}

class SearchBooksEvent extends SearchEvent{
  final String query;
  const SearchBooksEvent({required this.query});
  @override
  List<Object> get props => [query];
}

class SearchVideosEvent extends SearchEvent{
  final String query;
  const SearchVideosEvent({required this.query});
  @override
  List<Object> get props => [query];
}



