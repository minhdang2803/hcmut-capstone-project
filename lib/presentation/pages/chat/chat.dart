import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../theme/app_color.dart';
import '../../widgets/custom_app_bar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.appBackground,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            BkEAppBar(
              label: 'Trò chuyện',
              onBackButtonPress: () => Navigator.pop(context),
            ),
            _buildMainUi(context)
          ],
        ),
      ),
    );
  }

  Widget _buildMainUi(BuildContext context) {
    return Expanded(
        child: ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(30),
      ),
      child: Container(
          color: Colors.white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              10.verticalSpace,
              _buildSearchBar(context),
              20.verticalSpace,
              Expanded(child: _buildChatList(context))
            ],
          )),
    ));
  }

  Widget _buildSearchBar(BuildContext context) {
    return CustomLookupTextField(
      onSubmitted: (value) {
        print("hello");
      },
      hintText: "Tìm nhóm hội thoại",
      controller: searchController,
    );
  }

  Widget _buildChatList(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
            itemBuilder: (context, index) {
              return ChatComponent(
                chatName: "Test chat",
                chatLastMessage: "Hello",
                timeForLastMessage: "10 mins ago",
                onTap: () {
                  print("clm");
                },
              );
            },
            separatorBuilder: (context, index) => 10.verticalSpace,
            itemCount: 10,
          );
        }
      ),
    );
  }
}

class ChatComponent extends StatelessWidget {
  const ChatComponent({
    super.key,
    this.chatAvatar,
    required this.chatLastMessage,
    required this.chatName,
    required this.timeForLastMessage,
    required this.onTap,
  });
  final String? chatAvatar;
  final String chatName;
  final String chatLastMessage;
  final String timeForLastMessage;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColor.defaultBorder.withOpacity(0.25),
            spreadRadius: 0.1,
            blurRadius: 5,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(chatName, style: AppTypography.title),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                timeForLastMessage,
                style: AppTypography.bodySmall,
              ),
            )
          ],
        ),
        leading: chatAvatar != null
            ? Container(
                decoration: BoxDecoration(
                  color: AppColor.accentPink,
                  borderRadius: BorderRadius.circular(360),
                ),
                child: Image.network(
                  chatAvatar!,
                  width: 50,
                  height: 50,
                ),
              )
            : Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColor.accentPink,
                  borderRadius: BorderRadius.circular(360),
                ),
                child: Center(
                  child: Text(
                    chatName[0],
                    style: AppTypography.subHeadline,
                  ),
                ),
              ),
        subtitle: Text(chatLastMessage, style: AppTypography.bodySmall),
      ),
    );
  }
}
