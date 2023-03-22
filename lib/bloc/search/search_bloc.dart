import 'package:bke/data/models/book/book_info.dart';
import '../../data/repositories/search_repository.dart';
import '../../utils/log_util.dart';
import 'search_state.dart';
import 'search_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

late List<BookInfo> _books;

class SearchBloc extends Bloc<SearchEvent, SearchState>{
  final _searchRepos = SearchRepository.instance();


  SearchBloc() : super(SearchLoadingState()){

    on<SearchAllEvent>(_onSearchAll);
    on<SearchBooksEvent>(_onSearchBooks);
    on<SearchVideosEvent>(_onSearchVideos);
  }

  void _onSearchAll(SearchAllEvent event, Emitter<SearchState> emit) async{
      emit(SearchLoadingState());
      try{
        var response = await _searchRepos.searchAll(event.query);
        var res = response.data! ;
        print(res.books.first);
        emit(SearchLoadedState(books: res.books, videos: res.videos, query: event.query));
      }
      catch(e){
        emit(SearchErrorState(e.toString()));
      }
  }

  void _onSearchBooks(SearchBooksEvent event, Emitter<SearchState> emit) async{
      emit(SearchLoadingState());
      try{
        var response = await _searchRepos.searchBooks(event.query);
        var res = response.data?.list ?? [];
        emit(SearchLoadedState(books: res, query: event.query));
      }
      catch(e){
        emit(SearchErrorState(e.toString()));
      }
  }

  void _onSearchVideos(SearchVideosEvent event, Emitter<SearchState> emit) async{
      emit(SearchLoadingState());
      try{
        var response = await _searchRepos.searchVideos(event.query);
        var res = response.data?.list ?? [];
        emit(SearchLoadedState(videos: res, query: event.query));
      }
      catch(e){
        emit(SearchErrorState(e.toString()));
      }
  }
}
