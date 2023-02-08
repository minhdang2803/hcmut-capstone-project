import 'package:bke/data/models/book/book_info.dart';
import 'package:bke/data/models/book/book_reader.dart';
import 'package:bke/data/models/book/book_listener.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../utils/constants.dart';
import 'example_data.dart';

import '../../../configs/endpoint.dart';
import '../../../configs/hive_config.dart';
import '../../../models/network/api_service_request.dart';
import '../../../models/network/base_response.dart';
import '../../../models/video/sub_video.dart';
import '../../../models/video/video_youtube_info.dart';
import '../../../services/api_service.dart';

abstract class BookSource {
   Future<BaseResponse<BookInfosV2>> getAll();
   Future<BaseResponse<BookInfos>> getByCategory(String category);

   Future<BaseResponse<BookInfo>> getBookInfo(String bookId);
   Future<BaseResponse<BookReader>> getEbook(String bookId, int pageKey);
   Future<BookListener> getAudioBook(String bookId);
  //  void updateCkpt(String bookId, int ckpt);
}

class BookSourceImpl extends BookSource {
  final APIService _api = APIService.instance();


  @override
  Future<BaseResponse<BookInfosV2>> getAll() async{
    const path = EndPoint.getHomepageList;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};

    final request = APIServiceRequest(
      path,
      (response) => BaseResponse<BookInfosV2>.fromJson(
        json: response,
        dataBuilder: BookInfosV2.fromJson,
      ),
      header: header,
    );
    return _api.get(request);//return 5 most popular books of each category, for 5 categories
  }

  @override
  Future<BaseResponse<BookInfos>> getByCategory(String category) async{
   
    const path = EndPoint.getAllBooks;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final Map<String, dynamic> params = {
      'genre': category,
      'page': 1,
    };

    final request = APIServiceRequest(
      path,
      queryParams: params,
      (response) => BaseResponse<BookInfos>.fromJson(
        json: response,
        dataBuilder: BookInfos.fromJson,
      ),
      header: header,
    );
    return _api.get(request);
    // return data.map((e)=>BookInfo.fromJson(e)).toList(); //return all books belong to a category
  }

  @override
  Future<BaseResponse<BookInfo>> getBookInfo(String bookId) async {
    const path = EndPoint.getBookInfo;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final params = {'bookId': bookId};

    final request = APIServiceRequest(
      path,
      header: header,
      queryParams: params,
      (response) => BaseResponse<BookInfo>.fromJson(
          json: response, dataBuilder: BookInfo.fromJson),
    );

    return _api.get(request);
    // final data = await getAll();
    // return data.where((e) => (e.bookId == bookId)).toList()[0]; //return info of book bookId
  }

  @override
  Future<BaseResponse<BookReader>> getEbook(String bookId, int pageKey) async {
    const path = EndPoint.getEbook;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final Map<String, dynamic> params = {
      'bookId': bookId,
      'limit': Constants.defaultReadingPageSize,
      'page': pageKey
    }; //1 page returns 200 sentences

    final request = APIServiceRequest(
      path,
      queryParams: params,
      (response) => BaseResponse<BookReader>.fromJson(
        json: response,
        dataBuilder: BookReader.fromJson,
      ),
      header: header,
    );
  
    return _api.get(request);
  
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