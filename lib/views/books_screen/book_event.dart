import 'package:equatable/equatable.dart';
// import '../../models/book_model.dart';

abstract class BookEvent extends Equatable{
  const BookEvent();
}


class LoadBookEvent extends BookEvent{
  @override
  List<Object> get props => [];
}

