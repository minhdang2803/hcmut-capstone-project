import '../meta_data.dart';

class VideoYoutubeInfos {
  VideoYoutubeInfos({required this.list, this.metadata});

  List<VideoYoutubeInfo> list = [];
  late final MetaDataModel? metadata;

  VideoYoutubeInfos.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      for (var e in (json['data'] as List)) {
        list.add(VideoYoutubeInfo.fromJson(e));
      }
    }
    if (json['meta_data'] != null) {
      metadata = MetaDataModel.fromJson(json['meta_data']);
    }
  }
}

class VideoYoutubeInfo {
  VideoYoutubeInfo({
    this.id,
    required this.videoId,
    required this.title,
    this.description,
    required this.thumbUrl,
    this.playlistId,
    this.length,
    this.viewCount,
    this.level,
    this.category,
    this.isVerify,
    this.adminVerify,
    this.checkpoint,
  });

  late final String? id;
  late final String videoId;
  late final String title;
  late final String? description;
  late final String thumbUrl;
  late final String? playlistId;
  late final String? length;
  late final String? viewCount;
  late final int? level;
  late final String? category;
  late final bool? isVerify;
  late final String? adminVerify;
  late final int? checkpoint;

  factory VideoYoutubeInfo.fromJson(Map<String, dynamic> json) {
    if (json["videoYoutubeInfo"] != null) {
      final Map<String, dynamic> data = json["videoYoutubeInfo"]!;
      return VideoYoutubeInfo(
        id: data["_id"],
        videoId: data['videoId'],
        title: data['title'],
        description: data['description'],
        thumbUrl: data['thumbUrl'],
        playlistId: data['playlistId'],
        length: data['length'],
        viewCount: data['viewCount'],
        level: data['level'],
        category: data['category'],
        isVerify: data['isVerify'],
        adminVerify: data['adminVerify'],
        checkpoint: data['checkpoint'],
      );
    } else {
      return VideoYoutubeInfo(
        id: json["_id"],
        videoId: json['videoId'],
        title: json['title'],
        description: json['description'],
        thumbUrl: json['thumbUrl'],
        playlistId: json['playlistId'],
        length: json['length'],
        viewCount: json['viewCount'],
        level: json['level'],
        category: json['category'],
        isVerify: json['isVerify'],
        adminVerify: json['adminVerify'],
        checkpoint: json['checkpoint'],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "videoId": videoId,
      "title": title,
      "description": description,
      "thumbUrl": thumbUrl,
      "playlistId": playlistId,
      "length": length,
      "viewCount": viewCount,
      "level": level,
      "category": category,
      "isVerify": isVerify,
      "adminVerify": adminVerify,
      "checkpoint": checkpoint
    };
  }
}

class RecommendedVideos {
  RecommendedVideos({required this.category, required this.list});

  String category = ''; 
  List<VideoYoutubeInfo> list = [];

  RecommendedVideos.fromJson(Map<String, dynamic> json) {
    if (json['category'] != null){
      category = json['category'];
    }
    if (json['list'] != null) {
      for (var e in (json['list'] as List)) {
        list.add(VideoYoutubeInfo.fromJson(e));
      }
    }
    // metadata = MetaDataModel.fromJson(json['meta_data']);
  }
}
