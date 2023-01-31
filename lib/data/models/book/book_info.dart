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

  BookInfos.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      for (var e in (json['data'] as List)) {
        list.add(BookInfo.fromJson(e));
      }
    }
    // metadata = MetaDataModel.fromJson(json['meta_data']);
  }
}

class BookInfo {
  BookInfo({
    required this.bookId,
    required this.title,
    required this.author,
    required this.coverUrl,
    required this.description,
    required this.level,
    required this.genre,
    required this.totalWords,
    required this.length,
    required this.mp3Url,
    this.isLiked,
    this.mode
  });

  late final String bookId;
  late final String title;
  late final String author;
  late final String coverUrl;
  late final String description;
  late final String level;
  late final String genre;
  late final String totalWords;
  late final String length;
  late final String mp3Url;

  late final bool? isLiked;
  late final int? mode; //to go to Info page, Read page or Listen page?

  BookInfo.fromJson(Map<String, dynamic> json) {
    bookId = json["bookId"];
    title = json["title"];
    author = json["author"];
    coverUrl = json["coverUrl"];
    description = json["description"];
    level = json["level"];
    genre = json["genre"];
    totalWords = json["totalWords"];
    length = json["length"];
    mp3Url = json["mp3Url"];
    isLiked = json["isLiked"];
    mode = json["mode"];
  }
}
