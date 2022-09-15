part of 'quiz_bloc_bloc.dart';

abstract class QuizBlocEvent extends Equatable {
  const QuizBlocEvent();

  @override
  List<Object> get props => [];
}

class LoadingState extends QuizBlocEvent{
  
}