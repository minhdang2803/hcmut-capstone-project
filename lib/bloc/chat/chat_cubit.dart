import 'dart:math';

import 'package:bke/data/models/network/cvn_exception.dart';
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

  void removeRoomInfo() {
    emit(state.copyWith(groupId: null, groupName: null, admin: null));
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
      emit(state.copyWith(
          updatingDataStatus: ChatGetDataStatus.fail,
          errorMessage: error.toString()));
    }
  }

  Future<void> seachChat(String groupName) async {
    try {
      emit(state.copyWith(chatSearchStatus: ChatSearchStatus.loading));
      final response = await instance.searchSearch(groupName);
      emit(state.copyWith(
        chatSearchStatus: ChatSearchStatus.done,
        listChatInfo: response,
      ));
    } catch (error) {
      emit(ChatState.initial());
      emit(state.copyWith(
          chatSearchStatus: ChatSearchStatus.fail,
          errorMessage: error.toString()));
    }
  }

  Future<bool> isUserInGroup(
      {required String groupName,
      required String groupId,
      required String userName,
      required String uid}) async {
    return instance.isUserInGroup(
      groupName: groupName,
      groupId: groupId,
      userName: userName,
      uid: uid,
    );
  }

  Future<void> toggleGroupJoin(
      {required String groupId,
      required String userName,
      required String groupName,
      required String uid}) async {
    final response = await instance.toggleGroupJoin(
      groupId: groupId,
      userName: userName,
      groupName: groupName,
      uid: uid,
    );
  }

  void exitSearchPage() {
    emit(state.copyWith(chatSearchStatus: ChatSearchStatus.initial));
  }

  Future<void> checkInGroups({
    required String groupName,
    required String uid,
  }) async {
    emit(state.copyWith(chatSearchStatus: ChatSearchStatus.loading));
    final response =
        await instance.checkInGroups(groupName: groupName, uid: uid);

    emit(state.copyWith(
      isInGroup: response,
      chatSearchStatus: ChatSearchStatus.done,
    ));
  }

  Future<DocumentSnapshot<Object?>> getGroupData(String groupId) async {
    emit(state.copyWith(updatingDataStatus: ChatGetDataStatus.loading));
    final clm = await instance.getGroupData(groupId: groupId);
    emit(state.copyWith(updatingDataStatus: ChatGetDataStatus.done));
    return clm;
  }

  void getChats({required String groupId, required String uid}) {
    emit(state.copyWith(chattingStatus: ChatInProcessStatus.initial));
    final clm = instance.getChats(groupId: groupId, uid: uid);
    emit(
      state.copyWith(
          chattingStatus: ChatInProcessStatus.ready, chatStream: clm),
    );
  }

  void sendMessage(
      {required String groupId,
      required Map<String, dynamic> chatMessageData}) {
    emit(state.copyWith(chattingStatus: ChatInProcessStatus.sending));
    instance.sendMessage(
      groupId: groupId,
      chatMessageData: chatMessageData,
    );
    emit(state.copyWith(chattingStatus: ChatInProcessStatus.sendingDone));
    emit(state.copyWith(chattingStatus: ChatInProcessStatus.ready));
  }

  void updateChatlength(int length) {
    emit(state.copyWith(chatLength: length));
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
