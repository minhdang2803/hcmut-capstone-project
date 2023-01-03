import 'package:bke/data/models/book/book_info.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../../data/repositories/book_repository.dart';
import 'book_state.dart';
import 'book_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookListBloc extends Bloc<BookListEvent, BookListState>{
  final _bookRepos = BookRepository.instance();

  BookListBloc() : super(BookListLoadingState('Home')){

    on<LoadAllEvent>(_onLoadAll);
    on<LoadByCategoryEvent>(_onLoadByCategory);
  }

  void _onLoadAll(LoadAllEvent event, Emitter<BookListState> emit) async{
      emit(BookListLoadingState('Home'));
      try{
        
        final books = await _bookRepos.getAll();
        emit(BookListLoadedState(books, 'Home'));
      }
      catch(e){
        emit(BookListErrorState(e.toString()));
      }
  }


  void _onLoadByCategory(LoadByCategoryEvent event, Emitter<BookListState> emit) async{
    emit(BookListLoadingState(event.category));
    
    try{
        final books = await _bookRepos.getByCategory(event.category);
        emit(BookListLoadedState(books,  event.category));
      }
      catch(e){
        emit(BookListErrorState(e.toString()));
      }

  }
}





class BookBloc extends Bloc<BookEvent, BookState>{
  final _bookRepos = BookRepository.instance();

  BookBloc() : super(BookLoadingState()){
    on<LoadDetailsEvent>(_onLoadDetails);
    on<LoadEbookEvent>(_onLoadEbook);
    on<LoadAudioBookEvent>(_onLoadAudioBook);
    // on<UpdateCkptEvent>(_onUpdateCkpt);
  }

  void _onLoadDetails(LoadDetailsEvent event, Emitter<BookState> emit) async{
    emit(BookLoadingState());
      try{
        final book = await _bookRepos.getBookInfo(event.bookId);
        emit(BookLoadedState(book));
      }
      catch(e){
        emit(BookErrorState(e.toString()));
      }
  }

  void _onLoadEbook(LoadEbookEvent event, Emitter<BookState> emit) async{
    emit(BookLoadingState());
      try{
        final book = await _bookRepos.getEbook(event.bookId, event.pageKey);
        emit(EbookLoadedState(book));
      }
      catch(e){
        emit(BookErrorState(e.toString()));
      }
  }

  void _onLoadAudioBook(LoadAudioBookEvent event, Emitter<BookState> emit) async{
    emit(BookLoadingState());
      try{
        final book = await _bookRepos.getAudioBook(event.bookId);
        emit(AudioBookLoadedState(book));
      }
      catch(e){
        emit(BookErrorState(e.toString()));
      }
  }

  // void _onUpdateCkpt(UpdateCkptEvent event, Emitter<BookState> emit) async{
  //     try{
  //       await _bookRepos.updateCkptEvent(event.bookId);
  //     }
  //     catch(e){
  //       emit(BookErrorState(e.toString()));
  //     }
  // }
}