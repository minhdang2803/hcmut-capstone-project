import 'package:bke/bloc/book/book_bloc.dart';
import 'package:bke/bloc/book/book_event.dart';
import 'package:bke/data/models/book/book_listener.dart';
import 'package:bke/data/models/book/book_reader.dart';
import 'package:bke/utils/word_processing.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/book/book_state.dart';
import '../../../utils/constants.dart';
import '../../../utils/log_util.dart';
import '../../theme/app_typography.dart';

import 'package:bke/presentation/theme/app_color.dart';

import '../video/component/bottom_vocabulary.dart';

class BookRead extends StatefulWidget {
  const BookRead({super.key, required this.book});
  final BookArguments book;

  @override
  State<BookRead> createState() => _BookReadState();
}

class _BookReadState extends State<BookRead> {
  // bool _ckptReached = false;
  late EbookModel _ebook;
  late final BookBloc _bookBloc;

  final ScrollController _scrollController = ScrollController(initialScrollOffset: 1.0);
  final ScrollController _scrollControllerBottomUp = ScrollController(initialScrollOffset: 9999.0); //init a new scroll controller that set initial offset to end
  final WordProcessing _wordProcessing = WordProcessing.instance();

  bool _isLoading = false;

  int _pageNumber = 1;
  late int _totalPage;
  double _position = 0;
  List <double> offsets = [];
  bool _ckptReached = false;
  bool _pageReached = false;
  late int _oldPage = 1;
  late double _oldCkpt = 0.0;
  int _chapterIdx = -1;
  final int _maxCharInOneRow = 50;
  final double _rowHeight = 30.h;
  final double _rowWidth = 16.r*20;

  DateTime? _loadPrevPageTime;
  DateTime _lastUpdate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _bookBloc = BookBloc();

    _scrollController.addListener(_scrollListener);
    
    _scrollControllerBottomUp.addListener(_scrollListenerBottomUp);
    _bookBloc
        .add(LoadEbookEvent(bookId: widget.book.bookId, pageKey: _pageNumber));
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _scrollControllerBottomUp.removeListener(_scrollListener);
    _scrollControllerBottomUp.dispose();
    super.dispose();
  }

  void _scrollListener() async {
    // print(_scrollController.offset);
    
    //scroll down
    if (!_isLoading &&
        _scrollController.offset >=
            _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
    
      if (_loadPrevPageTime != null && DateTime.now().difference(_loadPrevPageTime!).inSeconds < 3){
          return;
      }
      setState(() {
        _isLoading = true;
      });
      await _loadNextPage();
    }

    //scroll up
    if (!_isLoading &&
        _scrollController.offset <=
            _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        _isLoading = true;
      });
      await _loadPrevPage();
      _loadPrevPageTime = DateTime.now();
    }

    
      
      if (_ckptReached && DateTime.now().difference(_lastUpdate).inSeconds > 5 ){
        if ((_scrollController.offset - _oldCkpt).abs() > 1000 || _pageNumber != _oldPage) {
          _oldCkpt = _scrollController.offset;
          _oldPage = _pageNumber;
          int savedIdx = 0;
          for (int i = 0; i< offsets.length; i++){
            if (_scrollController.offset < offsets[i]){
              savedIdx = Constants.defaultReadingPageSize * (_pageNumber - 1) + i;
              break;
            }  
          }
      
          _bookBloc.add(UpdateCkptEvent(
            bookId: widget.book.id, ckpt: savedIdx, isEbook: true));
          _lastUpdate = DateTime.now();
        }
      }
  }

  Future<void> _loadNextPage() async {
    setState(() {
      _isLoading = false;
      _pageNumber++;
      if (_pageNumber > _totalPage) {
        _pageNumber = _totalPage;
        return;
      }
      _bookBloc.add(
          LoadEbookEvent(bookId: widget.book.bookId, pageKey: _pageNumber));
    });
  }

  Future<void> _loadPrevPage() async {
    setState(() {
      _isLoading = false;
      _pageNumber--;
      if (_pageNumber <= 0) {
        _pageNumber = 1;
        return;
      }
      _bookBloc.add(LoadEbookAnotherEvent(
          bookId: widget.book.bookId, pageKey: _pageNumber));
    });
  }

  void _scrollListenerBottomUp() async {
    //scroll down
    
    if (!_isLoading &&
        _scrollControllerBottomUp.offset >=
            _scrollControllerBottomUp.position.maxScrollExtent &&
        !_scrollControllerBottomUp.position.outOfRange) {
   
      if (_loadPrevPageTime != null && DateTime.now().difference(_loadPrevPageTime!).inSeconds < 3){
        return;
      }
      setState(() {
        _isLoading = true;
      });
      await _loadNextPage();
    }

    //scroll up
    if (!_isLoading &&
        _scrollControllerBottomUp.offset <=
            _scrollControllerBottomUp.position.minScrollExtent &&
        !_scrollControllerBottomUp.position.outOfRange) {
      setState(() {
        _isLoading = true;
      });
      await _loadPrevPage();
      _loadPrevPageTime = DateTime.now();
    }
    

    if (_ckptReached && DateTime.now().difference(_lastUpdate).inSeconds > 5 ){
      if ((_scrollControllerBottomUp.offset - _oldCkpt).abs() > 1000 || _pageNumber != _oldPage) {
        _oldCkpt = _scrollControllerBottomUp.offset;
        _oldPage = _pageNumber;
        int savedIdx = 99;
        for (var i = 0; i< offsets.length; i+=1){
          if (_scrollControllerBottomUp.offset < offsets[i]){
            savedIdx = Constants.defaultReadingPageSize * (_pageNumber - 1) + i;
            break;
          }
          
        }
      // LogUtil.debug('$_oldCkpt and $savedIdx');
      
        _bookBloc.add(UpdateCkptEvent(
          bookId: widget.book.id, ckpt: savedIdx, isEbook: true));
        _lastUpdate = DateTime.now();
        
      }
    }
  }

  void setInitialCkpt(index) async {
    _ckptReached = true;
    _pageNumber = (index / Constants.defaultReadingPageSize).floor() + 1;

    if (_pageNumber > 1) {
      _bookBloc.add(
          LoadEbookEvent(bookId: widget.book.bookId, pageKey: _pageNumber));
    }
    if (offsets.isNotEmpty){
      _position = offsets[index % Constants.defaultReadingPageSize];
      _oldCkpt = _position;
    }
    // LogUtil.debug('position: $_position page: $_pageNumber');
    
  }

  void setPage(index) async {
    _pageReached = true;
    final int pageNumber =
        (index / Constants.defaultReadingPageSize).floor() + 1;
    if (pageNumber != _pageNumber) {
      _bookBloc
          .add(LoadEbookEvent(bookId: widget.book.bookId, pageKey: pageNumber));
      _pageNumber = pageNumber;
    }
    
    // LogUtil.debug('position: $_position page: $_pageNumber');
  }

  int _getRatio(String text){
    int ratio = (text.length/_maxCharInOneRow).ceil(); // 1, 2, 3
    return ratio;
  }

  void calculateOffsets(List<Sentence> sentences){
    offsets.clear();
    offsets.add(0);
    for (var sentence in sentences){
      if (offsets.length == 100){ 
        break;
      }
      int ratio = (sentence.text.length/_maxCharInOneRow).ceil(); 
      double prevCellOffset = offsets[offsets.length-1];
      offsets.add(prevCellOffset + ratio*(_rowHeight - 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
  
    return Scaffold(
        backgroundColor: AppColor.primary,
        body: SafeArea(
            top: true,
            bottom: false,
            child: Column(
              children: [
                _appBar(),
                Expanded(
                  child: BlocProvider(
                      create: (context) => _bookBloc,
                      child: BlocBuilder<BookBloc, BookState>(
                          builder: (context, state) {
                        if (state is BookLoadingState) {
                          return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 1.h),
                              child: const Center(
                                  child: CircularProgressIndicator(
                                      color: AppColor.accentBlue)));
                        } else if (state is EbookLoadedState) {
                          _ebook = state.book!.ebook;
                          calculateOffsets(_ebook.sentences);
                          if (!_ckptReached) {
                            //move to saved checkpoint
                            _totalPage = state.book!.metadata.totalPage;
                            setInitialCkpt(_ebook.ckpt);
                            Future.delayed(const Duration(seconds: 1), () {
                              _scrollController.animateTo(_position - 4*_rowHeight > _scrollController.position.maxScrollExtent ? _position - _rowHeight*4 : _position,
                                  duration: const Duration(microseconds: 100),
                                  curve: Curves.easeInOut);
                            });
                            // Perform the action here
                          }
                          // LogUtil.debug(_chapterIdx.toString());
                          if (_pageReached){
                            
                            _position = offsets[_chapterIdx%Constants.defaultReadingPageSize];
                           
                            _oldCkpt = _position;
                            Future.delayed(const Duration(seconds: 1), () {
                              _pageReached = false;
                              
                              _scrollController.animateTo(_position - _rowHeight > _scrollController.position.maxScrollExtent ? _position - _rowHeight*2 : _position,
                                  duration: const Duration(microseconds: 100),
                                  curve: Curves.easeInOut);
                            });
                            
                          }

                          return _buildListView(_scrollController);
                        } else if (state is EbookLoadedAnotherState) {
                          _ebook = state.book!.ebook;
                          calculateOffsets(_ebook.sentences);
                          return _buildListView(_scrollControllerBottomUp);
                        } else {
                          // Display an error message or empty state
                          return const Text('An error occurred.');
                        }
                      })),
                )
              ],
            )));
  }

  Widget _buildListView(ScrollController controller) {
    return Container(
      width: _rowWidth,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: ListView.builder(
        //rebuild everytime a request to a new page is called, the response is added up to old _sentences
        controller: controller,
        itemCount: _ebook.sentences.length,
        itemBuilder: (context, index) {
          // Build your list item
          return Container(
              // decoration: BoxDecoration(border: Border.all(color:Colors.black)),
              height: _getRatio(_ebook.sentences[index].text)*_rowHeight,
              child: Align(
                alignment: Alignment.centerLeft, // set the alignment to center left
                child: RichText(
                          text: TextSpan(
                            children: _wordProcessing.createTextSpans(
                              context,
                              _ebook.sentences[index].text,
                              AppTypography.title,
                            ),
                          ),
                        ),
                
              ),
          );
        },
      ),
    );
  }

  Widget _appBar() {
    return Container(
      height: _rowHeight*2,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColor.appBackground,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: AppColor.textPrimary,
              size: 24,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          SizedBox(
            width: 200.w,
            child: Text(
                      widget.book.title!,
                      style: AppTypography.title.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
          ),
          IconButton(
              icon: Icon(
                Icons.menu,
                color: AppColor.textPrimary,
                size: 24.r,
              ),
              onPressed: () => showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (_) => _chapterSheet(),
                  ))
        ],
      ),
    );
  }

//  Widget _bottomBar() {
//     return Container(
//               height: _rowHeight*0.6,
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color:  AppColor.appBackground,
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(40),
//                   topRight: Radius.circular(40),
//                 ),
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
//               child:
//                 Slider(
//                   min: 0,
//                   max: _duration.inSeconds.toDouble(),
//                   value:  _duration !=  Duration.zero ? _position.inSeconds.toDouble() : 0.0 ,
//                   activeColor: AppColor.primary,
//                   onChanged: (value) async{
//                     if (_isLoaded){
//                       final position = Duration(seconds: value.toInt());
//                       await audioPlayer.seek(position);
//                     }
//                   },
//                 ),

//     );
//   }

  Widget _chapterSheet() {
    bool picked = false;
    int at = -1;
    List<String> chapterList;
    final state = _bookBloc.state;
    dynamic chapters;
    if (state is BookLoadingState) {
      return Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.r),
          child: const Center(
              child: CircularProgressIndicator(color: AppColor.secondary)));
    } 
    else{
      if (state is EbookLoadedState) {
        chapters = state.book!.ebook.chapter;
      } else if (state is EbookLoadedAnotherState){
        chapters = state.book!.ebook.chapter;
      }
      chapterList = chapters.keys.cast<String>().toList();
      if (chapterList.isNotEmpty) {
        return Container(
          padding: EdgeInsets.only(top: 20.r),
          color: AppColor.primary,
          child: ListView.builder(
            itemBuilder: (ctx, i) => GestureDetector(
                onTap: () {
                  setState(() {
                    picked = true;
                    at = i;
                  });
                   _chapterIdx = chapters[chapterList[at]];
                   setPage(_chapterIdx);
                  Navigator.pop(context);
                },
                child: SizedBox(
                  height: _rowHeight*2,
                  child: Text(
                    chapterList[i] == 'prologue'
                        ? 'Chương mở đầu'
                        : 'Chương ${chapterList[i]}',
                    style: picked && i == at
                        ? AppTypography.body.copyWith(
                              fontWeight: FontWeight.w500,
                              color: AppColor.secondary,
                            )
                        : AppTypography.body.copyWith(
                              fontWeight: FontWeight.w200,
                              color: AppColor.textPrimary,
                            ),
                    textAlign: TextAlign.center,
                  ),
                )),
            itemCount: chapterList.length,
          ),
        );
      }
    }
    return const Text("No table found.");
  }
}
