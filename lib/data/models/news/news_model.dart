// import '../meta_data.dart';

import '../meta_data.dart';

class NewsInfos {
  NewsInfos({required this.list});

  List<NewsInfo> list = [];
  late final MetaDataModel metadata;

  NewsInfos.fromJson(Map<String, dynamic> json) {

    
    for (var e in (json['data'] as List)) {
      list.add(NewsInfo.fromJson(e));
    }
    
    metadata = MetaDataModel.fromJson(json['meta_data']);
  }
}


class NewsInfo {
  NewsInfo({
  required this.id,
  required this.source,
  required this.author,
  required this.title,
  required this.url,
  required this.urlToImage,
  required this.content,
  required this.isTopHeadline,
  required this.category,
  required this.publishedAt,
  });

  late final String id;
  late final String source;
  late final String author;
  late final String title;
  late final String url;
  late final String urlToImage;
  late final String content;
  late final bool isTopHeadline;
  late final String category;
  late final String publishedAt;

  NewsInfo.fromJson(Map<String, dynamic> json) {
    id = json["_id"];
    source = json["source"]["name"]??'';
    title = json["title"];
    author = json["author"]??'';
    url = json["url"]??'';
    urlToImage = json["urlToImage"]??'';
    content = json["content"];
    isTopHeadline = json["isTopHeadline"];
    category = json["category"]??'';
    publishedAt = json["publishedAt"];
  }
}


