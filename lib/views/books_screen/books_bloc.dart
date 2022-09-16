import '../../data/repository/book_repos.dart';
import 'book_state.dart';
import 'book_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookBloc extends Bloc<BookEvent, BookState>{
  final BookRepos? _bookRepos;

  BookBloc(this._bookRepos) : super(BookLoadingState()){
    on<LoadBookEvent>(_onLoadAll);
  }


  void _onLoadAll(LoadBookEvent event, Emitter<BookState> emit) async{
      emit(BookLoadingState());
      try{
        // final books = await _bookRepos.getBooks();
        final books = allBooks;
        emit(BookLoadedState(books));
      }
      catch(e){
        emit(BookErrorState(e.toString()));
      }
  }
}





class DetailsBloc extends Bloc<DetailsEvent, DetailsState>{

  DetailsBloc() : super(DetailsLoadingState()){
    on<LoadDetailsEvent>(_onLoadDetails);
  }
  void _onLoadDetails(LoadDetailsEvent event, Emitter<DetailsState> emit){
    emit(DetailsLoadingState());
      try{
        // final books = await _bookRepos.getBooks();
        final book = event.book;
        emit(DetailsLoadedState(book));
      }
      catch(e){
        emit(DetailsErrorState(e.toString()));
      }
  }
}