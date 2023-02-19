import 'package:bke/data/models/book/book_info.dart';
import 'package:bke/data/models/network/base_response.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

import '../../data/models/book/book_reader.dart';
import '../../data/models/network/cvn_exception.dart';
import '../../data/repositories/book_repository.dart';
import '../../utils/log_util.dart';
import 'book_state.dart';
import 'book_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

late List<BookInfo> _books;

class BookListBloc extends Bloc<BookListEvent, BookListState>{
  final _bookRepos = BookRepository.instance();


  BookListBloc() : super(BookListLoadingState('Home')){

    on<LoadAllEvent>(_onLoadAll);
    on<LoadByCategoryEvent>(_onLoadByCategory);
  }

  void _onLoadAll(LoadAllEvent event, Emitter<BookListState> emit) async{
      emit(BookListLoadingState('Home'));
      try{
  
        var response = await _bookRepos.getAll();
        var homeData = response.data!.list ;
        // print(_data);
        _books = [];
        // homeData[0].list = homeData[0].list.reversed as List<BookInfo>;
        // homeData[1].list = homeData[1].list.reversed as List<BookInfo>;
        // homeData[2].list = homeData[2].list.reversed as List<BookInfo>;
       
        for (var category in homeData) {
          _books = _books + category.list;
        }
        
        // print(_books);
        
        emit(BookListLoadedState(homeData, 'Home'));
      }
      catch(e){
        emit(BookListErrorState(e.toString()));
      }
  }


  void _onLoadByCategory(LoadByCategoryEvent event, Emitter<BookListState> emit) async{
    emit(BookListLoadingState(event.category));
    
    try{
        // ignore: prefer_typing_uninitialized_variables
        late final response;
        if (event.category == "Continue reading"){
          response = await _bookRepos.getContinueReading();          
        }
        else if (event.category == "Continue listening"){
          response = await _bookRepos.getContinueListening();
        }
        else if(event.category == "Favorite"){
          response = await _bookRepos.getFavorites();
        }
        else{
          response = await _bookRepos.getByCategory(event.category);
        }
        _books = response.data?.list ?? [];
        emit(BookListLoadedState(_books,  event.category));
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
    on<LoadEbookAnotherEvent>(_onLoadEbookAnother);
    on<LoadAudioBookEvent>(_onLoadAudioBook);
    on<UpdateCkptEvent>(_onUpdateCkpt);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
  }

  void _onLoadDetails(LoadDetailsEvent event, Emitter<BookState> emit) async{
    emit(BookLoadingState());
      try{
        
        final response = await _bookRepos.getBookInfo(event.bookId);
        final _matchBook = response.data!;
        
        emit(BookLoadedState(_matchBook));
      }
      catch(e){
        emit(BookErrorState(e.toString()));
      }
  }

  
  void _onLoadEbook(LoadEbookEvent event, Emitter<BookState> emit) async{
    emit(BookLoadingState());
      try{
  
        final response = await _bookRepos.getEbook(event.bookId, event.pageKey);
        
        final bookReader = response.data;
        
        emit(EbookLoadedState(bookReader));
      } 
      on RemoteException catch (e, s) {
      LogUtil.error('Get Ebook error ${e.message}',
            error: e, stackTrace: s);
      }
      catch(e){
        emit(BookErrorState(e.toString()));
      }
  }

  void _onLoadEbookAnother(LoadEbookAnotherEvent event, Emitter<BookState> emit) async{
    emit(BookLoadingState());
      try{
  
        final response = await _bookRepos.getEbook(event.bookId, event.pageKey);
        
        final bookReader = response.data;
        
        emit(EbookLoadedAnotherState(bookReader));
      } 
      on RemoteException catch (e, s) {
      LogUtil.error('Get Ebook error ${e.message}',
            error: e, stackTrace: s);
      }
      catch(e){
        emit(BookErrorState(e.toString()));
      }
  }

  void _onLoadAudioBook(LoadAudioBookEvent event, Emitter<BookState> emit) async{
    emit(BookLoadingState());
      try{
        final response = await _bookRepos.getAudioBook(event.bookId);
        emit(AudioBookLoadedState(response.data!));
      }
      catch(e){
        emit(BookErrorState(e.toString()));
      }
  }

  void _onUpdateCkpt(UpdateCkptEvent event, Emitter<BookState> emit) async{
      await _bookRepos.updateCkpt(event.bookId, event.ckpt, event.isEbook);
  }

  void _onAddFavorite(AddFavoriteEvent event, Emitter<BookState> emit) async{
      await _bookRepos.addFavorite(event.bookId);
  }

  void _onRemoveFavorite(RemoveFavoriteEvent event, Emitter<BookState> emit) async{
      await _bookRepos.removeFavorite(event.bookId);
  }

}