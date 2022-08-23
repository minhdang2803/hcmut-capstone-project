class LoginException implements Exception {
  final int statusCode;
  final String? message;
  const LoginException({required this.statusCode, this.message});
  @override
  String toString() =>
      'LoginException: statusCode: $statusCode, message: ${message ?? 'No message specified'}';
}
