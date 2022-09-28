import '../../data/repository/book_repository.dart';
import 'book_state.dart';
import 'book_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookBloc extends Bloc<BookEvent, BookState>{
  final BookRepos? _bookRepos;

  BookBloc(this._bookRepos) : super(BookLoadingState('Home')){
    on<LoadAllEvent>(_onLoadAll);
    on<LoadByCategoryEvent>(_onLoadByCategory);
  }

  void _onLoadAll(LoadAllEvent event, Emitter<BookState> emit) async{
      emit(BookLoadingState('Home'));
      try{
        // final books = await _bookRepos.getAll();
        final books = allBooks;
        emit(BookLoadedState(books, 'Home'));
      }
      catch(e){
        emit(BookErrorState(e.toString()));
      }
  }

  void _onLoadByCategory(LoadByCategoryEvent event, Emitter<BookState> emit) async{
    emit(BookLoadingState(event.category));
    try{
        // final books = await _bookRepos.getbyCategory();
        final books = fictionBooks;
        emit(BookLoadedState(books, event.category));
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