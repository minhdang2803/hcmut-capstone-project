part of 'quiz_bloc_bloc.dart';

abstract class QuizBlocState extends Equatable {
  const QuizBlocState();
  
  @override
  List<Object> get props => [];
}

class QuizBlocInitial extends QuizBlocState {}
