import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../data/models/quiz/quiz.dart';
import '../../../routes/route_name.dart';
import '../components/quiz_component.dart';
import '../components/result_component.dart';

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePage();
}

class _GamePage extends State<GamePage> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);
  }

  var _questionIndex = 0;
  var _totalScore = 0;

  void _answerQuestion(int score) {
    _totalScore += score;

    setState(() {
      _questionIndex = _questionIndex + 1;
    });
  }

  void _return() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    Navigator.of(context).pushReplacementNamed(RouteName.main);
  }

  @override
  Widget build(BuildContext context) {
    final quizs = ModalRoute.of(context)?.settings.arguments as List<Quiz>?;
    return Scaffold(
      body: Stack(
        children: [
          quizs?.length.compareTo(_questionIndex) != 0
              ? QuizComponent(
                  answerQuestion: _answerQuestion,
                  questionIndex: _questionIndex,
                  quizs: quizs,
                )
              : ResultComponent(_totalScore, _return),
        ],
      ),
    );
  }
}
