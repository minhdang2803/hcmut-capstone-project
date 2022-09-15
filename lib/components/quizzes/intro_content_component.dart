import 'package:capstone_project_hcmut/models/models.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../view_models/view_models.dart';

class IntroContentComponent extends StatelessWidget {
  final Size size;
  final IntroModel model;
  const IntroContentComponent(
      {Key? key, required this.size, required this.model})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size.height * 0.6,
      width: size.width * 0.9,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).backgroundColor,
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              model.level,
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  ?.copyWith(color: kGreyTitleText),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: kQuizGameUnselectedColor),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(3),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Theme.of(context).primaryColor),
                        child: Icon(
                          Icons.question_mark,
                          color: Theme.of(context).backgroundColor,
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Text('${model.questions} Questions',
                          style: Theme.of(context).textTheme.headline5)
                    ],
                  ),
                  const VerticalDivider(color: Colors.black, thickness: 1),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: kPinkColor),
                        child: const FaIcon(
                          FontAwesomeIcons.puzzlePiece,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: size.width * 0.02),
                      Text('${model.points} Points',
                          style: Theme.of(context).textTheme.headline5)
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Description',
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  ?.copyWith(color: kGreyTitleText),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(height: size.height * 0.02),
          Text(
            model.content,
            style: Theme.of(context)
                .textTheme
                .headline3
                ?.copyWith(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }
}
