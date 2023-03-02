class ToeicQuestion {
  final int? qid;
  final String? text;
  final String? imgUrl;
  final String? mp3UrlPro;
  final String? mp3Url;
  final String? transcript;
  final String? correctAnswer;
  final List<String>? answers;

  ToeicQuestion({
    this.qid,
    this.imgUrl,
    this.mp3UrlPro,
    this.text,
    this.answers,
    this.mp3Url,
    this.correctAnswer,
    this.transcript,
  });

  factory ToeicQuestion.fromJson(Map<String, dynamic> json) {
    return ToeicQuestion(
      qid: json['qid'],
      text: json['text'],
      transcript: json['transcript'],
      imgUrl: json["img"],
      mp3Url: json["audio"],
      mp3UrlPro: json["mp3UrlPro"],
      correctAnswer: json["correct_answer"],
      answers:
          (json['answers'] as List<dynamic>).map((e) => e as String).toList(),
    );
  }
}

class ToeicQuestionResponse {
  List<ToeicQuestion> listOfQuestions;
  ToeicQuestionResponse({required this.listOfQuestions});
  factory ToeicQuestionResponse.fromJson(Map<String, dynamic> json) {
    return ToeicQuestionResponse(
      listOfQuestions: (json["data"] as List<dynamic>)
          .map((e) => ToeicQuestion.fromJson(e))
          .toList(),
    );
  }
}

class ToeicGroupQuestion {
  final int? gid;
  final String? text;
  final String? imgUrl;
  final String? mp3UrlPro;
  final String? mp3Url;
  final String? transcript;
  final List<ToeicQuestion>? questions;

  ToeicGroupQuestion({
    this.gid,
    this.text,
    this.imgUrl,
    this.mp3Url,
    this.mp3UrlPro,
    this.questions,
    this.transcript,
  });

  factory ToeicGroupQuestion.fromJson(Map<String, dynamic> json) {
    return ToeicGroupQuestion(
      gid: json['gid'],
      text: json['text'],
      imgUrl: json['imgUrl'],
      mp3Url: json['mp3Url'],
      mp3UrlPro: json['mp3UrlPro'],
      transcript: json['transcript'],
      questions: (json['questions'] as List<dynamic>)
          .map((e) => ToeicQuestion.fromJson(e))
          .toList(),
    );
  }
}

class ToeicGroupQuestionResponse {
  List<ToeicGroupQuestion> listOfQuestions;
  ToeicGroupQuestionResponse({required this.listOfQuestions});
  factory ToeicGroupQuestionResponse.fromJson(Map<String, dynamic> json) {
    return ToeicGroupQuestionResponse(
      listOfQuestions: (json["data"] as List<dynamic>)
          .map((e) => ToeicGroupQuestion.fromJson(e))
          .toList(),
    );
  }
}
