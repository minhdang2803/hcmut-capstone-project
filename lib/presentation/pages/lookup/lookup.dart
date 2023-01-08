import 'package:bke/data/configs/hive_config.dart';
import 'package:bke/data/models/vocab/vocab.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../routes/route_name.dart';
import '../../widgets/custom_app_bar.dart';
import '../my_dictionary/vocab_item.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import '../../theme/app_color.dart';
// import '../../widgets/cvn_app_bar.dart';
// import 'vocab_item.dart';

class LookUpPage extends StatelessWidget {
  const LookUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SvgPicture.asset(
            'assets/texture/hoatiet.svg',
            fit: BoxFit.contain,
          ),
        ),
        Column(
          children: [
            BkEAppBar(
              label: 'Tra từ',
            ),
            _buildBody(context),
          ],
        ),
      ],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Expanded(
      child: Container(
        color: Colors.transparent,
        padding: EdgeInsets.only(left: 10.w, right: 10.w),
        width: double.infinity,
        child: ValueListenableBuilder(
          valueListenable: Hive.box(HiveConfig.myDictionary).listenable(),
          builder: (context, value, child) {
            List<LocalVocabInfo> vocabList = [];
            final myVocab = value.values;
            vocabList.addAll(myVocab.map((e) => e));

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
      padding: EdgeInsets.only(top: 20.r),
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
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    );
  }
}
