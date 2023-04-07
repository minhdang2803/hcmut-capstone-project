import 'package:bke/data/models/news/news_model.dart';
import '../../data/models/network/cvn_exception.dart';
import '../../data/repositories/news_repository.dart';
import '../../utils/constants.dart';
import '../../utils/log_util.dart';
import 'news_state.dart';
import 'news_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

late List<NewsInfo> _newsList;

class NewsListBloc extends Bloc<NewsListEvent, NewsListState>{
  final _newsRepos = NewsRepository.instance();


  NewsListBloc() : super(NewsListLoadingState('TopHeadlines')){

    on<LoadTopHeadlinesEvent>(_onLoadTopHeadlines);
    on<LoadByCategoryEvent>(_onLoadByCategory);
    on<LoadAllCategoriesEvent>(_onLoadAllCategories);
  }

  void _onLoadTopHeadlines(LoadTopHeadlinesEvent event, Emitter<NewsListState> emit) async{
      emit(NewsListLoadingState('TopHeadlines'));
      try{
        var response = await _newsRepos.getTopHeadlines();
        var homeData = response.data!.list ;
        emit(NewsListLoadedState(homeData, 'TopHeadlines'));
     
      }
      catch(e){
        emit(NewsListErrorState(e.toString()));
      }
  }


  void _onLoadByCategory(LoadByCategoryEvent event, Emitter<NewsListState> emit) async{
    emit(NewsListLoadingState(event.category));
    
    try{
        final response = await _newsRepos.getByCategory(event.category);
        
        emit(NewsListLoadedState(response.data?.list ?? [],  event.category));
      }
      catch(e){
        emit(NewsListErrorState(e.toString()));
      }
  }

  void _onLoadAllCategories(LoadAllCategoriesEvent event, Emitter<NewsListState> emit) async{
    emit((NewsListLoadingState('Home')));
    final List<String> categories = ["business", "entertainment", "general", "health", "science", "sports", "technology"];
    late List<dynamic> results = [];
  
    try{
      for (var i = 0; i < categories.length; i+=1){
          final response = await _newsRepos.getByCategory(categories[i]);
          if (response.data!.list.isNotEmpty){
            late Map<String, dynamic> news = {"category":"", 
                                              "list":[]};
            news["category"] = [categories[i]];
            news["list"] =  response.data?.list;
            results.add(news);
          }
      }
      emit(NewsListLoadedState(results,  'Home'));
    }
    catch(e){
        emit(NewsListErrorState(e.toString()));
      }
    
  }
}




