import 'package:flutter/material.dart';

class ResultComponent extends StatelessWidget {
  final int resultScore;
  final Function returnHandler;

  const ResultComponent(this.resultScore, this.returnHandler, {Key? key})
      : super(key: key);

  //Remark Logic
  String get resultPhrase {
    String resultText = "noobbbbbb";
    return resultText;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            resultPhrase,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ), //Text
          Text(
            'Score ' '$resultScore',
            style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ), //Text
          TextButton(
            onPressed: () => returnHandler(),
            child: Container(
              color: Colors.orange.shade400,
              padding: const EdgeInsets.all(14),
              child: const Text(
                'Return home',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
