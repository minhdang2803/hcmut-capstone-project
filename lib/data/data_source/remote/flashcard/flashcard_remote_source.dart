import 'package:bke/data/configs/endpoint.dart';
import 'package:bke/data/models/flashcard/flashcard_collection_model.dart';
import 'package:bke/data/models/network/api_service_request.dart';
import 'package:bke/data/models/network/base_response.dart';
import 'package:bke/data/models/network/cvn_exception.dart';
import 'package:bke/data/services/api_service.dart';
import 'package:bke/utils/log_util.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../configs/hive_config.dart';

abstract class FlashcardRemoteSource {
  Future<BaseResponse<FlashcardCollectionResponseModel>>
      getAllFlashcardCollection();
  Future<BaseResponse> updateToServer(List<Map<String, dynamic>> data);
  Future<BaseResponse<FlashcardCollectionFromServer>>
      getRandomCollectionThumbnail();
  Future<BaseResponse<FlashcardCollectionRandomModel>> getRandomCollectionByCategory(
      String category);
}

class FlashcardRemoteSourceImpl implements FlashcardRemoteSource {
  final APIService _api = APIService.instance();
  @override
  Future<BaseResponse<FlashcardCollectionResponseModel>>
      getAllFlashcardCollection() async {
    try {
      const String path = EndPoint.getAllFlashcard;
      final token = await const FlutterSecureStorage()
          .read(key: HiveConfig.currentUserTokenKey);
      final header = {'Authorization': 'Bearer $token'};
      final request = APIServiceRequest(
        path,
        header: header,
        (response) => BaseResponse<FlashcardCollectionResponseModel>.fromJson(
            json: response,
            dataBuilder: FlashcardCollectionResponseModel.fromJson),
      );
      return _api.get(request);
    } on RemoteException catch (error) {
      throw RemoteException(RemoteException.responseError, error.errorMessage);
    }
  }

  @override
  Future<BaseResponse> updateToServer(List<Map<String, dynamic>> data) async {
    try {
      const String path = EndPoint.updateFlashcard;
      final token = await const FlutterSecureStorage()
          .read(key: HiveConfig.currentUserTokenKey);
      final header = {'Authorization': 'Bearer $token'};
      final bodyRequest = {'data': data};
      final request = APIServiceRequest(
        path,
        header: header,
        dataBody: bodyRequest,
        (response) => BaseResponse.fromJson(json: response, dataBuilder: null),
      );
      LogUtil.debug('Update Flashcard Collections as JSON: $path $data');
      return _api.post(request);
    } on RemoteException catch (error) {
      throw RemoteException(RemoteException.responseError, error.errorMessage);
    }
  }

  @override
  Future<BaseResponse<FlashcardCollectionFromServer>>
      getRandomCollectionThumbnail() async {
    try {
      const String path = EndPoint.flashcardRandomGetAllThumbnail;
      final token = await const FlutterSecureStorage()
          .read(key: HiveConfig.currentUserTokenKey);
      final header = {'Authorization': 'Bearer $token'};
      final request = APIServiceRequest(
        path,
        header: header,
        (response) => BaseResponse<FlashcardCollectionFromServer>.fromJson(
            json: response,
            dataBuilder: FlashcardCollectionFromServer.fromJson),
      );
      return _api.get(request);
    } on RemoteException catch (error) {
      throw RemoteException(RemoteException.responseError, error.errorMessage);
    }
  }

  @override
  Future<BaseResponse<FlashcardCollectionRandomModel>> getRandomCollectionByCategory(
      String category) async {
    try {
      const String path = EndPoint.flashcardRandomGetAll;
      final token = await const FlutterSecureStorage()
          .read(key: HiveConfig.currentUserTokenKey);
      final header = {'Authorization': 'Bearer $token'};
      final params = {'category': category};
      final request = APIServiceRequest(
        path,
        header: header,
        queryParams: params,
        (response) => BaseResponse<FlashcardCollectionRandomModel>.fromJson(
            json: response,
            dataBuilder: FlashcardCollectionRandomModel.fromJson),
      );
      return _api.get(request);
    } on RemoteException catch (error) {
      throw RemoteException(RemoteException.responseError, error.errorMessage);
    }
  }
}


// const path = EndPoint.getVocabInfos;
//     final token = await const FlutterSecureStorage()
//         .read(key: HiveConfig.currentUserTokenKey);
//     final header = {'Authorization': 'Bearer $token'};
//     final params = {'vocab': vocab};

//     final getVocabInfos = APIServiceRequest(
//       path,
//       header: header,
//       queryParams: params,
//       (response) => BaseResponse<VocabInfos>.fromJson(
//           json: response, dataBuilder: VocabInfos.fromJson),
//     );
//     LogUtil.debug('get vocab infos: $path ${params}');
//     return _api.get(getVocabInfos);