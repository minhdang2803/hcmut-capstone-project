import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/book/book_bloc.dart';
import '../../../../bloc/book/book_event.dart';
import '../../../../bloc/book/book_state.dart';

class LikeButton extends StatefulWidget {
  const LikeButton({super.key, required this.isLiked, required this.id});
  final bool isLiked;
  final String id;
  @override
  LikeButtonState createState() => LikeButtonState();
}

class LikeButtonState extends State<LikeButton> {
  late bool _isLiked;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookBloc, BookState>(builder: (context, state) {
      if (state is BookLoadedState) {
        return IconButton(
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: Colors.white,
          ),
          onPressed: () {
            setState(() {
              _isLiked = !_isLiked;
              _isLiked
                  ? context
                      .read<BookBloc>()
                      .add(AddFavoriteEvent(bookId: widget.id))
                  : context
                      .read<BookBloc>()
                      .add(RemoveFavoriteEvent(bookId: widget.id));
            });
          },
        );
      }
      return const Icon(
        Icons.favorite_border,
        color: Colors.white,
      );
    });
  }
}
