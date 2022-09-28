// ignore_for_file: prefer_const_constructors

import 'package:capstone_project_hcmut/data/repository/book_repository.dart';
import 'book_event.dart';
import 'book_state.dart';
import 'books_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../../models/book_model.dart';
import 'book_details.dart';

class BookScreen extends StatelessWidget {
  const BookScreen({Key? key}) : super(key: key);
  static const String routeName = 'BookScreen';
  static MaterialPage page() {
    return MaterialPage(
      child: BookScreen(),
      key: ValueKey(routeName),
      name: routeName,
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create:(context) => BookRepos(),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => BookBloc(RepositoryProvider.of<BookRepos>(context))..add(LoadAllEvent())
                    ),
                    BlocProvider(
                      create: (context) => DetailsBloc()
                    ),
                  ], 
                  child: 
                    Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  BlocBuilder<BookBloc, BookState>(
                                    builder: (context, state)  {
                                      return IconButton(
                                        icon: Icon(
                                          Icons.menu,
                                          color: Theme.of(context).backgroundColor,
                                          size: 35,
                                        ),
                                    
                                        onPressed: () => showModalBottomSheet(
                                                            isScrollControlled: true,
                                                            context: context,
                                                            builder: (_) => BlocProvider.value( 
                                                                              value: BlocProvider.of<BookBloc>(context), 
                                                                              child: MenuSheet()
                                                                            ),
                                                          )
                                      );
                                    }
                                  ),

                                  IconButton(
                                    icon: Icon(
                                      Icons.search,
                                      color: Theme.of(context).backgroundColor,
                                      size: 35,
                                    ),
                                    onPressed: () {},
                                  ),
                                ]
                            ),
                            Expanded(
                              child: Container(
                                padding: const EdgeInsets.only(
                                  top: 50,
                                  left: 10,
                                  right: 10
                                ),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(40),
                                    topRight: Radius.circular(40),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                    child: contentSection(context),   
                                ),
                                ),
                              ),
                          ],
                  )
          )
        )
      )
    );
  }
  Widget contentSection(BuildContext context) {
      return BlocBuilder<BookBloc, BookState>(
                builder: (context, state)  {
                  if (state is BookLoadingState){
                    return Center(
                              child: CircularProgressIndicator(color: Theme.of(context).primaryColor)
                            );
                  }

                  if (state is BookLoadedState){
                    final String heading = state.category;
                    // print(heading);
                    List <BookModel> bookList = state.books; 
                  
                    if (heading == 'Home'){
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                                "Hello,",
                                style: Theme.of(context)
                                        .textTheme
                                        .headline4
                          ),
                          Text(
                                'user',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 15,
                              bottom: 30,
                            ),
                            width: 100,
                            height: 7,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              BookSection(heading: 'Continue reading', bookList: bookList),
                              BookSection(heading: 'My list', bookList: bookList),
                              //BookSection(); //Discover more
                              //BookSection(); //Adventures
                              //BookSection(); //Romance
                              //.etc
                            ],
                          )
                        ]
                      );//Continue reading   
                    }
                    else if (heading == 'Continue reading'){}
                    else if (heading == 'My List'){}
                    else{
                      return BookSectionDisplayAll(heading: heading, bookList: bookList);
                    }
                  }

                  if (state is BookErrorState){
                    return const Center(child: Text("Can't not load this content right now"));
                  }
                  return Container();
                }
      ); 
  }
}

class MenuSheet extends StatefulWidget {
  const MenuSheet({Key? key}) : super(key: key);

  @override
  State<MenuSheet> createState() => _MenuSheetState();
}
class _MenuSheetState extends State<MenuSheet> {
  bool picked = false;
  int at = 0;
  final String category = 'Home';
  final List<String> menuList = <String>['Home', 'My List', 'Adventures', 'Biographies', 'Children', 'Crime', 'Fiction', 'Horror', 'Poetry', 'Romance'];
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return Container(
      color: Theme.of(context).backgroundColor,
      padding: EdgeInsets.only(top: size.height*0.1),
      child: ListView.builder(
              itemBuilder: (ctx, i)=> GestureDetector(
                onTap: (){
                  setState(() {
                      picked = true;
                      at = i;
                    });
                  var category = menuList[i];
                  context.read<BookBloc>().add(LoadByCategoryEvent(category: category));
                  Navigator.of(context).pop();
                }, 
                child: SizedBox(
                          height: size.height*0.1,
                          child: Text(
                                      menuList[i],
                                      style: picked && i==at ? 
                                                    Theme.of(context)
                                                      .textTheme
                                                      .headline4!
                                                      .copyWith(
                                                        fontWeight: FontWeight.w500,
                                                        color: Theme.of(context).primaryColor,
                                                      ) 
                                                    : Theme.of(context)
                                                    .textTheme
                                                    .headline5!
                                                    .copyWith(
                                                      fontWeight: FontWeight.w200,
                                                      color: Theme.of(context).hintColor,
                                                    ),
                                      textAlign: TextAlign.center,
                                  ),
                )
              ),
              itemCount: menuList.length,
            ),
    );
  } 
}


class BookSection extends StatelessWidget {
  final String heading;
  final List bookList;
  const BookSection({Key? key, required this.heading, required this.bookList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: Theme.of(context)
                      .textTheme
                      .headline3
                      ,
        ),
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 5,
          ),
          height: size.height*0.35,
          child: ListView.builder(
            itemBuilder: (ctx, i)=> GestureDetector(
              onTap: (){
                var book = bookList[i];
                context.read<DetailsBloc>().add(LoadDetailsEvent(book: book));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value( //not automatically close the instance when navigate to detail screen
                      value: BlocProvider.of<DetailsBloc>(context),
                      child: BookDetails()
                  ),
                ));
              }, 
              child: Row(
                children: [
                  Container(
                        margin: const EdgeInsets.only(
                          left: 10,
                        ),
                        width: size.width * 0.3,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  bookList[i].cover,
                                  height: size.height*0.225
                                ),
                              ),       
                              const SizedBox(height: 10),
                              Text(
                                bookList[i].title,
                                style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      !.copyWith(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 13
                                      ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                bookList[i].author,
                                style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      !.copyWith(
                                        fontWeight: FontWeight.w100,
                                        color: Theme.of(context).hintColor,
                                        fontSize: 10
                                      ),
                              ),
                            ],
                        ),
                      ),
                ],
              ),
            ),
            itemCount: bookList.length,
            scrollDirection: Axis.horizontal,
          ),
        )
      ],
    );
  }
}

class BookSectionDisplayAll extends StatelessWidget {
  final String heading;
  final List bookList;
  const BookSectionDisplayAll({Key? key, required this.heading, required this.bookList}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: Theme.of(context)
                      .textTheme
                      .headline3
                      ,
        ),
        Container(
          margin: const EdgeInsets.symmetric(
            horizontal: 5,
            vertical: 5
          ),
          height: size.height,
          child: GridView.builder(
              itemBuilder: (ctx, i)=> GestureDetector(
                onTap: (){
                  var book = bookList[i];
                  context.read<DetailsBloc>().add(LoadDetailsEvent(book: book));
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value( //not automatically close the instance when navigate to detail screen
                        value: BlocProvider.of<DetailsBloc>(context),
                        child: BookDetails()
                    ),
                  ));
                }, 
                child: Row(
                  children: [
                    SizedBox(
                          height: size.height*0.35,
                          width: size.width * 0.3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  bookList[i].cover,
                                  height: size.height*0.225
                                ),
                              ),       
                              const SizedBox(height: 10),
                              Text(
                                bookList[i].title,
                                style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      !.copyWith(
                                        fontWeight: FontWeight.w100,
                                        fontSize: 13
                                      ),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              Text(
                                bookList[i].author,
                                style: Theme.of(context)
                                      .textTheme
                                      .headline6
                                      !.copyWith(
                                        fontWeight: FontWeight.w100,
                                        color: Theme.of(context).hintColor,
                                        fontSize: 10
                                      ),
                              ),
                            ],
                          ),
                        ),
                  ],
                ),
              ),
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: bookList.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 0.47),
            ),
          ),
      ],
    );
  }
}