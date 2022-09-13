// Quizz Level one model

class QuizOneResponseModel {
  QuizOneResponseModel({
    required this.data,
    required this.message,
    required this.statusCode,
  });
  late final QuizOneData data;
  late final String message;
  late final int statusCode;

  QuizOneResponseModel.fromJson(Map<String, dynamic> json) {
    data = QuizOneData.fromJson(json['data']);
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

class QuizOneData {
  QuizOneData({
    required this.userId,
    required this.examKey,
    required this.game,
  });
  late final String userId;
  late final String examKey;
  late final List<Game> game;

  QuizOneData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    examKey = json['exam_key'];
    game = List.from(json['game']).map((e) => Game.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['user_id'] = userId;
    _data['exam_key'] = examKey;
    _data['game'] = game.map((e) => e.toJson()).toList();
    return _data;
  }
}

class Game {
  Game({
    required this.id,
    required this.question,
    required this.answers,
  });
  late final int id;
  late final String question;
  late final List<String> answers;

  Game.fromJson(Map<String, dynamic> json) {
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
