import 'package:equatable/equatable.dart';
import '../../data/models/book/book_info.dart';

abstract class BookListEvent extends Equatable{
  const BookListEvent();
}

abstract class BookEvent extends Equatable{
  const BookEvent();
}


class LoadAllEvent extends BookListEvent{
  @override
  List<Object> get props => [];
}

class LoadByCategoryEvent extends BookListEvent{
  final String category;
  const LoadByCategoryEvent({required this.category});
  @override
  List<Object> get props => [category];
}

class LoadDetailsEvent extends BookEvent{
  final String bookId;
  const LoadDetailsEvent({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}


class LoadEbookEvent extends BookEvent{
  final String bookId;
  final int pageKey;
  const LoadEbookEvent({required this.bookId, required this.pageKey});

  @override
  List<Object?> get props => [bookId, pageKey];
}

class LoadAudioBookEvent extends BookEvent{
  final String bookId;
  const LoadAudioBookEvent({required this.bookId});

  @override
  List<Object?> get props => [bookId];
}

// class UpdateCkptEvent extends BookEvent{
//   final String bookId;
//   final int ckpt;
//   const UpdateCkptEvent({required this.bookId, required this.ckpt});

//   @override
//   List<Object?> get props => [bookId, ckpt];
// }

