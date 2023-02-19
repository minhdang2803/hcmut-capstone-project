import 'package:bke/bloc/book/book_bloc.dart';
import 'package:bke/bloc/book/book_event.dart';
import 'package:bke/data/models/book/book_listener.dart';
import 'package:bke/data/models/book/book_reader.dart';
import 'package:bke/data/models/network/cvn_exception.dart';
import 'package:bke/utils/log_util.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../bloc/book/book_state.dart';
import '../../../utils/constants.dart';
import '../../theme/app_typography.dart';
import '../../widgets/holder_widget.dart';

import 'package:bke/presentation/theme/app_color.dart';

import '../video/component/bottom_vocabulary.dart';

class BookRead extends StatefulWidget {
  const BookRead({super.key, required this.book});
  final BookArguments book;


  @override
  State<BookRead> createState() => _BookReadState();
}

class _BookReadState extends State<BookRead>{

  // bool _ckptReached = false;
  late EbookModel _ebook;
  late final BookBloc _bookBloc;


  final ScrollController _scrollController = ScrollController(initialScrollOffset: 1.0);
  late final ScrollController _scrollControllerBottomUp;
  bool _isLoading = false;
 
  int _pageNumber = 1;
  late final int _totalPage;
  double _position = 0;
  bool _ckptReached = false;
  late double _oldCkpt = 0.0;
  late double _maxExtent = 0.0; 
  late double _rowHeight = 0.0;

  @override
  void initState(){
    super.initState();
    _bookBloc = BookBloc();
    
    _scrollController.addListener(_scrollListener);

    _bookBloc.add(LoadEbookEvent(bookId: widget.book.bookId, pageKey : _pageNumber));

   
    
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() async {

    
    if (_maxExtent == 0.0){
        _maxExtent = _scrollController.position.maxScrollExtent - 100.0;
        _scrollControllerBottomUp = ScrollController(initialScrollOffset: _maxExtent); //init a new scroll controller that set initial offset to end
        _scrollControllerBottomUp.addListener(_scrollListenerBottomUp);      
      }
      
    //scroll down
    if (!_isLoading &&
        _scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange){
      setState(() {
        _isLoading = true; 
      });
      
      await _loadNextPage();
      
    }

    //scroll up
    if (!_isLoading &&
        _scrollController.offset <= _scrollController.position.minScrollExtent &&
        !_scrollController.position.outOfRange){
          
      setState(() {
        _isLoading = true; 
      });
      
      await _loadPrevPage();

    }
   
    if ((_scrollController.offset - _oldCkpt).abs() > 500){
      _oldCkpt = _scrollController.offset;
    
      final int savedIdx = (_scrollController.offset/_rowHeight + Constants.defaultReadingPageSize*(_pageNumber-1)).toInt();
      LogUtil.debug('$_oldCkpt and $savedIdx');
      _bookBloc.add(UpdateCkptEvent(bookId: widget.book.id, ckpt: savedIdx, isEbook: true));
    }
  }

  
  Future<void> _loadNextPage() async {
    setState(() async{
      _isLoading = false;
      _pageNumber++;
      if (_pageNumber > _totalPage){
        _pageNumber = _totalPage;
        return;
      }
       _bookBloc.add(LoadEbookEvent(bookId: widget.book.bookId, pageKey : _pageNumber));
    });
  }


  Future<void> _loadPrevPage() async{
    setState(() {
      _isLoading = false;
      _pageNumber--;
      if (_pageNumber <= 0){
        _pageNumber=1;
        return;
      }
      _bookBloc.add(LoadEbookAnotherEvent(bookId: widget.book.bookId, pageKey : _pageNumber));
    });
    

    
  }

  void _scrollListenerBottomUp() async {
    //scroll down
    if (!_isLoading && 
        _scrollControllerBottomUp.offset >= _scrollControllerBottomUp.position.maxScrollExtent &&
        !_scrollControllerBottomUp.position.outOfRange){
          
      setState(() {
        _isLoading = true; 
      });
      
      await _loadNextPage();
      
    }

    //scroll up
    if (!_isLoading &&
        _scrollControllerBottomUp.offset <= _scrollControllerBottomUp.position.minScrollExtent &&
        !_scrollControllerBottomUp.position.outOfRange){
      setState(() {
        _isLoading = true; 
      });
      await _loadPrevPage();
 
      // await _getMoreSentences(addHead: true)
    }

    if ((_scrollControllerBottomUp.offset - _oldCkpt).abs() > 500){
      _oldCkpt = _scrollControllerBottomUp.offset;
      final int savedIdx = (_scrollControllerBottomUp.offset/_rowHeight + Constants.defaultReadingPageSize*(_pageNumber-1)).toInt();
      LogUtil.debug('$_oldCkpt and $savedIdx');
      _bookBloc.add(UpdateCkptEvent(bookId: widget.book.id, ckpt: savedIdx, isEbook: true));
    }
  }

  void setInitialCkpt(index) async{
    _pageNumber = (index/Constants.defaultReadingPageSize).floor() + 1;
    if (_pageNumber > 1){
      _bookBloc.add(LoadEbookEvent(bookId: widget.book.bookId, pageKey : _pageNumber));
    }
    
    _position = (index%Constants.defaultReadingPageSize)*_rowHeight;
    _oldCkpt = _position;
    LogUtil.debug('position: $_position page: $_pageNumber');
    
    _ckptReached = true;

  }

  List<String> splitWord(String subText) {
    final eachCharList = subText.split(" ");
    List<String> result = [];
    String tempWord = '';
    for (final element in eachCharList) {
      if (element.contains("[") && element.contains("]")) {
        result.add(element);
      } else if (element.contains('[') && !element.contains(']')) {
        tempWord = "$tempWord$element ";
      } else if (!element.contains('[') && element.contains(']')) {
        tempWord = tempWord + element;
        result.add(tempWord);
        tempWord = "";
      } else if (!element.contains('[') && !element.contains(']')) {
        result.add(element);
      }
    }
    return result;
  }
  
  List<TextSpan> createTextSpans(String subText, TextStyle style) {
    final arrayStrings = splitWord(subText);
    List<TextSpan> arrayOfTextSpan = [];
    for (int index = 0; index < arrayStrings.length; index++) {
      var text = arrayStrings[index];
      TextSpan span = const TextSpan();
      // first is the word highlight recommended by admin [example] and ending with , or .
      if (text.contains('[') && text.contains(']')) {
        text = text.trim().substring(1, text.length - 1);
        span = TextSpan(
          text: '$text ',
          style: style,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => BottomVocab(text: text.toLowerCase()),
              );
            },
        );
      } else {
        // the normalword
        span = TextSpan(
          text: "$text ",
          style: style,
          recognizer: TapGestureRecognizer()
            ..onTap = () {
              showModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) => BottomVocab(text: text.toLowerCase()),
              );
            },
        );
      }

      arrayOfTextSpan.add(span);
    }
    return arrayOfTextSpan;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (_rowHeight == 0.0){
    _rowHeight = size.height*0.11;
    }
    return BlocProvider(
              create: (context) => _bookBloc,
              child:
                BlocBuilder<BookBloc, BookState>(
                  builder: (context, state) {
                    if (state is BookLoadingState) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.r),
                        child: const Center(
                                              child: CircularProgressIndicator(color: AppColor.primary)
                                            )
                      );
                    } 
                    else if (state is EbookLoadedState) {
                    
                      _ebook = state.book!.ebook;
                    
                      if (!_ckptReached){
                        //move to saved checkpoint
                        
                        _totalPage = state.book!.metadata.totalPage;
                        setInitialCkpt(_ebook.ckpt);
                        Future.delayed(const Duration(seconds: 2), () {
                          _scrollController.animateTo(_position-300.0, duration: const Duration(microseconds: 3000), curve: Curves.easeInOut);});
                      // Perform the action here
                          
                       
                      }
                      
                      return _buildListView(_scrollController);
                      
                    } else if (state is EbookLoadedAnotherState){
                      
                        _ebook = state.book!.ebook;
                        return _buildListView(_scrollControllerBottomUp);

                    }else {
                      // Display an error message or empty state
                      return const Text('An error occurred.');
                    }
                  }
                )
    );
  }

  Widget _buildListView(ScrollController controller){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: ListView.builder( //rebuild everytime a request to a new page is called, the response is added up to old _sentences
                          controller: controller,
                          itemCount: _ebook.sentences.length,
                          itemBuilder: (context, index) {
                            // Build your list item
                            return SizedBox(
                                  height: _rowHeight,
                                  child: RichText(
                                    text: TextSpan(
                                      children: createTextSpans(_ebook.sentences[index].text, 
                                                                AppTypography.title),
                                    ),
                                  )
                            );
                          }, 
                        ),
    );
  }
}

  