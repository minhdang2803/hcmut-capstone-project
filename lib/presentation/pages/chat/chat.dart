import 'package:bke/bloc/chat/chat_cubit.dart';
import 'package:bke/data/data_source/local/local_sources.dart';
import 'package:bke/presentation/pages/chat/chat_conversation_page.dart';
import 'package:bke/presentation/pages/chat/chat_search_page.dart';
import 'package:bke/presentation/routes/route_name.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import '../../theme/app_color.dart';
import '../../widgets/custom_app_bar.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final searchController = TextEditingController();
  final createGroupController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    createGroupController.dispose();
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
              onSearchButtonPress: () => showSearch(
                  context: context, delegate: ChatSearchPage(context)),
            ),
            _buildMainUi(context)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.accentBlue,
        onPressed: () => _addGroup(context),
        // backgroundColor: AppColor.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
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
              // 10.verticalSpace,
              // _buildSearchBar(context),
              20.verticalSpace,
              Expanded(child: _buildChatList(context))
            ],
          )),
    ));
  }

  // Widget _buildSearchBar(BuildContext context) {
  //   return CustomLookupTextField(
  //     onSubmitted: (value) {
  //       showSearch(context: context, delegate: ChatSearchPage());
  //     },
  //     hintText: "Tìm nhóm hội thoại",
  //     controller: searchController,
  //   );
  // }

  Widget _buildChatList(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: StreamBuilder<Object>(
          stream: context
              .read<ChatCubit>()
              .getChatList(FirebaseAuth.instance.currentUser!.uid),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColor.secondary,
                ),
              );
            } else if (snapshot.hasError) {
              return EmptyWidget(
                  paddingHeight: 100.r, text: "Xảy ra lỗi gì đó!");
            } else {
              if (snapshot.data['groups'] == null) {
                return EmptyWidget(
                    paddingHeight: 100.r, text: "Xảy ra lỗi gì đó!");
              }
              if (snapshot.data['groups'].length == 0) {
                return EmptyWidget(
                    paddingHeight: 100.r,
                    text: "Không có nhóm trò chuyện nào!");
              }
              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
                itemBuilder: (context, index) {
                  int indexReverse =
                      snapshot.data['groups']!.length - index - 1;

                  final current = snapshot.data['groups'][indexReverse];
                  return ChatComponent(
                    chatName: context.read<ChatCubit>().getName(current),
                    chatLastMessage: "Hello",
                    timeForLastMessage: "10 mins ago",
                    onTap: () {
                      context.read<ChatCubit>().getGroupInfo(current);
                      Navigator.pushNamed(
                        context,
                        RouteName.chatConversation,
                        arguments: ChatConversationParam(
                          chatName: context.read<ChatCubit>().getName(current),
                          chatGroupId:
                              context.read<ChatCubit>().getGroupId(current),
                          context: context,
                        ),
                      );
                    },
                  );
                },
                separatorBuilder: (context, index) => 10.verticalSpace,
                itemCount: snapshot.data['groups'].length,
              );
            }
          }),
    );
  }

  void _addGroup(BuildContext context) {
    final cubit = context.read<ChatCubit>();
    showDialog(
      context: context,
      builder: (clm) {
        return AlertDialog(
          title: Text(
            "Tạo nhóm trò chuyện",
            style: AppTypography.title.copyWith(fontWeight: FontWeight.w700),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              20.r,
            ),
          ),
          content: CustomTextField(
            controller: createGroupController,
            borderRadius: 30.r,
          ),
          actions: [
            ValueListenableBuilder<TextEditingValue>(
              valueListenable: createGroupController,
              builder: (context, value, child) {
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.secondary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r)),
                  ),
                  onPressed: value.text.isEmpty
                      ? null
                      : () {
                          final getIt = GetIt.I.get<AuthLocalSourceImpl>();
                          final userBox = getIt.getCurrentUser();
                          cubit.createGroup(
                            userName: userBox!.fullName!,
                            uid: FirebaseAuth.instance.currentUser!.uid,
                            groupName: value.text,
                            groupIcon: "",
                          );
                          createGroupController.clear();
                          Navigator.pop(context);
                        },
                  child: Text(
                    "Tạo nhóm",
                    style: AppTypography.body.copyWith(
                      color: AppColor.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                );
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColor.secondary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.r)),
              ),
              onPressed: () {
                createGroupController.clear();
                Navigator.pop(context);
              },
              child: Text(
                "Huỷ",
                style: AppTypography.body.copyWith(
                  color: AppColor.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        );
      },
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
            spreadRadius: 1,
            offset: const Offset(0, 1), // changes position of shadow
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
                child: Image.asset(
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
                    style:
                        AppTypography.subHeadline.copyWith(color: Colors.white),
                  ),
                ),
              ),
        subtitle: Text(chatLastMessage, style: AppTypography.bodySmall),
      ),
    );
  }
}
