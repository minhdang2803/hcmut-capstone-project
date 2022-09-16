import 'package:equatable/equatable.dart';
import '../../models/book_model.dart';

abstract class BookEvent extends Equatable{
  const BookEvent();
}

abstract class DetailsEvent extends Equatable{
  const DetailsEvent();
}


class LoadBookEvent extends BookEvent{
  @override
  List<Object> get props => [];
}

class LoadDetailsEvent extends DetailsEvent{
  final BookModel book;
  const LoadDetailsEvent({required this.book});
  
  @override
  List<Object?> get props => [book];
}

