import 'package:bke/data/models/book/book_info.dart';
import '../../data/repositories/book_repository.dart';
import '../../data/repositories/video_repository.dart';
import '../../data/repositories/vocab_repository.dart';
import '../../utils/log_util.dart';
import 'action_state.dart';
import 'action_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class ActionBloc extends Bloc<ActionEvent, ActionState>{
  final _bookRepos = BookRepository.instance();
  final _videoRepos = VideoRepository.instance();
  final _vocabRepos = VocabRepository.instance();


  ActionBloc() : super(ActionLoadingState()){

    on<GetRecentActionsEvent>(_onGetActions);
   
  }

  void _onGetActions(GetRecentActionsEvent event, Emitter<ActionState> emit) async{
      emit(ActionLoadingState());
      try{
        var book = await _bookRepos.getLatest();
        var video = await _videoRepos.getLatest();

        emit(ActionLoadedState(book: book.data, video: video));
      }
      catch(e){
        emit(ActionErrorState(e.toString()));
      }
  }
}
