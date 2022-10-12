class SubVideo {
  SubVideo({required this.videoId, required this.subs});

  late final String videoId;
  late final List<Subs> subs;

  SubVideo.fromJson(Map<String, dynamic> json) {
    videoId = json["videoId"];
    subs = (json["subs"] as List).map((i) => Subs.fromJson(i)).toList();
  }
}

class Subs {
  Subs({required this.from, required this.to, required this.text});

  late final int index;
  late final int from;
  late final int to;
  late final String text;

  Subs.fromJson(Map<String, dynamic> json) {
    index = json["index"];
    from = json["from"];
    to = json["to"];
    text = json["text"];
  }
}
