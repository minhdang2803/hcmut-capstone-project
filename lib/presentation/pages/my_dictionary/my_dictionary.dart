import 'package:bke/presentation/widgets/cvn_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/vocab/vocab_cubit.dart';
import '../../theme/app_color.dart';
import 'vocab_item.dart';

class MyDictionaryPage extends StatelessWidget {
  const MyDictionaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            BkEAppBar(
              label: "Thẻ ghi nhớ",
              onBackButtonPress: () => Navigator.pop(context),
            ),
            _buildBody(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    final myDictionary = BlocProvider.of<VocabCubit>(context).getAll();
    return Expanded(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(left: 5, right: 5),
        width: double.infinity,
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: myDictionary.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: VocabDictionaryItem(
                vocab: myDictionary[index], borderColor: AppColor.primary),
          ),
        ),
      ),
    );
  }
}
