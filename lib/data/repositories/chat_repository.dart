import 'dart:ffi';

import 'package:bke/data/data_source/remote/chat/chat_local_source.dart';
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
}
