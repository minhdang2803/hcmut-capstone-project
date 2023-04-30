import 'package:bke/bloc/chat/chat_cubit.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatSearchPage extends SearchDelegate {
  ChatSearchPage(this.blocContext);
  final BuildContext blocContext;
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            blocContext.read<ChatCubit>().seachChat(query);
            blocContext.read<ChatCubit>().checkInGroups(
                  groupName: query,
                  uid: FirebaseAuth.instance.currentUser!.uid,
                );
            showResults(context);
          },
          icon: Icon(
            Icons.search,
            size: 24.r,
          ))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return BackButton(
      onPressed: () {
        blocContext.read<ChatCubit>().exitSearchPage();
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return BlocProvider.value(
      value: blocContext.read<ChatCubit>(),
      child: BlocBuilder<ChatCubit, ChatState>(
        builder: (context, state) {
          if (state.chatSearchStatus == ChatSearchStatus.loading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColor.secondary),
            );
          }
          return Padding(
            padding: EdgeInsets.all(10.r),
            child: ListView.separated(
              itemBuilder: (context, index) {
                String groupName = state.listChatInfo![index].groupName;
                String groupId = state.listChatInfo![index].groupId;
                String admin = state.listChatInfo![index].admin;
                String userName =
                    FirebaseAuth.instance.currentUser!.displayName!;
                String uid = FirebaseAuth.instance.currentUser!.uid;
                return _buildGroupInfoCard(
                  groupId: groupId,
                  groupName: groupName,
                  uid: uid,
                  userName: userName,
                  admin: admin,
                  context: context,
                  index: index,
                );
              },
              separatorBuilder: (context, index) => 5.verticalSpace,
              itemCount: state.listChatInfo!.length,
            ),
          );
        },
      ),
    );
  }

  Container _buildGroupInfoCard(
      {required BuildContext context,
      required int index,
      required String groupName,
      required String admin,
      required String groupId,
      required String uid,
      required String userName}) {
    return Container(
      decoration: BoxDecoration(
          color: AppColor.lightGray, borderRadius: BorderRadius.circular(20)),
      padding: EdgeInsets.symmetric(horizontal: 10.r, vertical: 10.r),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColor.mainPink,
            radius: 25,
            child: Text(
              groupName.substring(0, 1).toUpperCase(),
              style: AppTypography.subHeadline.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          20.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                groupName,
                style: AppTypography.subHeadline,
              ),
              Text(
                "Admin: $admin",
                style: AppTypography.title,
              ),
            ],
          ),
          const Spacer(),
          TextButton(
              onPressed: () async {
                await context.read<ChatCubit>().toggleGroupJoin(
                      groupId: groupId,
                      userName: userName,
                      groupName: groupName,
                      uid: uid,
                    );
                await context.read<ChatCubit>().checkInGroups(
                      groupName: query,
                      uid: FirebaseAuth.instance.currentUser!.uid,
                    );
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: AppColor.mainPink,
                    borderRadius: BorderRadius.circular(20)),
                child: BlocBuilder<ChatCubit, ChatState>(
                  builder: (context, state) {
                    if (state.chatSearchStatus == ChatSearchStatus.loading) {
                      return const Padding(
                        padding: EdgeInsets.all(10),
                        child: FittedBox(
                          child: SizedBox.square(
                              child: CircularProgressIndicator(
                            color: Colors.white,
                          )),
                        ),
                      );
                    }
                    return Text(
                      state.isInGroup![index] ? "Joined" : "Join",

                      // "join",
                      style: AppTypography.body.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    );
                  },
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: EmptyWidget(
        paddingHeight: 150.r,
        text: "Tìm kiếm nhóm trò truyện",
      ),
    );
  }
}
