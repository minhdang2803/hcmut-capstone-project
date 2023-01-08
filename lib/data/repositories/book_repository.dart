import 'package:bke/data/data_source/remote/book/book_source.dart';
import 'package:bke/data/models/book/book_listener.dart';
import 'package:bke/data/models/book/book_reader.dart';
import '../models/book/book_info.dart';

class BookRepository{
  late final BookSource _bookSource;
  // late final BookLocalSource _bookLocalSource;

  BookRepository._internal() {
    _bookSource = BookSourceImpl();
    // _bookLocalSource = BookLocalSourceImpl();
  }
  static final _instance = BookRepository._internal();

  factory BookRepository.instance() => _instance;
  
  Future<List<BookInfo>> getAll() async{
    return await _bookSource.getAll();
  }

  Future<List<BookInfo>> getByCategory(String category) async {
    return await _bookSource.getByCategory(category);
  }

  Future<BookInfo> getBookInfo(String bookId) async {
    return await _bookSource.getBookInfo(bookId);
  }

  Future<BookReader> getEbook(String bookId, int pageKey) async {
    return await _bookSource.getEbook(bookId, pageKey);
  }

  Future<BookListener> getAudioBook(String bookId) async {
    return await _bookSource.getAudioBook(bookId);
  }

  // void updateCkpt(String bookId, int ckpt) async{
  //   await _bookSource.updateCkpt(bookId, ckpt);
  // }

  
 
}
