import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math';
import 'book_event.dart';
import 'book_state.dart';
import 'books_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';
import '../../models/book_model.dart';

class BookListen extends StatefulWidget {
  const BookListen({Key? key}) : super(key: key);

  @override
  State<BookListen> createState() => _BookListen();
}
class _BookListen extends State<BookListen> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState(){
    super.initState();

    setAudio();

    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted){
        setState(() {
          isPlaying = state == PlayerState.playing;
        });
      }
    });
    audioPlayer.onDurationChanged.listen((newDuration) { 
      if (mounted){
        setState(() {
          duration = newDuration;
        });
      }
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted){
        setState(() {
          duration = newPosition;
        });
      }
    });
  }

  Future setAudio() async{
    audioPlayer.setSourceAsset('books_screen/002.mp3');
  }


  @override
  void dispose(){
    audioPlayer.dispose();
    super.dispose();
  }  


  @override
  Widget build(BuildContext context) {
    Size size =  MediaQuery.of(context).size;
 
    return BlocBuilder<DetailsBloc, DetailsState>(
          builder: (context, state) {
            if (state is DetailsLoadedState){ 
              BookModel book = state.book;
              return  Scaffold(
                body: Container(
                    height: size.height,
                    width: size.width,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(book.cover), fit: BoxFit.cover),
                    ),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 5,
                        sigmaY: 5,
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.black.withOpacity(0.1),
                        child: SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              appBar(context),
                              Container(
                                margin: const EdgeInsets.only(
                                  bottom: 20,
                                ),
                                height: size.height * 0.4,
                                width: size.width * 0.53,
                                child: Stack(
                                  children: [
                                    SizedBox(
                                      width: double.infinity,
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
                                  fontSize: 25,
                                  color:  Theme.of(context).backgroundColor,
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center
                              ),
                             
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                book.author,
                                style: TextStyle(
                                  fontSize: 20,
                                  color:  Theme.of(context).backgroundColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color:  Theme.of(context).backgroundColor,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(50),
                                      topRight: Radius.circular(50),
                                    ),
                                  ),
                                  padding: const EdgeInsets.only(
                                    left: 30,
                                    right: 30,
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        "Chapter 1",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Slider(
                                            min: 0,
                                            max: duration.inSeconds.toDouble(),
                                            value: position.inSeconds.toDouble(),
                                            activeColor: Theme.of(context).primaryColor,
                                            onChanged: (value) async{
                                              final position = Duration(seconds: value.toInt());
                                              await audioPlayer.seek(position);
                                            },
                                          ),
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              (position.inSeconds % 60) > 9 ? Text("${position.inMinutes.toString()}:${(position.inSeconds % 60).toString()}") 
                                                                            : Text("${position.inMinutes.toString()}:0${(position.inSeconds % 60).toString()}"),
                                              ((duration-position).inSeconds % 60) > 9 ? Text("${(duration-position).inMinutes.toString()}:${((duration-position).inSeconds % 60).toString()}") 
                                                                            : Text("${(duration-position).inMinutes.toString()}:0${((duration-position).inSeconds % 60).toString()}")
                                            ],
                                          ),
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.menu,
                                              color:   Theme.of(context).primaryColor,
                                              size: 32,
                                            ),
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.skip_previous,
                                              color:  Theme.of(context).primaryColor,
                                              size: 38,
                                            ),
                                            onPressed: () {},
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                              bottom: 16,
                                              right: 15,
                                            ),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:  Theme.of(context).primaryColor,
                                            ),
                                            child: IconButton(
                                              icon: Icon(
                                                isPlaying ? Icons.pause : Icons.play_arrow,
                                                color:  Theme.of(context).backgroundColor,
                                                size: 48,
                                              ),
                                              onPressed: () async{
                                                if (isPlaying){
                                                  await audioPlayer.pause();
                                                }
                                                else{
                                                  await audioPlayer.resume();
                                                }
                                              },
                                            ),
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.skip_next,
                                              color:  Theme.of(context).primaryColor,
                                              size: 38,
                                            ),
                                            onPressed: () {},
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.more_horiz,
                                              color:  Theme.of(context).primaryColor,
                                              size: 32,
                                            ),
                                            onPressed: () {},
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
              );
            }

            return Center(
                            child: CircularProgressIndicator(color: Theme.of(context).primaryColor)
                          );
      }
    );
  }

  Widget appBar(BuildContext context){
    return Padding(
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
                            Icons.favorite_border,
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

