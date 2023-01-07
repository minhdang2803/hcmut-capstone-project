import 'package:bke/data/models/vocab/vocab.dart';
import 'package:bke/presentation/routes/route_name.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/widgets/cvn_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../data/configs/hive_config.dart';
import '../../theme/app_typography.dart';
import 'vocab_item.dart';

class MyDictionaryPage extends StatelessWidget {
  const MyDictionaryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
        child: Column(
          children: [
            BkEAppBar(
              label: 'Từ vựng yêu thích',
              onBackButtonPress: () => Navigator.pop(context),
            ),
            _buildBody(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20.r)),
        ),
        width: double.infinity,
        child: ValueListenableBuilder(
          valueListenable: Hive.box(HiveConfig.myDictionary).listenable(),
          builder: (context, value, child) {
            List<LocalVocabInfo> vocabList = [];
            final myVocab = value.values;
            vocabList.addAll(myVocab.map((e) => e));
            print(vocabList);
            if (value.isEmpty) {
              return _buildEmpty();
            }
            return _buildDictionary(vocabList);
          },
        ),
      ),
    );
  }

  ListView _buildDictionary(List<LocalVocabInfo> vocabList) {
    return ListView.separated(
      padding: EdgeInsets.only(top: 20.h),
      // padding: EdgeInsets.symmetric(horizontal: 30.r),
      scrollDirection: Axis.vertical,
      itemCount: vocabList.length,
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          print(vocabList[index].id);
          Navigator.pushNamed(
            context,
            RouteName.vocabFullInfo,
            arguments: vocabList[index],
          );
        },
        child: VocabDictionaryItem(
          vocab: vocabList[index],
          color: AppColor.accentPink,
        ),
      ),
      separatorBuilder: (BuildContext context, int index) => 5.verticalSpace,
    );
  }

  Column _buildEmpty() {
    return Column(
      children: [
        120.verticalSpace,
        Image(
          image: const AssetImage("assets/images/angry.png"),
          height: 200.r,
          width: 200.r,
        ),
        Text(
          "Bạn chưa lưu từ vựng nào!",
          style: AppTypography.subHeadline.copyWith(
            color: AppColor.primary,
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }
}
