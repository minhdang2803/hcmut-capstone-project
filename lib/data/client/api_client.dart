import 'package:capstone_project_hcmut/data/network/recipe_entity.dart';
import 'package:dio/dio.dart';

class KoException implements Exception {
  final int statusCode;
  final String? message;
  const KoException({required this.statusCode, this.message});
  @override
  String toString() =>
      'KoException: statusCode: $statusCode, message: ${message ?? 'No message specified'}';
}

class ApiClient {
  final String baseUrl;
  final String apiKey;
  ApiClient({required this.baseUrl, required this.apiKey});
  Future<RecipeListNetwork> getRecipes() async {
    try {
      final response = await Dio().get(
        'https://$baseUrl/recipes/list',
        queryParameters: {'from': 0, 'size': 20},
        options: Options(
            headers: {'x-RapidAPI-Host': baseUrl, 'x-RapidAPI-Key': apiKey}),
      );
      if (response != null) {
        final data = response.data;
        return RecipeListNetwork.fromJson(
            response.data as Map<String, dynamic>);
      } else {
        throw Exception('Could not parse response');
      }
    } on DioError catch (e) {
      if (e.response != null && e.response!.statusCode != null) {
        throw KoException(
          statusCode: e.response!.statusCode!,
          message: e.response!.data.toString(),
        );
      } else {
        throw Exception(e.message);
      }
    }
  }
}
