import 'package:bke/presentation/pages/chat/chat_member_info.dart';
import 'package:bke/presentation/routes/route_name.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatConversationParam {
  ChatConversationParam({
    required this.chatGroupId,
    required this.context,
    required this.chatName,
  });
  final BuildContext context;
  final String chatName;
  final String chatGroupId;
}

class ChatConversationPage extends StatefulWidget {
  const ChatConversationPage({
    super.key,
    required this.chatGroupId,
    required this.chatName,
  });
  final String chatGroupId;
  final String chatName;
  @override
  State<ChatConversationPage> createState() => _ChatConversationPageState();
}

class _ChatConversationPageState extends State<ChatConversationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            BkEAppBar(
              label: widget.chatName,
              trailing: IconButton(
                icon: const Icon(
                  Icons.info,
                  color: Colors.black,
                ),
                onPressed: () => Navigator.pushNamed(
                  context,
                  RouteName.chatMemberInfo,
                  arguments: ChatMemberInfoParam(
                    chatName: widget.chatName,
                    context: context,
                  ),
                ),
              ),
              onBackButtonPress: () => Navigator.pop(context),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.fromLTRB(10.r, 10.r, 10.r, 0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.r),
                      topRight: Radius.circular(20.r)),
                  color: Colors.white,
                ),
                child: Text(
                  widget.chatGroupId,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
