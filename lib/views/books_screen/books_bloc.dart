import '../../data/repository/book_repos.dart';
import 'book_state.dart';
import 'book_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookBloc extends Bloc<BookEvent, BookState>{
  final BookRepos _bookRepos;

  BookBloc(this._bookRepos) : super(BookLoadingState()){
    on<LoadBookEvent>((event, emit) async{
      emit(BookLoadingState());
      try{
        // final books = await _bookRepos.getBooks();
        final books = allBooks;
        emit(BookLoadedState(books));
      }
      catch(e){
        emit(BookErrorState(e.toString()));
      }
    });
  }
}