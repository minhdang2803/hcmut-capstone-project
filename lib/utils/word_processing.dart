import 'package:bke/utils/extension.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../presentation/pages/video/component/bottom_vocabulary.dart';

class WordProcessing {
  WordProcessing._internal();

  static final _instance = WordProcessing._internal();
  factory WordProcessing.instance() => _instance;

  List<String> splitWord(String subText) {
    List<String> eachCharList = subText.toCapitalize().split(' ');

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

  List<TextSpan> createTextSpans(
    BuildContext context,
    String subText,
    TextStyle style, {
    Function()? pause,
    Function()? play,
    bool? continuePlaying = false,
  }) {
    final arrayStrings = splitWord(subText);
    List<TextSpan> arrayOfTextSpan = [];
    for (int index = 0; index < arrayStrings.length; index++) {
      var text = arrayStrings[index].trim();
      if (text.isEmpty) continue;
      TextSpan span = const TextSpan();
      // first is the word highlight recommended by admin [example] and ending with , or .
      if (text.contains('[') && text.contains(']')) {
        int startIndex = text.indexOf('[') + 1;
        int endIndex = text.indexOf(']');
        String translatableText = text.trim().substring(startIndex, endIndex);
        span = TextSpan(
          text: '${plainText(text)} ',
          style: style,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              pause?.call();
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) =>
                    BottomVocab(text: translatableText.toLowerCase()),
              ).then((value) {
                if (continuePlaying == true) {
                  play?.call();
                }
              });
            },
        );
      } else {
        // the normalword
        span = TextSpan(
          text: "$text ",
          style: style,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              pause?.call();
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => BottomVocab(text: text.toLowerCase()),
              ).then((value) {
                if (continuePlaying == true) {
                  play?.call();
                }
              });
            },
        );
      }

      arrayOfTextSpan.add(span);
    }
    return arrayOfTextSpan;
  }

  String plainText(String text) {
    return text.replaceAll(RegExp(r'[\[\]]'), '');
  }
}
