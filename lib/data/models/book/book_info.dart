// import '../meta_data.dart';
enum Mode { 
   start, 
   reading,
   listening
} 
class BookInfos {
  BookInfos({required this.list});

  List<BookInfo> list = [];
  // late final MetaDataModel metadata;

  BookInfos.fromJson(json) {

    if (json['data'] != null) {
      for (var e in (json['data'] as List)) {
        list.add(BookInfo.fromJson(e));
      }
    }
    // metadata = MetaDataModel.fromJson(json['meta_data']);
  }
}

class BookInfosV2 {
  BookInfosV2({required this.list});

  List<BookInfoV2> list = [];
  // late final MetaDataModel metadata;

  BookInfosV2.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      for (var e in (json['data'] as List)) {
        list.add(BookInfoV2.fromJson(e));
      }
    }
    // metadata = MetaDataModel.fromJson(json['meta_data']);
  }
}


class BookInfo {
  BookInfo({
    required this.bookId,
    required this.id,
    required this.title,
    this.author,
    required this.coverUrl,
    this.description,
    this.level,
    this.genre,
    this.totalWords,
    this.length,
    this.mp3Url,
    this.checkpoint,
    this.isLiked,
  });

  late final String bookId;
  late final String id;
  late final String title;
  late final String? author;
  late final String coverUrl;
  late final String? description;
  late final String? level;
  late final String? genre;
  late final String? totalWords;
  late final String? length;
  late final String? mp3Url;
  late final int? checkpoint;
  late final bool? isLiked;

  BookInfo.fromJson(Map<String, dynamic> json) {
    bookId = json["bookId"];
    id = json["_id"];
    title = json["title"];
    author = json["author"];
    coverUrl = json["coverUrl"];
    description = json["description"];
    level = json["level"];
    genre = json["genre"];
    totalWords = json["totalWords"];
    length = json["length"];
    mp3Url = json["mp3Url"];
    checkpoint = json["checkpoint"];
    isLiked = json["isLiked"];
    // mode = json["mode"];
  }
}

class BookInfoV2 {
  BookInfoV2({required this.category, required this.list});

  late final String category; 
  List<BookInfo> list = [];

  BookInfoV2.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    if (json['list'] != null) {
      for (var e in (json['list'] as List)) {
        list.add(BookInfo.fromJson(e));
      }
    }
    // metadata = MetaDataModel.fromJson(json['meta_data']);
  }
}




