class ToeicQuestion {
  final String? id;
  final int? qid;
  final String? text;
  final String? imgUrl;
  final String? mp3UrlPro;
  final String? mp3Url;
  final String? transcript;
  final String? correctAnswer;
  final List<String>? answers;
  final String? userAnswer;

  ToeicQuestion({
    this.id,
    this.qid,
    this.imgUrl,
    this.mp3UrlPro,
    this.text,
    this.answers,
    this.mp3Url,
    this.correctAnswer,
    this.transcript,
    this.userAnswer,
  });

  factory ToeicQuestion.fromJson(Map<String, dynamic> json) {
    return ToeicQuestion(
      id: json['_id'],
      qid: json['qid'],
      text: json['text'],
      transcript: json['transcript'],
      imgUrl: json["img"],
      mp3Url: json["audio"],
      mp3UrlPro: json["mp3UrlPro"],
      correctAnswer: json["correct_answer"],
      answers:
          (json['answers'] as List<dynamic>).map((e) => e as String).toList(),
      userAnswer: json["userAnswer"],
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
  final String? id;
  final int? gid;
  final String? text;
  final String? imgUrl;
  final String? mp3UrlPro;
  final String? mp3Url;
  final String? transcript;
  final List<ToeicQuestion>? questions;
  final List<String>? userAnswer;

  ToeicGroupQuestion({
    this.id,
    this.gid,
    this.text,
    this.imgUrl,
    this.mp3Url,
    this.mp3UrlPro,
    this.questions,
    this.transcript,
    this.userAnswer,
  });

  factory ToeicGroupQuestion.fromJson(Map<String, dynamic> json) {
    List<String>? userAnswer;
    if (json["userAnswer"] != null) {
      userAnswer = (json["userAnswer"] as List<dynamic>)
          .map((e) => e as String)
          .toList();
    }
    return ToeicGroupQuestion(
      id: json['_id'],
      gid: json['gid'],
      text: json['text'],
      imgUrl: json['imgUrl'],
      mp3Url: json['mp3Url'],
      mp3UrlPro: json['mp3UrlPro'],
      transcript: json['transcript'],
      questions: (json['questions'] as List<dynamic>)
          .map((e) => ToeicQuestion.fromJson(e))
          .toList(),
      userAnswer: userAnswer,
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

class ToeicHistoryResponse {
  List<ToeicHistory> histories;
  ToeicHistoryResponse(this.histories);
  factory ToeicHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ToeicHistoryResponse(
      (json['data'] as List<dynamic>)
          .map((e) => ToeicHistory.fromJson(e))
          .toList(),
    );
  }
}

class ToeicHistory {
  final ToeicHistoryScore score;
  final String? id;

  ToeicHistory({required this.score, this.id});

  factory ToeicHistory.fromJson(Map<String, dynamic> json) {
    return ToeicHistory(
        score: ToeicHistoryScore.fromJson(json['score']), id: json["_id"]);
  }
}

class ToeicHistoryScore {
  final ToeicPart? part1;
  final ToeicPart? part2;
  final ToeicPart? part3;
  final ToeicPart? part4;
  final ToeicPart? part5;
  final ToeicPart? part6;
  final ToeicPart? part7;
  ToeicHistoryScore({
    required this.part1,
    required this.part2,
    required this.part3,
    required this.part4,
    required this.part5,
    required this.part6,
    required this.part7,
  });
  factory ToeicHistoryScore.fromJson(Map<String, dynamic> json) {
    return ToeicHistoryScore(
      part1: json['part1'] != null ? ToeicPart.fromJson(json['part1']) : null,
      part2: json['part2'] != null ? ToeicPart.fromJson(json['part2']) : null,
      part3: json['part3'] != null ? ToeicPart.fromJson(json['part3']) : null,
      part4: json['part4'] != null ? ToeicPart.fromJson(json['part4']) : null,
      part5: json['part5'] != null ? ToeicPart.fromJson(json['part5']) : null,
      part6: json['part6'] != null ? ToeicPart.fromJson(json['part6']) : null,
      part7: json['part7'] != null ? ToeicPart.fromJson(json['part7']) : null,
    );
  }
}

class ToeicPart {
  final int total;
  final int noCorrect;
  ToeicPart({required this.total, required this.noCorrect});
  factory ToeicPart.fromJson(Map<String, dynamic> json) {
    return ToeicPart(total: json['total'], noCorrect: json['noCorrect']);
  }
}
