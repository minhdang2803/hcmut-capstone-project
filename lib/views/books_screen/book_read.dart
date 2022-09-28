import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';


/// Represents Homepage for Navigation
class BookRead extends StatefulWidget {
  const BookRead({Key? key}) : super(key: key);

  @override
  State<BookRead> createState() => _BookRead();
}
class _BookRead extends State<BookRead> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size =  MediaQuery.of(context).size;
    
    return Scaffold(
              appBar: AppBar(
                          backgroundColor: Colors.grey.withOpacity(0.5),
                          actions: <Widget>[
                            IconButton(
                              icon: const Icon(
                                Icons.menu,
                                color: Colors.white,
                                semanticLabel: 'Table of contents',
                              ),
                              onPressed: () {
                                _pdfViewerKey.currentState?.openBookmarkView();
                              },
                            ),
                          ],
              ),
              body:  SfPdfViewer.asset('assets/books_screen/Pride-and-Prejudice.pdf', 
                                  key: _pdfViewerKey, 
                                  pageLayoutMode: PdfPageLayoutMode.single),         
    );
  }


  
}
class HiddenAppBar extends StatelessWidget {
  const HiddenAppBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
      return Container(
            color: Colors.grey.withOpacity(0.5),
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).backgroundColor,
                    size: 35,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                IconButton(
                  icon: Icon(
                    Icons.bookmark_border_rounded,
                    color:  Theme.of(context).backgroundColor,
                    size: 35,
                  ),
                  onPressed: () {},
                )
              ],
            ),
          );
  }
}