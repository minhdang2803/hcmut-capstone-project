import 'package:json_annotation/json_annotation.dart';

part 'recipe_entity.g.dart';

@JsonSerializable()
class RecipeListNetwork {
  final int count;
  final List<RecipeNetwork> results;

  RecipeListNetwork({required this.count, required this.results});
  factory RecipeListNetwork.fromJson(Map<String, dynamic> json) =>
      _$RecipeListResponseFromJson(json);
}

@JsonSerializable()
class RecipeNetwork {
  final int id;
  final String name;
  @JsonKey(name: 'thumbnail_url')
  final String thumbnailUrl;
  final String description;

  RecipeNetwork({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.description,
  });

  factory RecipeNetwork.fromJson(Map<String, dynamic> json) =>
      _$RecipeEntityFromJson(json);
}
