import 'package:flutter/material.dart';

import '../../../data/models/vocab/vocab.dart';

class VocabDictionaryItem extends StatefulWidget {
  const VocabDictionaryItem({super.key, required this.vocabInfo});

  final VocabInfo vocabInfo;

  @override
  State<VocabDictionaryItem> createState() => _VocabDictionaryItemState();
}

class _VocabDictionaryItemState extends State<VocabDictionaryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(widget.vocabInfo.vocab),
    );
  }
}
