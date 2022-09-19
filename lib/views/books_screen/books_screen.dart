// ignore_for_file: prefer_const_constructors

import 'package:capstone_project_hcmut/data/repository/book_repos.dart';
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
    Size size = MediaQuery.of(context).size;
    return RepositoryProvider(
      create:(context) => BookRepos(),
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Column(
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.menu,
                        color: Theme.of(context).backgroundColor,
                        size: 35,
                      ),
                      onPressed: () {},
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
                  padding: EdgeInsets.only(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hello,",
                            style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    ,
                          ),
                          Text(
                                'user',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ,
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
                          const BookSection(
                            heading: "Continue Reading",
                          ),
                          const BookSection(
                            heading: "Discover More",
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
    }
}

class BookSection extends StatelessWidget {
  final String heading;
  const BookSection({Key? key, required this.heading}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // List <BookModel> bookList = allBooks; //to be commented
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => BookBloc(RepositoryProvider.of<BookRepos>(context),)..add(LoadBookEvent())
        ),
        BlocProvider(
          lazy: false,
          create: (context) => DetailsBloc()
        ),
      ],
      child: Container(
            child: BlocBuilder<BookBloc, BookState>(
              builder: (context, state) {
                if (state is BookLoadingState){
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
                          Center(
                            child: CircularProgressIndicator(color: Theme.of(context).primaryColor)
                          )
                        ]
                      );
                }
                if (state is BookLoadedState){
                  List <BookModel> bookList = state.books; 
                  return Container(
                          child: Column(
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
                                  vertical: 20,
                                ),
                                height: size.height*0.4,
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
                                              margin: EdgeInsets.only(
                                                left: 5,
                                              ),
                                              height: size.height * 0.4,
                                              width: size.width * 0.4,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Stack(
                                                    children: [
                                                      Container(
                                                        width: double.infinity,
                                                        height: size.height * 0.3,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(20),
                                                          boxShadow: <BoxShadow>[
                                                            BoxShadow(
                                                              color: Colors.black.withOpacity(0.4),
                                                              blurRadius: 5,
                                                              offset: Offset(8, 8),
                                                              spreadRadius: 1,
                                                            )
                                                          ],
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(20),
                                                          child: Image.network(
                                                            bookList[i].cover,
                                                            fit: BoxFit.fill,
                                                          ),
                                                          
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    bookList[i].title,
                                                    style: Theme.of(context)
                                                          .textTheme
                                                          .headline5,
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    bookList[i].author,
                                                    style: Theme.of(context)
                                                          .textTheme
                                                          .headline6,
                                                  ),
                                                ],
                                              ),
                                            ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                      ],
                                    ),
                                  ),
                                  itemCount: bookList.length,
                                  scrollDirection: Axis.horizontal,
                                ),
                              )
                        ],
                      ),
                    );
                }
                if (state is BookErrorState){
                  return Center(child: Text("Can't not load this content right now"));
                }
                return Container();
              }
            ),
          ),
        );
      }
  }

