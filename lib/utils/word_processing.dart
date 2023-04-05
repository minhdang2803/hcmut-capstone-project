import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../presentation/pages/video/component/bottom_vocabulary.dart';

class WordProcessing{

  WordProcessing._internal();
  
  static final _instance = WordProcessing._internal();
  factory WordProcessing.instance() => _instance;

  List<String> splitWord(String subText) {
    final eachCharList = subText.split(" ");
    List<String> result = [];
    String tempWord = '';
    for (final element in eachCharList) {
      if (element.contains("[") && element.contains("]")) {
        result.add(element);
      } else if (element.contains('[') && !element.contains(']')) {
        tempWord = "$tempWord$element ";
      } else if (!element.contains('[') && element.contains(']')) {
        tempWord = tempWord + element;
        result.add(tempWord);
        tempWord = "";
      } else if (!element.contains('[') && !element.contains(']')) {
        result.add(element);
      }
    }
    return result;
  }

  List<TextSpan> createTextSpans(BuildContext context, String subText, TextStyle style) {
    final arrayStrings = splitWord(subText);
    List<TextSpan> arrayOfTextSpan = [];
    for (int index = 0; index < arrayStrings.length; index++) {
      var text = arrayStrings[index];
      TextSpan span = const TextSpan();
      // first is the word highlight recommended by admin [example] and ending with , or .
      if (text.contains('[') && text.contains(']')) {
        text = text.trim().substring(1, text.length - 1);
        span = TextSpan(
          text: '$text ',
          style: style,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => BottomVocab(text: text.toLowerCase()),
              );
            },
        );
      } else {
        // the normalword
        span = TextSpan(
          text: "$text ",
          style: style,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent
                ,
                builder: (context) => BottomVocab(text: text.toLowerCase()),
              );
            },
        );
      }

      arrayOfTextSpan.add(span);
    }
    return arrayOfTextSpan;
  }
}