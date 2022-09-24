class BaseResponse<T> {
  int status;
  String message;
  T? data;

  BaseResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory BaseResponse.fromJson({
    required Map<String, dynamic> json,
    Function(Map<String, dynamic>)? dataBuilder,
  }) {
    return BaseResponse<T>(
      status: json['statusCode'],
      message: json['message'],
      data: dataBuilder != null ? dataBuilder(json['data']) : null,
    );
  }
}
