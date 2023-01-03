import 'package:auto_size_text/auto_size_text.dart';
import 'package:bke/presentation/pages/home/components/continue_card.dart';
import 'package:bke/presentation/pages/home/components/join_quiz_card.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/utils/enum.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../theme/app_color.dart';
import '../main/components/monastery_search_delegate.dart';

class NavigationPage extends StatefulWidget {
  const NavigationPage({Key? key, this.onPageSelected}) : super(key: key);

  final void Function(int index)? onPageSelected;

  @override
  State<NavigationPage> createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> menuList = <String>[
      'video',
      'book',
      'flashcard',
      'test',
      'puzzle',
      'chat'
    ];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: Stack(
        children: [
          Positioned.fill(
            child:
                SvgPicture.asset('assets/texture/home.svg', fit: BoxFit.cover),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Visibility(
                visible: true,
                child: SizedBox(
                    height: size.height * 0.12,
                    width: size.width * 0.8,
                    child: ContinueCard(
                        recentAction: RecentAction.readBook.index))),
            SizedBox(
                height: size.height * 0.25,
                width: size.width * 0.95,
                child: Stack(
                  alignment: AlignmentDirectional.bottomStart,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(
                          top: 30, bottom: 30, left: 50, right: 50),
                      child: JoinQuizCard(),
                    ),
                    Image.asset('assets/images/proud.png',
                        height: size.height * 0.2, width: size.height * 0.12),
                  ],
                )),
            SizedBox(
                height: size.height * 0.08,
                child: ListView.builder(
                  itemBuilder: (ctx, i) => GestureDetector(
                    onTap: () => widget.onPageSelected?.call(i + 1),
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 10,
                      ),
                      width: size.height * 0.08,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Stack(
                            alignment: AlignmentDirectional.center,
                            children: [
                              Container(
                                color: AppColor.accentBlue,
                              ),
                              Image.asset('assets/icons/${menuList[i]}.png',
                                  height: size.height * 0.05,
                                  width: size.height * 0.05),
                            ]),
                        // Image.network(
                        //   bookList[i].coverUrl,
                        //   height: size.height*0.25
                        // ),
                      ),
                    ),
                  ),
                  itemCount: 6,
                  scrollDirection: Axis.horizontal,
                )),
            SizedBox(height: size.height * 0.03),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: TextButton(
                  onPressed: () {
                    showSearch(
                        context: context, delegate: MonasterySearchDelegate());
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: size.height * 0.05,
                      width: size.width * 0.95,
                      color: AppColor.secondary,
                      padding: EdgeInsets.symmetric(vertical: 0.8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(width: size.width * 0.04),
                          SvgPicture.asset(
                            'assets/icons/ic_search.svg',
                            color: AppColor.lightGray,
                            width: 20,
                            height: 20,
                          ),
                          SizedBox(width: size.width * 0.02),
                          AutoSizeText(
                            'Tra từ vựng, video, sách,...',
                            style: AppTypography.body.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColor.lightGray,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
            SizedBox(height: size.height * 0.03),
            // Expanded(
            //   child: Container(
            //     padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
            //     width: double.infinity,
            //     decoration: const BoxDecoration(
            //       color: AppColor.secondary,
            //       borderRadius: BorderRadius.only(
            //         topLeft: Radius.circular(40),
            //       ),
            //     ),
            //     child: SingleChildScrollView(),
            //   ),
            // ),
          ]),
        ],
      ),
    );
  }
}
