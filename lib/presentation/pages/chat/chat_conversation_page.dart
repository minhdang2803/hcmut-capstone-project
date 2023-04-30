import 'dart:io';

import 'package:bke/bloc/chat/chat_cubit.dart';
import 'package:bke/presentation/pages/chat/chat_member_info.dart';
import 'package:bke/presentation/pages/chat/message_title.dart';
import 'package:bke/presentation/routes/route_name.dart';
import 'package:bke/presentation/theme/app_color.dart';
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
  ScrollController controllerListView = ScrollController();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().getChats(
          groupId: widget.chatGroupId,
          uid: FirebaseAuth.instance.currentUser!.uid,
        );
  }

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
                    topRight: Radius.circular(20.r),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(child: _buildChat(context)),
                      _buildSendBar(context),
                    ]),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChat(BuildContext context) {
    return BlocConsumer<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state.chattingStatus == ChatInProcessStatus.ready) {
          WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
            controllerListView.animateTo(
                controllerListView.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear);
          });
        }
      },
      builder: (context, state) {
        if (state.chattingStatus == ChatInProcessStatus.ready) {
          return StreamBuilder(
            stream: state.chatStream,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                context
                    .read<ChatCubit>()
                    .updateChatlength(snapshot.data.docs.length);
                return ListView.separated(
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  shrinkWrap: true,
                  controller: controllerListView,
                  itemBuilder: (context, index) {
                    final data = snapshot.data.docs[index];
                    final userName =
                        FirebaseAuth.instance.currentUser!.displayName;
                    return MessageTitle(
                        message: data['message'],
                        sender: data['sender'],
                        sendByMe: userName == data['sender'],
                        time: data['time']);
                  },
                  separatorBuilder: (context, index) => 10.verticalSpace,
                  itemCount: snapshot.data.docs.length,
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(color: AppColor.secondary),
                );
              }
            },
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(color: AppColor.secondary),
          );
        }
      },
    );
  }

  Widget _buildSendBar(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.fromLTRB(10.r, 10.r, 10.r, Platform.isIOS ? 20.r : 10.r),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.transparent,
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
                        context.read<ChatCubit>().sendMessage(
                          groupId: state.groupId!,
                          chatMessageData: {
                            "message": controller.text,
                            "sender":
                                FirebaseAuth.instance.currentUser!.displayName,
                            "time": DateTime.now().millisecondsSinceEpoch
                          },
                        );
                        controller.clear();
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
    );
  }
}
