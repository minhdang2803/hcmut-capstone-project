import 'dart:ffi';

import 'package:bke/bloc/chat/chat_cubit.dart';
import 'package:bke/data/data_source/remote/chat/chat_local_source.dart';
import 'package:bke/data/models/chat/chat_group_info_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRepository {
  late final ChatSource _remote;
  ChatRepository._internal() {
    _remote = ChatSourceImpl();
  }
  static final _instance = ChatRepository._internal();
  factory ChatRepository.instance() => _instance;

  Stream<DocumentSnapshot<Object?>> getUserGroups(uid) {
    return _remote.getUserGroups(uid);
  }

  Future<void> updateUserData({
    required String fullName,
    required String email,
    required String userUID,
  }) {
    return _remote.updateUserData(
      fullName: fullName,
      email: email,
      userUID: userUID,
    );
  }

  Future<void> createGroup(
      {required String userName,
      required String uid,
      required String groupName,
      required String? groupIcon}) {
    return _remote.createGroup(
        userName: userName,
        uid: uid,
        groupName: groupName,
        groupIcon: groupIcon);
  }

  Future<dynamic> getGroupAdmin(String groupId) {
    return _remote.getGroupAdmin(groupId: groupId);
  }

  Stream<DocumentSnapshot<Object?>> getMembers({required String groupId}) {
    return _remote.getMembers(groupId: groupId);
  }

  Future<List<ChatInfo>> searchSearch(String groupName) {
    return _remote.searchSearch(groupName);
  }

  Future<bool> isUserInGroup(
      {required String groupName,
      required String groupId,
      required String userName,
      required String uid}) async {
    return _remote.isUserInGroup(
        groupName: groupName, groupId: groupId, userName: userName, uid: uid);
  }

  Future<void> toggleGroupJoin(
      {required String groupId,
      required String userName,
      required String groupName,
      required String uid}) async {
    return _remote.toggleGroupJoin(
        groupId: groupId, userName: userName, groupName: groupName, uid: uid);
  }

  Future<List<bool>> checkInGroups({
    required String groupName,
    required String uid,
  }) async {
    return _remote.checkInGroups(groupName: groupName, uid: uid);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChats(
      {required String groupId, required String uid}) {
    return _remote.getChats(groupId: groupId, uid: uid);
  }

  void sendMessage(
      {required String groupId,
      required Map<String, dynamic> chatMessageData}) async {
    return _remote.sendMessage(
        groupId: groupId, chatMessageData: chatMessageData);
  }

  Future<DocumentSnapshot<Object?>> getGroupData(
      {required String groupId}) async {
    return _remote.getGroupData(groupId: groupId);
  }
}
