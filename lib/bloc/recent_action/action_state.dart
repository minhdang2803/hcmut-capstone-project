import 'package:bke/data/models/book/book_listener.dart';
import 'package:bke/data/models/book/book_reader.dart';
import 'package:bke/data/models/vocab/vocab.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/book/book_info.dart';
import '../../data/models/video/video_youtube_info_model.dart';

abstract class ActionState extends Equatable{}

class ActionLoadingState extends ActionState{
  ActionLoadingState();

  @override
  List<Object?> get props => [];
}

class ActionLoadedState extends ActionState{
  ActionLoadedState({this.book, this.video, this.words});
  final BookInfo? book;
  final VideoYoutubeInfo? video;
  final VocabInfos? words;

  @override
  List<Object?> get props => [book, video, words];
}


class ActionErrorState extends ActionState{
  ActionErrorState(this.e);
  final String e;
  @override
  List<Object?> get props => [e];
}


