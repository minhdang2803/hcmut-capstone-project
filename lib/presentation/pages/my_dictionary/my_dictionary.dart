import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/vocab/vocab_cubit.dart';
import '../../theme/app_color.dart';
import '../../widgets/cvn_app_bar.dart';
import 'vocab_item.dart';

class MyDictionaryPage extends StatelessWidget {
  const MyDictionaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      body: Stack(
        children: [
          _buildBody(context),
          const CVNAppBar(label: 'Từ của tui'),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    final myDictionary = BlocProvider.of<VocabCubit>(context).getAll();
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 63.r + topPadding),
      child: Container(
        height: 300.r,
        width: 1.sw,
        child: ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 30.r),
          scrollDirection: Axis.vertical,
          itemCount: myDictionary.length,
          itemBuilder: (context, index) =>
              VocabDictionaryItem(vocabId: myDictionary[index].id),
        ),
      ),
    );
  }
}
