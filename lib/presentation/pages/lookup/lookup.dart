import 'package:bke/presentation/theme/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/vocab/vocab_cubit.dart';
import '../../widgets/cvn_app_bar.dart';
import '../my_dictionary/vocab_item.dart';
// import '../../theme/app_color.dart';
// import '../../widgets/cvn_app_bar.dart';
// import 'vocab_item.dart';

class LookUpPage extends StatelessWidget {
  const LookUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _buildBody(context),
        const CVNAppBar(label: 'Từ điển'),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    final myDictionary = BlocProvider.of<VocabCubit>(context).getAll();
    return Expanded(
      child: Container(
        color: AppColor.appBackground,
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        width: double.infinity,
        child: ListView.builder(
          // padding: EdgeInsets.symmetric(horizontal: 30.r),
          scrollDirection: Axis.vertical,
          itemCount: myDictionary.length,
          itemBuilder: (context, index) =>
              VocabDictionaryItem(vocab: myDictionary[index]),
        ),
      ),
    );
  }
}
