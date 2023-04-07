import 'package:equatable/equatable.dart';

abstract class NewsListEvent extends Equatable{
  const NewsListEvent();
}

class LoadTopHeadlinesEvent extends NewsListEvent{
  @override
  List<Object> get props => [];
}

class LoadByCategoryEvent extends NewsListEvent{
  final String category;
  const LoadByCategoryEvent({required this.category});
  @override
  List<Object> get props => [category];
}

class LoadAllCategoriesEvent extends NewsListEvent{
  final int limit;
  const LoadAllCategoriesEvent({required this.limit});
  @override
  List<Object> get props => [limit];
}



