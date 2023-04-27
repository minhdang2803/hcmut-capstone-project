import 'dart:math';

import 'package:bke/data/repositories/chat_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatState.initial());
  final instance = ChatRepository.instance();

  Stream<DocumentSnapshot<Object?>> getChatList(uid) {
    return instance.getUserGroups(uid);
  }

  Stream<DocumentSnapshot<Object?>> getMembers({required String groupId}) {
    return instance.getMembers(groupId: groupId);
  }

  void getGroupInfo(String res) async {
    emit(state.copyWith(updatingDataStatus: ChatGetDataStatus.loading));
    final groupName = getName(res);
    final groupAdmin = await instance.getGroupAdmin(getGroupId(res));
    final groupId = getGroupId(res);
    emit(
      state.copyWith(
        updatingDataStatus: ChatGetDataStatus.done,
        groupName: groupName,
        groupId: groupId,
        admin: groupAdmin,
      ),
    );
  }

  String getName(String res) {
    return res.substring(res.indexOf("_") + 1);
  }

  String getGroupId(String res) {
    return res.substring(0, res.indexOf("_"));
  }

  Future<void> createGroup({
    required String userName,
    required String uid,
    required String groupName,
    required String? groupIcon,
  }) async {
    try {
      emit(state.copyWith(updatingDataStatus: ChatGetDataStatus.loading));
      await instance.createGroup(
        userName: userName,
        uid: uid,
        groupName: groupName,
        groupIcon: groupIcon ?? "",
      );
      emit(state.copyWith(updatingDataStatus: ChatGetDataStatus.done));
    } catch (error) {
      emit(ChatState.initial());
      emit(state.copyWith(updatingDataStatus: ChatGetDataStatus.fail));
    }
  }

  List<String> pictures = [
    "assets/images/hi.png",
    "assets/images/full.png",
    "assets/images/proud.png",
    "assets/images/peace.png",
    "assets/images/mocking.png",
    "assets/images/run.png",
    "assets/images/sad.png",
    "assets/images/eat.png",
    "assets/images/love.png",
    "assets/images/yoga.png",
    "assets/images/yawn.png",
    "assets/images/birthday.png",
    "assets/images/relaxed.png",
    "assets/images/no.png",
  ];
}
