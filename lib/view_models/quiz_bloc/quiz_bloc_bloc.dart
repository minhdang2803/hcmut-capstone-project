import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'quiz_bloc_event.dart';
part 'quiz_bloc_state.dart';

class QuizBlocBloc extends Bloc<QuizBlocEvent, QuizBlocState> {
  QuizBlocBloc() : super(QuizBlocInitial()) {
    on<QuizBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
