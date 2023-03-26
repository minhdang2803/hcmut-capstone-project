import 'package:flutter/material.dart';
import '../../theme/app_color.dart';
import '../../widgets/custom_app_bar.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      body: SafeArea(
        bottom: false,
        child: Container(
          color: AppColor.primary,
          child: Column(
            children: [
              BkEAppBar(
                label: 'Trò chuyện',
                onBackButtonPress: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
