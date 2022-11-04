import 'package:bke/data/models/book/book_info.dart';
import 'package:bke/data/models/book/book_reader.dart';
import 'package:bke/data/models/book/book_listener.dart';
import '../../../../utils/constants.dart';
import 'example_data.dart';

abstract class BookSource {
   Future<List<BookInfo>> getAll();
   Future<List<BookInfo>> getByCategory(String category);

   Future<BookInfo> getBookInfo(String bookId);
   Future<BookReader> getEbook(String bookId, int pageKey);
   Future<BookListener> getAudioBook(String bookId);
  //  void updateCkpt(String bookId, int ckpt);
}

class BookSourceImpl extends BookSource {
  @override
  Future<List<BookInfo>> getAll() async{
    return data.map((e)=>BookInfo.fromJson(e)).toList(); //return 20 most popular books of each category, for all categories
  }

  @override
  Future<List<BookInfo>> getByCategory(String category) async{
    return data.map((e)=>BookInfo.fromJson(e)).toList(); //return all books belong to a category
  }

  @override
  Future<BookInfo> getBookInfo(String bookId) async {
    final data = await getAll();
    return data.where((e) => (e.bookId == bookId)).toList()[0]; //return info of book bookId
  }

  @override
  Future<BookReader> getEbook(String bookId, int pageKey) async {
    final rData = ebookData.map((e)=>BookReader.fromJson(e)).toList();
    final List<BookReader> matches = rData.where((e) => (e.bookId == bookId)).toList();//return ebook that contains list of sentences, isLiked and page checkpoint
    assert(matches[0].bookId == bookId);
    final BookReader partialData = BookReader(bookId: bookId, 
                                  sentences: pageKey*Constants.defaultReadingPageSize < matches[0].sentences.length
                                            ? 
                                            matches[0].sentences
                                                      .sublist((pageKey-1)*Constants.defaultReadingPageSize, pageKey*Constants.defaultReadingPageSize)
                                            :matches[0].sentences
                                                      .sublist((pageKey-1)*Constants.defaultReadingPageSize),
                                  ckpt: matches[0].ckpt);
    return partialData;
  }


  @override
  Future<BookListener> getAudioBook(String bookId) async {
    final lData = audioBookData.map((e)=>BookListener.fromJson(e)).toList();
    final List<BookListener> matches = lData.where((e) => (e.bookId == bookId)).toList();
    assert(matches[0].bookId == bookId);
    return matches[0]; 
  }

  // void updateCkpt(String bookId, int page) async{

  // }


}