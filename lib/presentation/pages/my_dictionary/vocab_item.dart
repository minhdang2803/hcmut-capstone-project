import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/vocab/vocab_cubit.dart';

class VocabDictionaryItem extends StatefulWidget {
  const VocabDictionaryItem({super.key, required this.vocabId});

  final int vocabId;

  @override
  State<VocabDictionaryItem> createState() => _VocabDictionaryItemState();
}

class _VocabDictionaryItemState extends State<VocabDictionaryItem> {
  @override
  Widget build(BuildContext context) {
    //final appDictionary = BlocProvider.of<VocabCubit>(context).getAll();

    return Container();
  }
}
