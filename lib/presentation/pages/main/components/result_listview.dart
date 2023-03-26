import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import '../../../../data/repositories/video_repository.dart';
import '../../../routes/route_name.dart';
import '../../../theme/app_color.dart';
import '../../../theme/app_typography.dart';
import '../../video/video_player_page.dart';

class ResultList extends StatefulWidget {
  const ResultList({super.key, required this.data, required this.isBook});
  final List<dynamic> data;
  final bool isBook;


  @override
  ResultListState createState() => ResultListState();
}

void onVideoClick(BuildContext context, String videoId) async{
  if (!context.mounted) return;

  final videoRepository = VideoRepository.instance();
  final savedItem = await videoRepository.saveExternalVideo(videoId);
  // ignore: use_build_context_synchronously
  Navigator.of(context).pushNamed(RouteName.videoPlayer, arguments: VideoPlayerPageModel(context: context, video: savedItem));
}

class ResultListState extends State<ResultList> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
                  itemCount: widget.data.length, // Replace with your actual data length
                  itemBuilder: (context, index) 
                    => GestureDetector(
                      onTap: () {
                        final item = widget.data.elementAt(index);
                        if (widget.isBook) {
                          Navigator.of(context)
                              .pushNamed(RouteName.bookDetails, arguments: item.bookId);
                        }else{ 
                          onVideoClick(context, item.videoId);
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
                              child: SizedBox(
                                height: 0.2.sw,
                                
                                child: FadeInImage.assetNetwork(
                                  placeholder: 'assets/images/default_logo.png',
                                  placeholderFit: BoxFit.contain,
                                  image: widget.isBook ? widget.data.elementAt(index).coverUrl : widget.data.elementAt(index).thumbUrl,
                                  fadeInDuration: const Duration(milliseconds: 400),
                                  fit: BoxFit.fill,
                                  // placeholderFit: BoxFit.fill,
                                  imageErrorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                    'assets/images/default_logo.png',
                                  ),
                                ),
                              ),
                            )
                          ),
                          SizedBox(width: 0.05.sw),
                          Expanded(
                            
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                
                                Text(
                                  widget.data.elementAt(index).title, // Replace with your actual title
                                  style: AppTypography.title.copyWith(color: AppColor.textPrimary),
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
                    )
                  )
                  
                ),
              );
  }
}