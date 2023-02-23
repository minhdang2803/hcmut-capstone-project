import 'package:bke/utils/log_util.dart';
import 'package:dio/dio.dart';

import '../../utils/connection_util.dart';
import '../models/network/api_service_request.dart';
import '../models/network/cvn_exception.dart';

class APIService {
  late final Dio _dio;

  APIService._internal() {
    final options = BaseOptions(
      receiveDataWhenStatusError: true,
      connectTimeout: 15000,
      receiveTimeout: 15000,
    );
    _dio = Dio(options);
  }

  static final APIService _instance = APIService._internal();

  factory APIService.instance() => _instance;

  /// HTTP GET
  Future<T> get<T>(APIServiceRequest<T> request) async {
    final hasInternet = await ConnectionUtil.hasInternetConnection();
    if (!hasInternet) {
      throw RemoteException(
          RemoteException.noInternet, 'No internet connection');
    }
    try {
      final headerOption = Options(headers: request.header);
      final response = await _dio.get(
        request.path,
        options: headerOption,
        queryParameters: request.queryParams,
      );
      return request.parseResponse(response.data);
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
          throw RemoteException(
              RemoteException.connectTimeout, 'Connection timeout');
        case DioErrorType.sendTimeout:
          throw RemoteException(RemoteException.sendTimeout, 'Send timeout');
        case DioErrorType.receiveTimeout:
          throw RemoteException(
              RemoteException.receiveTimeout, 'Receive timeout');
        case DioErrorType.response:
          throw RemoteException(
            RemoteException.responseError,
            '${e.response?.data?['error'] ?? ''}',
            httpStatusCode: e.response?.statusCode,
          );
        case DioErrorType.cancel:
          throw RemoteException(
              RemoteException.cancelRequest, 'Request cancel');
        case DioErrorType.other:
          throw RemoteException(
              RemoteException.other, 'Dio error unknown: ${e.error}');
      }
    } catch (e) {
      throw RemoteException(RemoteException.other, e.toString());
    }
  }

  /// HTTP POST
  Future<T> post<T>(APIServiceRequest<T> request, {bool isDelete = false}) async {
    final hasInternet = await ConnectionUtil.hasInternetConnection();
    if (!hasInternet) {
      throw RemoteException(
          RemoteException.noInternet, 'No internet connection');
    }
    try {
      final headerOption = Options(headers: request.header);
      final response = !isDelete? await _dio.post(
                                    request.path,
                                    options: headerOption,
                                    data: request.dataBody,
                                    queryParameters: request.queryParams,
                                  )
                                : await _dio.delete(
                                    request.path,
                                    options: headerOption,
                                    data: request.dataBody,
                                    queryParameters: request.queryParams,
                                  );
      return request.parseResponse(response.data);
    } on DioError catch (e) {
      switch (e.type) {
        case DioErrorType.connectTimeout:
          throw RemoteException(
              RemoteException.connectTimeout, 'Connection timeout');
        case DioErrorType.sendTimeout:
          throw RemoteException(RemoteException.sendTimeout, 'Send timeout');
        case DioErrorType.receiveTimeout:
          throw RemoteException(
              RemoteException.receiveTimeout, 'Receive timeout');
        case DioErrorType.response:
          throw RemoteException(
            RemoteException.responseError,
            '${e.response?.data?['error'] ?? ''}',
            httpStatusCode: e.response?.statusCode,
          );
        case DioErrorType.cancel:
          throw RemoteException(
              RemoteException.cancelRequest, 'Request cancel');
        case DioErrorType.other:
          throw RemoteException(
              RemoteException.other, 'Dio error unknown: ${e.error}');
      }
    } catch (e) {
      throw RemoteException(RemoteException.other, e.toString());
    }
  }
}
