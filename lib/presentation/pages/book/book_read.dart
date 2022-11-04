

import 'package:bke/bloc/book/book_bloc.dart';
import 'package:bke/bloc/book/book_event.dart';
import 'package:bke/data/models/book/book_reader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:skeletons/skeletons.dart';

import '../../../bloc/book/book_state.dart';
import '../../../utils/constants.dart';
// import '../../routes/route_name.dart';
import '../../widgets/holder_widget.dart';

import 'package:bke/presentation/theme/app_color.dart';

class BookRead extends StatefulWidget {
  const BookRead({super.key, required this.bookId});
  final String bookId;


  @override
  State<BookRead> createState() => _BookReadState();
}

class _BookReadState extends State<BookRead>
    with SingleTickerProviderStateMixin {
  var _currentPageKey = 1;
  bool _ckptReached = false;
  late BookReader _book;
  late final BookBloc _bookBloc;
  final PagingController<int, String> _pagingController = PagingController(firstPageKey: 1);

  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 1000),
    vsync: this,
  )..forward();

  late final Animation<double> _animationEaseIn = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeIn,
  );

  late final Animation<double> _animationEaseOut = CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  );
  @override
  void initState() {
    super.initState();
    _bookBloc = BookBloc();
    _bookBloc.add(LoadEbookEvent(bookId: widget.bookId, pageKey : _currentPageKey));

    _pagingController.addPageRequestListener((pageKey) {
        _currentPageKey = pageKey;
        _bookBloc.add(LoadEbookEvent(bookId: widget.bookId, pageKey : _currentPageKey));
    });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    // _bookBloc.add(updateCkptEvent(bookId: _audioBook.bookId, newCkpt: _currentPageKey));
    _bookBloc.close();
    super.dispose();
  }

  Future<void> setCkpt() async{
    _currentPageKey = _book.ckpt;
    _ckptReached = true;
    print(_book.ckpt);
    if (_currentPageKey != 1){
      _bookBloc.add(LoadEbookEvent(bookId: widget.bookId, pageKey : _currentPageKey));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
            create: (context) => _bookBloc,
            child:
              BlocConsumer<BookBloc, BookState>(
                listener: (context, state) {
                  if (state is EbookLoadedState) {
                    try {
                      _book = state.book;
                      if (!_ckptReached){
                        setCkpt();
                      }
                      else{
                        final newItems = _book.sentences;
                        final isLastPage = newItems.length < Constants.defaultPageSize;
                        if (isLastPage) {
                          _pagingController.appendLastPage(newItems);
                        } else {
                          _currentPageKey++;
                          _pagingController.appendPage(newItems, _currentPageKey);
                        }
                      }
                    } catch (e) {
                      _pagingController.error = e;
                    }
                  }
                },
                builder: (context, state) {
                  if (state is BookLoadingState  && _pagingController.itemList == null) {
                    return FadeTransition(
                      opacity: _animationEaseOut,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.r),
                        child: const Center(
                                              child: CircularProgressIndicator(color: AppColor.primary)
                                            ),
                      )
                    );
                  }

                  if (state is BookErrorState) {
                    return Center(
                      child: SizedBox(
                        width: 1.sw,
                        child: HolderWidget(
                          asset: 'assets/images/default_logo.png',
                          onRetry: () => {
                            context
                                .read<BookBloc>()
                              .add(LoadEbookEvent(bookId: widget.bookId, pageKey: _currentPageKey))
                          },
                        ),
                      ),
                    );
                  }

                  return FadeTransition(
                    opacity: _animationEaseIn,
                    child: PagedListView<int, String>.separated(
                      pagingController: _pagingController,
                      addAutomaticKeepAlives: true,
                      padding: EdgeInsets.symmetric(vertical: 5.r),
                      builderDelegate: PagedChildBuilderDelegate<String>(
                        itemBuilder: (ctx, item, index) => 
                       
                                        Text(item,
                                            style: Theme.of(context)
                                              .textTheme
                                              .headline6!
                                              .copyWith(
                                                fontWeight: FontWeight.normal,
                                                color: AppColor.appBackground,
                                              )
                                          ),
                                        
                            
                          
                      ),
                      separatorBuilder: (context, index) => const Divider(height: 20),
                    )
                  );
                },
              )
        );
      }
  }

