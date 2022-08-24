import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({Key? key, required this.page}) : super(key: key);
  final String page;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use this if you want each child page to have its own AppBar
      //appBar: AppBar(title: const Text('Feed')),
      body: Center(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.black, // background (button) color
            onPrimary: Colors.white, // foreground (text) color
          ),
          onPressed: () => context.goNamed('person', params: {
            'fid': page,
          }),
          child: const Text('Detail'),
        ),
      ),
    );
  }
}
