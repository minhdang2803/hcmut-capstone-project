import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'flashcard_state.dart';

class FlashcardCubit extends Cubit<FlashcardState> {
  FlashcardCubit() : super(FlashcardInitial());
}
