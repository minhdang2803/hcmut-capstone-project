class ToeicP1QandA {
  ToeicP1QandA({
    required int qid,
    required String pngURL,
    required String mp3URL,
  });

  late final int qid;
  late final String pngURL;
  late final String mp3URL;

  ToeicP1QandA.fromJson(Map<String, dynamic> json) {
    qid = json["qid"];
    pngURL = json["pngURL"];
    mp3URL = json["mp3URL"];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["qid"] = qid;
    map["pngURL"] = pngURL;
    map["mp3URL"] = mp3URL;
    return map;
  }
}
