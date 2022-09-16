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
                                          padding: EdgeInsets.symmetric(
                                            vertical: 30,
                                            horizontal: 20,
                                          ),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              IconButton(
                                                icon: Icon(
                                                  Icons.arrow_back,
                                                  color: Colors.black,
                                                  size: 35,
                                                ),
                                                onPressed: () => Navigator.of(context).pop(),
                                              ),
                                              IconButton(
                                                icon: Icon(
                                                  Icons.favorite_border,
                                                  color: Colors.black,
                                                  size: 35,
                                                ),
                                                onPressed: () {},
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(
                                            bottom: 30,
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
                                        Text(
                                          book.title,
                                          style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          book.author,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
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
                                Positioned(
                                  bottom: 0,
                                  child: Container(
                                    height: MediaQuery.of(context).size.height * 0.15,
                                    width: MediaQuery.of(context).size.width,
                                    
                                    child: Center(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 100,
                                            height: 50,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
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
                                              child: Text(
                                                "READ",
                                                style: TextStyle(
                                                  color:Theme.of(context).backgroundColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Container(
                                            width: 100,
                                            height: 50,
                                            padding: EdgeInsets.symmetric(
                                              vertical: 4,
                                            ),
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
                                              child: Text(
                                                "LISTEN",
                                                style: TextStyle(
                                                  color: Theme.of(context).backgroundColor,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
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
