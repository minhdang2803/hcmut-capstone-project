import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../theme/app_typography.dart';


class ContinueCard extends StatelessWidget {
  const ContinueCard({
    Key? key,
    required this.recentAction
  }) : super(key: key);

  final int recentAction;

  

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    late final String action;
    switch (recentAction) {
      case 0:
        action = 'xem';
        break;
      case 1:
        action = 'đọc';
        break;
      case 2:
        action = 'nghe';
        break;
      case 3:
        action = 'học từ vựng';
        break;
      case 4:
        action = 'làm bài';
        break;
      case 5:
        action = 'chơi';
        break;
    }
    return Stack(
        children: [
          SvgPicture.asset(
            'assets/texture/card.svg',
            width: size.width,
            fit: BoxFit.contain,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        color: Colors.white.withOpacity(0.3),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                width: size.width*0.55,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    AutoSizeText(
                                    'Tiếp tục $action',
                                    style: AppTypography.body.copyWith(
                                      fontWeight: FontWeight.w500,
                                      color:  Colors.white,
                                    ),
                                    maxLines: 1,
                                  ),
                                  AutoSizeText(
                                    'Is he living or he dead?',
                                    style: AppTypography.title.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color:  Colors.white,
                                    ),
                                    maxLines: 2,
                                  ),
                                  
                                  ],
                                ),
                              ),

                               Stack(
                                alignment: AlignmentDirectional.center,
                                  children: [
                                    SizedBox(
                                      width: size.width*0.12,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(10),
                                        child: Container(
                                          color: Colors.white)
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(1.0),
                                      child: SizedBox(
                                        width: size.width*0.11,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(10),
                                          child: Image.asset(
                                            'assets/images/Is_He_Living_or_is_He_Dead-Mark_Twain.jpg',
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                    ),  
                                  ],
                                ),
                              
                            ],
                        )
                      )
                    ),
          ),
        ],
      );
  }



}