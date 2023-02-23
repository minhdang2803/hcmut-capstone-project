import 'package:bke/bloc/book/book_event.dart';
import 'package:bke/data/data_source/remote/book/book_source.dart';
import 'package:bke/data/data_source/remote/book/example_data.dart';
import 'package:bke/data/models/book/book_listener.dart';
import 'package:bke/data/models/book/book_reader.dart';
import 'package:bke/data/models/network/base_response.dart';
import 'package:bke/utils/log_util.dart';
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
  
  Future<BaseResponse<BookInfosV2>> getAll() async{
    final res = await _bookSource.getAll();
    return res;
  }

  Future<BaseResponse<BookInfos>> getByCategory(String category) async {
    return await _bookSource.getByCategory(category);
  }

  Future<BaseResponse<BookInfos>> getFavorites() async {
    final res = await _bookSource.getFavorites();
    return res;
  }

  Future<BaseResponse<BookInfos>> getContinueReading() async {
    return await _bookSource.getContinueReading();
  }

  Future<BaseResponse<BookInfos>> getContinueListening() async {
    return await _bookSource.getContinueListening();
  }

  Future<BaseResponse<BookInfo>> getBookInfo(String bookId) async {
    return await _bookSource.getBookInfo(bookId);
  }

  Future<BaseResponse<BookReader>> getEbook(String bookId, int pageKey) async {
    return await _bookSource.getEbook(bookId, pageKey);
  }

  Future<BaseResponse<BookListener>> getAudioBook(String bookId) async {
    return await _bookSource.getAudioBook(bookId);
  }

  Future<BaseResponse> updateCkpt(String bookId, int ckpt, bool isEbook) async{
    return await _bookSource.updateCkpt(bookId, ckpt, isEbook);
  }

  Future<BaseResponse> addFavorite(String bookId) async{
    return await _bookSource.addFavorite(bookId);
  }

  Future<BaseResponse> removeFavorite(String bookId) async{
    return await _bookSource.removeFavorite(bookId);
  }

  
 
}

