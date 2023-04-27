import 'package:auto_size_text/auto_size_text.dart';
import 'package:bke/bloc/chat/chat_cubit.dart';
import 'package:bke/presentation/theme/app_color.dart';
import 'package:bke/presentation/theme/app_typography.dart';
import 'package:bke/presentation/widgets/custom_app_bar.dart';
import 'package:bke/presentation/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatMemberInfoParam {
  ChatMemberInfoParam({required this.context, required this.chatName});
  final BuildContext context;
  final String chatName;
}

class ChatMemberInfo extends StatelessWidget {
  const ChatMemberInfo({super.key, required this.chatName});

  final String chatName;
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
              label: "$chatName's Infomation",
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
                  child: _buildMainUi(context)),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildMainUi(BuildContext context) {
    return Column(
      children: [
        _buildGroupInfo(context),
        5.verticalSpace,
        Expanded(child: _buildMemberList(context)),
      ],
    );
  }

  Widget _buildMemberList(BuildContext context) {
    final cubit = context.read<ChatCubit>();
    return BlocBuilder<ChatCubit, ChatState>(builder: (context, state) {
      return StreamBuilder(
        stream: cubit.getMembers(groupId: state.groupId!),
        builder: (context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppColor.secondary,
              ),
            );
          } else if (snapshot.hasError) {
            return EmptyWidget(paddingHeight: 100.r, text: "Xảy ra lỗi gì đó!");
          } else {
            if (snapshot.data!['members'] == null) {
              return EmptyWidget(
                  paddingHeight: 100.r, text: "Xảy ra lỗi gì đó!");
            }
            if (snapshot.data!['members'].length == 0) {
              return EmptyWidget(
                paddingHeight: 100.r,
                text: "Không có thành viên nào!",
              );
            }
          }
          return ListView.separated(
            itemBuilder: (context, index) {
              final name = snapshot.data!['members'][index]
                  .substring(snapshot.data!['members'][index].indexOf("_") + 1);
              final id = snapshot.data!['members'][index]
                  .substring(0, snapshot.data!['members'][index].indexOf("_"));
              return InfoCard(memId: id, name: name);
            },
            separatorBuilder: (context, index) => 5.verticalSpace,
            itemCount: snapshot.data!['members'].length,
          );
        },
      );
    });
  }

  Widget _buildGroupInfo(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        color: AppColor.lightGray,
      ),
      padding: EdgeInsets.all(10.r),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColor.mainPink,
            radius: 35,
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                return Text(
                  state.admin!.substring(0, 1).toUpperCase(),
                  style: AppTypography.subHeadline.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                );
              },
            ),
          ),
          20.horizontalSpace,
          BlocBuilder<ChatCubit, ChatState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Group: ${state.groupName!}",
                    style: AppTypography.subHeadline.copyWith(
                      color: AppColor.textPrimary,
                      fontSize: 18.r,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "Admin: ${state.admin!}",
                    style: AppTypography.subHeadline.copyWith(
                        color: AppColor.textSecondary, fontSize: 18.r),
                  ),
                ],
              );
            },
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  const InfoCard({super.key, required this.memId, required this.name});
  final String name;
  final String memId;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.all(10.r),
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColor.mainPink,
            radius: 35,
            child: Text(
              name.substring(0, 1),
              style: AppTypography.subHeadline.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          20.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Member: $name",
                style: AppTypography.subHeadline.copyWith(
                  color: AppColor.textPrimary,
                  fontSize: 18.r,
                  fontWeight: FontWeight.w700,
                ),
              ),
              AutoSizeText("ID: $memId",
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColor.textSecondary,
                  )),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
