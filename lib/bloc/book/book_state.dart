import 'package:bke/data/models/book/book_listener.dart';
import 'package:bke/data/models/book/book_reader.dart';
import 'package:bke/presentation/pages/book/book_listen.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/book/book_info.dart';

abstract class BookListState extends Equatable{}
abstract class BookState extends Equatable{}

class BookListLoadingState extends BookListState{
  BookListLoadingState(this.category);
  final String category;

  @override
  List<Object?> get props => [category];
}

class BookListLoadedState extends BookListState{
  BookListLoadedState(this.books, this.category);
  final List<BookInfo> books;
  final String category;

  @override
  List<Object?> get props => [books, category];
}


class BookListErrorState extends BookListState{
  BookListErrorState(this.e);
  final String e;
  @override
  List<Object?> get props => [e];
}






class BookLoadingState extends BookState{
  @override
  List<Object?> get props => [];
}

class BookLoadedState extends BookState{
  BookLoadedState(this.book);
  final BookInfo book;

  @override
  List<Object?> get props => [book];
}

class EbookLoadedState extends BookState{
  EbookLoadedState(this.book);
  final BookReader book;

  @override
  List<Object?> get props => [book];
}

class AudioBookLoadedState extends BookState{
  AudioBookLoadedState(this.book);
  final BookListener book;

  @override
  List<Object?> get props => [book];
}

class BookErrorState extends BookState{
  BookErrorState(this.e);
  final String e;
  @override
  List<Object?> get props => [e];
}
