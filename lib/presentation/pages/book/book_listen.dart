// ignore_for_file: prefer_const_constructors

import 'dart:ui';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/utils/log_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../../data/models/book/book_listener.dart';

import '../../../bloc/book/book_bloc.dart';
import '../../../bloc/book/book_state.dart';
import '../../../bloc/book/book_event.dart';


class BookListen extends StatefulWidget {
  const BookListen({super.key, required this.bookInfo});
  final BookArguments bookInfo; 

  @override
  State<BookListen> createState() => _BookListen();
}
class _BookListen extends State<BookListen> {
  final audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  bool _isLoaded = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  late final BookListener _audioBook;
  late final BookBloc _bookBloc;

  @override
  void initState() {
    super.initState();
    _bookBloc = BookBloc();
    _bookBloc.add(LoadAudioBookEvent(bookId: widget.bookInfo.bookId));

    audioPlayer.onPlayerStateChanged.listen((state) {
      if (mounted){
        setState(() {
          _isPlaying = state == PlayerState.playing;
        });
      }
    });
    audioPlayer.onDurationChanged.listen((newDuration) { 
      if (mounted){
        setState(() {
          _duration = newDuration;
        });
      }
    });
    audioPlayer.onPositionChanged.listen((newPosition) {
      if (mounted){
        setState(() {
        _position = newPosition;
        if (_position.inSeconds%30==0){
        _bookBloc.add(UpdateCkptEvent(bookId: widget.bookInfo.id, ckpt: _position.inSeconds.toInt(), isEbook: false));
        }
        });
      }
    });  

  }

  void setAudioBook(state) async{
    _audioBook = state.book;   
    
    _position = Duration(seconds: _audioBook.ckpt);
    await audioPlayer.play(UrlSource(widget.bookInfo.mp3Url!), position: _position);
    await audioPlayer.seek(_position);
    
    _isLoaded = true;
    
  }
    


  @override
  void dispose(){
    audioPlayer.dispose();
    _bookBloc.close();
    super.dispose();
  }  


  @override
  Widget build(BuildContext context) {
    Size size =  MediaQuery.of(context).size;

    return BlocProvider(
              create: (context) => _bookBloc,
              child:
                BlocBuilder<BookBloc, BookState>(
                  builder: (context, state) {
                    
                    if (state is AudioBookLoadedState){ 
                      
                      if (_isLoaded == false){
                        setAudioBook(state);
                      }
                        return Scaffold(
                          
                          body: Container(
                              height: size.height,
                              width: size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(image: NetworkImage(widget.bookInfo.coverUrl!), fit: BoxFit.cover),
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
                                                    widget.bookInfo.coverUrl!,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ),
                                              ),
                                              
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Expanded(
                                          child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color:  AppColor.appBackground,
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
                                                Text(
                                                  widget.bookInfo.title!,
                                                  style: TextStyle(
                                                    fontSize: 25,
                                                    color:  AppColor.textPrimary,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                  textAlign: TextAlign.center
                                                ),
                                                Column(
                                                  children: [
                                                    Slider(
                                                      min: 0,
                                                      max: _duration.inSeconds.toDouble(),
                                                      value:  _duration !=  Duration.zero ? _position.inSeconds.toDouble() : 0.0 ,
                                                      activeColor: AppColor.primary,
                                                      onChanged: (value) async{
                                                        if (_isLoaded){
                                                          final position = Duration(seconds: value.toInt());
                                                          await audioPlayer.seek(position);
                                                        }
                                                      },
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    _isLoaded? Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        (_position.inSeconds % 60) > 9 ? Text("${_position.inMinutes.toString()}:${(_position.inSeconds % 60).toString()}") 
                                                                                      : Text("${_position.inMinutes.toString()}:0${(_position.inSeconds % 60).toString()}"),
                                                        ((_duration-_position).inSeconds % 60) > 9 ? Text("${(_duration-_position).inMinutes.toString()}:${((_duration-_position).inSeconds % 60).toString()}") 
                                                                                      : Text("${(_duration-_position).inMinutes.toString()}:0${((_duration-_position).inSeconds % 60).toString()}")
                                                      ],
                                                    ) : 
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment.spaceBetween,
                                                        children: const [Text("0:00"), Text("0:00")]
                                                      )
                                                  ],
                                                ),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                  children: [ 
                                                    IconButton(
                                                      icon: Icon(
                                                        Icons.skip_previous,
                                                        color:  AppColor.primary,
                                                        size: 38,
                                                      ),
                                                      onPressed: () async{
                                                          if (_isLoaded){
                                                            int newSec = _position.inSeconds -15;
                                                            if (newSec < 0){
                                                              newSec = 0;
                                                            }
                                                            final position = Duration(seconds: newSec);
                                                            
                                                            await audioPlayer.seek(position);
                                                        }
                                                      }
                                                    ),
                                                    Container(
                                                      height: size.height*0.06,
                                                      width: size.height*0.06,
                                  
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color:  AppColor.primary,
                                                      ),
                                                      child: IconButton(
                                                        icon: Icon(
                                                          _isPlaying ? Icons.pause : Icons.play_arrow,
                                                          color:  AppColor.appBackground,
                                                          size: 38,
                                                        ),
                                                        onPressed: () async{
                                                          if (_isPlaying){
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
                                                        color:  AppColor.primary,
                                                        size: 38,
                                                      ),
                                                      onPressed: () async{
                                                          if (_isLoaded){
                                                            int newSec = _position.inSeconds + 15;
                                                            if (newSec > _duration.inSeconds){
                                                              newSec = _duration.inSeconds;
                                                            }
                                                            final position = Duration(seconds: newSec);
                                                            
                                                            await audioPlayer.seek(position);
                                                        }
                                                      }
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
                                    child: CircularProgressIndicator(color: AppColor.primary)
                                  );
                      }
            )
  
      );
    }
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
                  color: AppColor.appBackground,
                  size: 24,
                ),
                onPressed: () => Navigator.pop(context),
              ),IconButton(
                icon: Icon(
                  Icons.more_horiz,
                  color: AppColor.appBackground,
                  size: 24,
                ),
                onPressed: () {},
              )
            ],
          ),
        );
}


