class BaseProviderModel<T> {
  ViewStatus viewStatus;
  Exception? errMessage;
  String? message;
  T? data;
  String? statusCode;

  BaseProviderModel({
    this.errMessage,
    this.message,
    this.data,
    this.viewStatus = ViewStatus.none,
    this.statusCode,
  });

  factory BaseProviderModel.success(T? data) {
    return BaseProviderModel(data: data, viewStatus: ViewStatus.succeed);
  }

  factory BaseProviderModel.fail(Exception err) {
    return BaseProviderModel(errMessage: err, viewStatus: ViewStatus.failed);
  }

  factory BaseProviderModel.loading() {
    return BaseProviderModel(viewStatus: ViewStatus.loading);
  }

  factory BaseProviderModel.init({T? data}) {
    return BaseProviderModel(data: data);
  }
}

enum ViewStatus { loading, succeed, none, failed }
