class ToeicP1QandA {
  ToeicP1QandA({
    required int qid,
    required String imgURL,
    required String mp3URL,
    required String mp3URLPro,
    required List<String> transcript,
    required String answer,
  });

  late final int qid;
  late final String imgURL;
  late final String mp3URL;
  late final String mp3URLPro;
  late final List<String> transcript;
  late final String answer;

  ToeicP1QandA.fromJson(Map<String, dynamic> json) {
    qid = json["qid"];
    imgURL = json["imgURL"];
    mp3URL = json["mp3URL"];
    mp3URLPro = json["mp3URLPro"];
    transcript = json["transcript"].cast<String>();
    answer = json["answer"];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map["qid"] = qid;
    map["imgURL"] = imgURL;
    map["mp3URL"] = mp3URL;
    map["mp3URLPro"] = mp3URLPro;
    map["transcript"] = transcript;
    map["answer"] = answer;
    return map;
  }
}
