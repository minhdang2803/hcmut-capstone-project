class QuizModel {
  QuizModel({
    required this.data,
    required this.message,
    required this.statusCode,
  });
  late final QuizData data;
  late final String message;
  late final int statusCode;

  QuizModel.fromJson(Map<String, dynamic> json) {
    data = QuizData.fromJson(json['data']);
    message = json['message'];
    statusCode = json['statusCode'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['data'] = data.toJson();
    _data['message'] = message;
    _data['statusCode'] = statusCode;
    return _data;
  }
}

class QuizData {
  QuizData({
    required this.userId,
    required this.examKey,
    required this.game,
  });
  late final String userId;
  late final String examKey;
  late final List<GameModel> game;

  QuizData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    examKey = json['exam_key'];
    game = List.from(json['game']).map((e) => GameModel.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['exam_key'] = examKey;
    _data['game'] = game.map((e) => e.toJson()).toList();
    return _data;
  }
}

class GameModel {
  GameModel({
    required this.id,
    required this.question,
    required this.answers,
  });
  late final int id;
  late final String question;
  late final List<String> answers;

  GameModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    question = json['question'];
    answers = List.castFrom<dynamic, String>(json['answers']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['question'] = question;
    _data['answers'] = answers;
    return _data;
  }
}
