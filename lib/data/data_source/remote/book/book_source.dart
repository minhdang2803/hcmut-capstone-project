import 'package:bke/data/models/book/book_info.dart';
import 'package:bke/data/models/book/book_reader.dart';
import 'package:bke/data/models/book/book_listener.dart';
import 'package:bke/utils/log_util.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../../utils/constants.dart';

import '../../../configs/endpoint.dart';
import '../../../configs/hive_config.dart';
import '../../../models/network/api_service_request.dart';
import '../../../models/network/base_response.dart';
import '../../../services/api_service.dart';

abstract class BookSource {
   Future<BaseResponse<BookInfosV2>> getAll();
   Future<BaseResponse<BookInfos>> getByCategory(String category);

   Future<BaseResponse<BookInfo>> getBookInfo(String bookId);
   Future<BaseResponse<BookReader>> getEbook(String bookId, int pageKey);
   Future<BaseResponse<BookListener>> getAudioBook(String bookId);
   Future<BaseResponse> updateCkpt(String bookId, int ckpt, bool isEbook);
   Future<BaseResponse> addFavorite(String bookId);
   Future<BaseResponse> removeFavorite(String bookId);
   Future<BaseResponse<BookInfos>> getContinueReading();
   Future<BaseResponse<BookInfos>> getContinueListening();
   Future<BaseResponse<BookInfos>> getFavorites();
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
      header: header,
      (response) => BaseResponse<BookInfosV2>.fromJson(
        json: response,
        dataBuilder: BookInfosV2.fromJson,
      ),
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
  Future<BaseResponse<BookInfos>> getContinueReading() async{
   
    const path = EndPoint.getContinueReading;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};

    final request = APIServiceRequest(
      path,
      (response) => BaseResponse<BookInfos>.fromJson(
        json: response,
        dataBuilder: BookInfos.fromJson,
      ),
      header: header,
    );
    return _api.get(request);
  }

    @override
  Future<BaseResponse<BookInfos>> getContinueListening() async{
   
    const path = EndPoint.getContinueListening;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};

    final request = APIServiceRequest(
      path,
      (response) => BaseResponse<BookInfos>.fromJson(
        json: response,
        dataBuilder: BookInfos.fromJson,
      ),
      header: header,
    );
    return _api.get(request);
  }

    @override
  Future<BaseResponse<BookInfos>> getFavorites() async{
   
    const path = EndPoint.getFavorites;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};

    final request = APIServiceRequest(
      path,
      (response) => BaseResponse<BookInfos>.fromJson(
        json: response,
        dataBuilder: BookInfos.fromJson,
      ),
      header: header,
    );
    
    final res =  await _api.get(request);
    return res;
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
    }; 
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
  Future<BaseResponse<BookListener>> getAudioBook(String bookId) async {
    const path = EndPoint.getAudiobook;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final params = {'bookId': bookId};

    final request = APIServiceRequest(
      path,
      header: header,
      queryParams: params,
      (response) => BaseResponse<BookListener>.fromJson(
          json: response, dataBuilder: BookListener.fromJson),
    );

    return _api.get(request);
  }

  @override
  Future<BaseResponse> updateCkpt(String bookId, int ckpt, bool isEbook) async{
    const path = EndPoint.updateCkpt;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final bodyRequest = isEbook ? {'bookId': bookId, 'checkpointPage': ckpt} : {'bookId': bookId, 'checkpointSecond': ckpt};
    final request = APIServiceRequest(
      path,
      header: header,
      dataBody: bodyRequest,
      (response) => BaseResponse.fromJson(json: response, dataBuilder: null),
    );
    LogUtil.debug('$bodyRequest');
    return _api.post(request);
  }

  @override
  Future<BaseResponse> addFavorite(String bookId) async{
    const path = EndPoint.addFavorite;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final param = {'bookId': bookId};
    final request = APIServiceRequest(
      path,
      header: header,
      queryParams: param,
      (response) => BaseResponse.fromJson(json: response, dataBuilder: null),
    );

    return _api.post(request);  
  }
  
  @override
  Future<BaseResponse> removeFavorite(String bookId) async{
    const path = EndPoint.removeFavorite;
    final token = await const FlutterSecureStorage()
        .read(key: HiveConfig.currentUserTokenKey);
    final header = {'Authorization': 'Bearer $token'};
    final param = {'bookId': bookId};
    final request = APIServiceRequest(
      path,
      header: header,
      queryParams: param,
      (response) => BaseResponse.fromJson(json: response, dataBuilder: null),
    );
 
    return _api.post(request, isDelete: true); //the actual http request used is delete, not post
    
  }
  // @override
  // Future<BaseResponse<BookListeners>> getAudioCkptList(String bookId) async {
  // }


}