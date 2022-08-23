class RecipeDatabaseModel {
  static const String fieldId = 'id';
  static const String fieldName = 'name';
  static const String fieldThumbnailUrl = 'thumbnail_url';
  static const String fieldDescription = 'description';

  final int id;
  final String name;
  final String thumbnailUrl;
  final String description;

  RecipeDatabaseModel({
    required this.id,
    required this.name,
    required this.thumbnailUrl,
    required this.description,
  });

  RecipeDatabaseModel.fromMap(Map<String, dynamic> map)
      : id = map[fieldId] as int,
        name = map[fieldName] as String,
        thumbnailUrl = map[fieldThumbnailUrl] as String,
        description = map[fieldDescription] as String;

  Map<String, dynamic> toMap() => {
        fieldId: id,
        fieldName: name,
        fieldThumbnailUrl: thumbnailUrl,
        fieldDescription: description,
      };
}
