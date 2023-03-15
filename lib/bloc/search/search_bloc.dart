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
  }

  void _onSearchAll(SearchAllEvent event, Emitter<SearchState> emit) async{
      emit(SearchLoadingState());
      try{
        var response = await _searchRepos.searchAll(event.query);
        var res = response.data! ;
        LogUtil.debug(res.books.first as String?);
        emit(SearchLoadedState(res.books, res.videos, event.query));
      }
      catch(e){
        emit(SearchErrorState(e.toString()));
      }
  }
}
