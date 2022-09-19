// ignore_for_file: prefer_const_constructors

import 'package:capstone_project_hcmut/data/repository/book_repos.dart';
import 'package:flutter/material.dart';
// import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'book_event.dart';
import 'book_state.dart';
import 'books_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import '../../models/book_model.dart';

class BookDetails extends StatelessWidget {
  const BookDetails({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
          child: BlocBuilder<DetailsBloc, DetailsState>(
                builder: (context, state) {
                  if (state is DetailsLoadedState){ 
                    BookModel book = state.book;
                    return Scaffold(
                          backgroundColor: Theme.of(context).backgroundColor,
                          body: Container(
                            height: size.height,
                            width: size.width,
                            child: Stack(
                              children: [
                                SafeArea(
                                  child: Container(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.arrow_back,
                                                  color: Theme.of(context).primaryColor,
                                                  size: 35,
                                                ),
                                                onPressed: () => Navigator.of(context).pop(),
                                              ),
                                              Container(
                                                child: Row(
                                                        children: [
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.favorite_border,
                                                              color: Theme.of(context).primaryColor,
                                                              size: 35,
                                                            ),
                                                            onPressed: () {},
                                                          ),
                                                          IconButton(
                                                            icon: Icon(
                                                              Icons.share,
                                                              color: Theme.of(context).primaryColor,
                                                              size: 35,
                                                            ),
                                                            onPressed: () {},
                                                          ),
                                                        ]
                                                      )
                                              )    
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Container(
                                                margin: EdgeInsets.only(
                                                  bottom: 10,
                                                ),
                                                height: size.height * 0.3,
                                                width: size.width * 0.4,
                                                child: Stack(
                                                  children: [
                                                    Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                        boxShadow: <BoxShadow>[
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.3),
                                                            blurRadius: 5,
                                                            offset: Offset(8, 8),
                                                            spreadRadius: 3,
                                                          ),
                                                          BoxShadow(
                                                            color: Colors.black.withOpacity(0.3),
                                                            blurRadius: 25,
                                                            offset: Offset(-8, -8),
                                                            spreadRadius: 3,
                                                          )
                                                        ],
                                                      ),
                                                      child: ClipRRect(
                                                        borderRadius: BorderRadius.circular(20),
                                                        child: Image.network(
                                                                  book.cover,
                                                                  fit: BoxFit.fill,
                                                                ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                    left: 12,
                                                ),
                                                width: size.width * 0.5,
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      book.title,
                                                      style: Theme.of(context)
                                                        .textTheme
                                                        .headline3
                                                        ,
                                                    ),
                                                    SizedBox(
                                                      height: 8,
                                                    ),
                                                    Text(
                                                      book.author,
                                                      style: Theme.of(context)
                                                        .textTheme
                                                        .headline6!
                                                        .copyWith(
                                                          fontWeight: FontWeight.normal,
                                                          color: Theme.of(context).hintColor,
                                                        ),
                                                    ),
                                                    Row(
                                                      children: [
                                                        // SmoothStarRating(
                                                        //   rating: 3,
                                                        //   // bookList[index].rating
                                                        //   isReadOnly: false,
                                                        //   size: 25,
                                                        //   filledIconData: Icons.star,
                                                        //   halfFilledIconData: Icons.star_half,
                                                        //   defaultIconData: Icons.star_border,
                                                        //   starCount: 5,
                                                        //   allowHalfRating: true,
                                                        //   spacing: 2.0,
                                                        //   // onRated: (value) {
                                                        //   //   print(value);
                                                        //   // },
                                                        // ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Text(
                                                          book.rating.toString(),
                                                          style: TextStyle(
                                                            fontSize: 24,
                                                            fontWeight: FontWeight.w700,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                    SizedBox(height: 10),
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 80,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(100),
                                                            color: Theme.of(context).primaryColor,
                                                          ),
                                                          child: TextButton(
                                                            
                                                            onPressed: () {},//=>Navigator.push(
                                                            //   context,
                                                            //   MaterialPageRoute(
                                                            //     builder: (context) => BookRead(),
                                                            //   ),
                                                            // ),
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons.book,
                                                                  size: 20,
                                                                  color: Theme.of(context).backgroundColor),
                                                                Text(
                                                                  "Read",
                                                                  style: TextStyle(
                                                                    color:Theme.of(context).backgroundColor,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 15,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: 10,
                                                        ),
                                                        Container(
                                                          width: 80,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(100),
                                                            color: Theme.of(context).primaryColor,
                                                          ),
                                                          child: TextButton(
                                                            onPressed: () {},//=> Navigator.push(
                                                              // context,
                                                              // MaterialPageRoute(
                                                              //   builder: (context) => BookListen(
                                                            //       index: index,
                                                            //       section: section,
                                                            //     ),
                                                            //   ),
                                                            // ),
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons.headphones,
                                                                  size: 20,
                                                                  color: Theme.of(context).backgroundColor),
                                                                Text(
                                                                  "Listen",
                                                                  style: TextStyle(
                                                                    color: Theme.of(context).backgroundColor,
                                                                    fontWeight: FontWeight.w500,
                                                                    fontSize: 15,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        Container(
                                          margin: EdgeInsets.all(2),
                                          height: 8,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).primaryColor,
                                            borderRadius: BorderRadius.circular(100),
                                          ),
                                        ),

                                        Expanded(
                                          child: Container(
                                              padding: EdgeInsets.only(
                                                left: 40,
                                                right: 20,
                                              ),
                                              child: Text(
                                                book.description,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  height: 1.5,
                                                ),
                                              ),
                                            ),
                                          
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      return Center(
                                  child: CircularProgressIndicator(color: Theme.of(context).primaryColor)
                                );
                    }
                  ),
            );
      }
    }
