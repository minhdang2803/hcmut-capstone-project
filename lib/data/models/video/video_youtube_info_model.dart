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
    if (json['meta_data'] != null){
      metadata = MetaDataModel.fromJson(json['meta_data']);
    }
  }
}

class VideoYoutubeInfo {
  VideoYoutubeInfo({
    required this.id,
    required this.videoId,
    required this.title,
    required this.description,
    required this.thumbUrl,
    required this.playlistId,
    required this.length,
    required this.viewCount,
    required this.level,
    required this.category,
    required this.isVerify,
    required this.adminVerify,
    this.checkpoint
  });

  late final String id;
  late final String videoId;
  late final String title;
  late final String description;
  late final String thumbUrl;
  late final String playlistId;
  late final String length;
  late final String viewCount;
  late final int level;
  late final String category;
  late final bool isVerify;
  late final String adminVerify;
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
        checkpoint: data['checkpoint']
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
          checkpoint: json['checkpoint']
      );
    }
  }
}
