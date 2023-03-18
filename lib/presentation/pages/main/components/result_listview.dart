import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/video/category_video/category_video_cubit.dart';
import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';
import '../../video/video_player_page.dart';

class ResultList extends StatefulWidget {
  const ResultList({super.key, required this.data, required this.isBook});
  final List<dynamic> data;
  final bool isBook;

  @override
  ResultListState createState() => ResultListState();
}

class ResultListState extends State<ResultList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
          itemCount: widget.data.length, // Replace with your actual data length
          itemBuilder: (context, index) => GestureDetector(
              onTap: () {
                final item = widget.data.elementAt(index);
                if (widget.isBook) {
                  Navigator.of(context)
                      .pushNamed(RouteName.bookDetails, arguments: item.bookId);
                } else {
                  Navigator.of(context).pushNamed(
                    RouteName.videoPlayer,
                    arguments:
                        VideoPlayerPageModel(context: context, video: item),
                  );
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                        ),
                        width: 0.2.sw,
                        height: 0.2.sw,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Container(
                            height: 0.2.sw,
                            color: AppColor.lightGray,
                            child: FadeInImage.assetNetwork(
                              placeholder: 'assets/images/default_logo.png',
                              placeholderFit: BoxFit.contain,
                              image: widget.isBook
                                  ? widget.data.elementAt(index).coverUrl
                                  : widget.data.elementAt(index).thumbUrl,
                              fadeInDuration: const Duration(milliseconds: 400),
                              fit: BoxFit.fill,
                              // placeholderFit: BoxFit.fill,
                              imageErrorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'assets/images/default_logo.png',
                              ),
                            ),
                          ),
                        )),
                    SizedBox(width: 10.r),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.data
                                .elementAt(index)
                                .title, // Replace with your actual title
                            style: TextStyle(
                              fontSize: 16.r,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                          SizedBox(height: 5.r),
                          // Text(
                          //   widget.data.elementAt(index).author??'', // Replace with your actual description
                          //   style: TextStyle(
                          //     fontSize: 14,
                          //     color: Colors.grey,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))),
    );
  }
}
