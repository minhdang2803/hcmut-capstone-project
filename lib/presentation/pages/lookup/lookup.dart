import 'package:bke/bloc/dictionary/dictionary_cubit.dart';
import 'package:bke/data/configs/hive_config.dart';
import 'package:bke/data/models/vocab/vocab.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../routes/route_name.dart';
import '../../theme/app_color.dart';
import '../../widgets/widgets.dart';
import '../my_dictionary/vocab_item.dart';
import 'package:hive_flutter/hive_flutter.dart';
// import '../../theme/app_color.dart';
// import '../../widgets/cvn_app_bar.dart';
// import 'vocab_item.dart';

class LookUpPage extends StatefulWidget {
  const LookUpPage({super.key});

  @override
  State<LookUpPage> createState() => _LookUpPageState();
}

class _LookUpPageState extends State<LookUpPage> with TickerProviderStateMixin {
  static final tabs = <Tab>[
    Tab(
        child: FittedBox(
            child: Text(
      'Từ yêu thích',
      style: AppTypography.title,
    ))),
    Tab(
        child: FittedBox(
            child: Text(
      'Từ điển',
      style: AppTypography.title,
    ))),
  ];
  late final TabController _tabController;
  final word = TextEditingController();
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: SvgPicture.asset('assets/texture/hoatiet.svg',
              fit: BoxFit.contain, color: AppColor.accentBlue),
        ),
        Positioned(
          top: 0,
          left: 10,
          right: 10,
          child: Column(
            children: [
              TabBar(
                labelStyle: AppTypography.title,
                labelColor: AppColor.textPrimary,
                unselectedLabelStyle: AppTypography.title,
                unselectedLabelColor: AppColor.textSecondary,
                indicatorColor: AppColor.secondary,
                tabs: tabs,
                controller: _tabController,
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: TabBarView(controller: _tabController, children: [
                  _buildFavoriteVocabs(context),
                  BlocBuilder<DictionaryCubit, DictionaryState>(
                    builder: (context, state) {
                      if (state.status == DictionaryStatus.initial) {
                        return Column(
                          children: [
                            10.verticalSpace,
                            CustomLookupTextField(
                              controller: word,
                              onSubmitted: (value) => context
                                  .read<DictionaryCubit>()
                                  .findWord(value),
                            ),
                            EmptyWidget(
                              text: "Nhập từ vựng cần tìm kiếm",
                              paddingHeight: 120.h,
                            ),
                          ],
                        );
                      } else if (state.status == DictionaryStatus.loading) {
                        return const Center(
                          child: CircularProgressIndicator(
                              color: AppColor.secondary),
                        );
                      } else {
                        if (state.vocabList!.isEmpty) {
                          return Column(
                            children: [
                              10.verticalSpace,
                              CustomLookupTextField(
                                controller: word,
                                onSubmitted: (value) => context
                                    .read<DictionaryCubit>()
                                    .findWord(value.toLowerCase()),
                              ),
                              EmptyWidget(
                                text: "Nhập từ vựng cần tìm kiếm",
                                paddingHeight: 120.h,
                              ),
                            ],
                          );
                        } else {
                          return _buildDictionaryLocal(context);
                        }
                      }
                    },
                  ),
                ]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDictionaryLocal(BuildContext context) {
    return Column(
      children: [
        10.verticalSpace,
        CustomTextField(
          controller: word,
          onSubmitted: (value) =>
              context.read<DictionaryCubit>().findWord(value),
        ),
        BlocBuilder<DictionaryCubit, DictionaryState>(
          builder: (context, state) {
            if (state.status == DictionaryStatus.fail) {
              return const Center(
                child: CircularProgressIndicator(color: AppColor.secondary),
              );
            }
            return Expanded(
              child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.only(left: 10.w, right: 10.w),
                  width: MediaQuery.of(context).size.width,
                  child: _buildDictionaryCubit()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFavoriteVocabs(BuildContext context) {
    return Container(
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
            return EmptyWidget(paddingHeight: 150.r);
          }
          return _buildDictionary(vocabList);
        },
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

  Widget _buildDictionaryCubit() {
    return BlocBuilder<DictionaryCubit, DictionaryState>(
      builder: (context, state) {
        return ListView.separated(
          padding: EdgeInsets.only(top: 20.r),
          scrollDirection: Axis.vertical,
          itemCount: state.vocabList!.length + 1,
          itemBuilder: (context, index) {
            if (index < state.vocabList!.length) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    RouteName.vocabFullInfo,
                    arguments: state.vocabList![index],
                  );
                },
                child: VocabDictionaryItem(
                  vocab: state.vocabList![index],
                ),
              );
            } else {
              return 180.verticalSpace;
            }
          },
          separatorBuilder: (BuildContext context, int index) =>
              5.verticalSpace,
        );
      },
    );
  }
}
