class LoginException implements Exception {
  final int statusCode;
  final String? message;
  const LoginException({required this.statusCode, this.message});
  @override
  String toString() =>
      'LoginException: statusCode: $statusCode, message: ${message ?? 'No message specified'}';
}

abstract class BKExption implements Exception {
  final int code;
  final String message;

  BKExption(this.code, this.message);
}

class RemoteException extends BKExption {
  static const other = -1;
  static const receiveTimeout = 0;
  static const connectTimeout = 1;
  static const sendTimeout = 2;
  static const responseError = 3;
  static const cancelRequest = 4;
  static const socketError = 5;
  static const noInternet = 6;
  static const downloadError = 7;

  final int errorCode;
  final int? httpStatusCode;
  final String errorMessage;

  RemoteException(this.errorCode, this.errorMessage, {this.httpStatusCode})
      : super(errorCode, errorMessage);
}

class LocalException extends BKExption {
  static const other = -1;
  static const emptyUser = 0;
  static const unableSaveUser = 1;

  final int errorCode;
  final String errorMessage;

  LocalException(this.errorCode, this.errorMessage)
      : super(errorCode, errorMessage);
}
