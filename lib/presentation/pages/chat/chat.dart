import 'package:flutter/material.dart';
import '../../theme/app_color.dart';
import '../../widgets/cvn_app_bar.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      body: Stack(
        children: const [
          BkEAppBar(label: 'Chat'),
        ],
      ),
    );
  }
}
