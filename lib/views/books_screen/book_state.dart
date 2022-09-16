import 'package:equatable/equatable.dart';
import '../../models/book_model.dart';

abstract class BookState extends Equatable{}
abstract class DetailsState extends Equatable{}

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






class DetailsLoadingState extends DetailsState{
  @override
  List<Object?> get props => [];
}

class DetailsLoadedState extends DetailsState{
  DetailsLoadedState(this.book);
  final BookModel book;
  
  @override
  List<Object?> get props => [book];
}

class DetailsErrorState extends DetailsState{
  DetailsErrorState(this.e);
  final String e;
  @override
  List<Object?> get props => [e];
}
