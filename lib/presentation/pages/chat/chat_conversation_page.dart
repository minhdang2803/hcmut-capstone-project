import 'package:bke/bloc/chat/chat_cubit.dart';
import 'package:bke/presentation/pages/chat/chat_member_info.dart';
import 'package:bke/presentation/pages/chat/message_title.dart';
import 'package:bke/presentation/routes/route_name.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/widgets/custom_app_bar.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

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
  final controller = TextEditingController();
  final itemListener = ItemPositionsListener.create();
  final ItemScrollController itemScrollController = ItemScrollController();
  @override
  void initState() {
    controllerListView.addListener(() {
      _scrollDown();
    });
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ChatConversationPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _scrollDown();
  }

  final controllerListView = ScrollController();
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
                    groupId: widget.chatGroupId,
                    context: context,
                  ),
                ),
              ),
              onBackButtonPress: () {
                context.read<ChatCubit>().removeRoomInfo();
                Navigator.pop(context);
              },
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
                  child: Column(children: [
                    Expanded(child: _buildChat(context)),
                    _buildSendBar(context),
                  ])),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChat(BuildContext context) {
    return StreamBuilder(
      stream: context.read<ChatCubit>().getChats(
            groupId: widget.chatGroupId,
            uid: FirebaseAuth.instance.currentUser!.uid,
          ),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData) {
          context.read<ChatCubit>().updateChatlength(snapshot.data.docs.length);
        }
        return Visibility(
          visible: snapshot.hasData,
          replacement: const SizedBox.shrink(),
          child: ListView.separated(
            controller: controllerListView,
            itemBuilder: (context, index) {
              final data = snapshot.data.docs[index];
              final userName = FirebaseAuth.instance.currentUser!.displayName;
              return MessageTitle(
                message: data['message'],
                sender: data['sender'],
                sendByMe: userName == data['sender'],
              );
            },
            separatorBuilder: (context, index) => 10.verticalSpace,
            itemCount: snapshot.data.docs.length,
          ),
        );
      },
    );
  }

  Widget _buildSendBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 15, 10, 30),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Expanded(
                  child: ChatTextField(
                controller: controller,
                onSubmitted: (value) {},
              )),
              BlocBuilder<ChatCubit, ChatState>(
                builder: (context, state) {
                  return IconButton(
                      onPressed: () {
                        if (controller.text.isNotEmpty) {
                          Map<String, dynamic> chatMessage = {
                            "message": controller.text,
                            "sender":
                                FirebaseAuth.instance.currentUser!.displayName,
                            "time": DateTime.now().millisecondsSinceEpoch
                          };
                          context.read<ChatCubit>().sendMessage(
                                groupId: state.groupId!,
                                chatMessageData: chatMessage,
                              );
                          controller.clear();
                          controllerListView.jumpTo(
                            controllerListView.position.maxScrollExtent,
                          );
                          setState(() {});
                        }
                      },
                      icon: const Icon(
                        Icons.send,
                        size: 25,
                      ));
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  void _scrollDown() {
    if (controllerListView.offset <
        controllerListView.position.maxScrollExtent) {
      controllerListView.jumpTo(
        controllerListView.position.maxScrollExtent,
      );
    }
  }
}
