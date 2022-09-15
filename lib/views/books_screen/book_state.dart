import 'package:equatable/equatable.dart';
import '../../models/book_model.dart';

abstract class BookState extends Equatable{}

class BookLoadingState extends BookState{
  @override
  List<Object?> get props => [];
}

class BookLoadedState extends BookState{
  BookLoadedState(this.books);
  final List<BookModel> books;

  @override
  List<Object?> get props => [books];
}

class BookErrorState extends BookState{
  BookErrorState(this.e);
  final String e;
  @override
  List<Object?> get props => [e];
}

class DetailBookState extends BookState{
  DetailBookState(this.book);
  final BookModel book;
  
  @override
  List<Object?> get props => [book];
}
