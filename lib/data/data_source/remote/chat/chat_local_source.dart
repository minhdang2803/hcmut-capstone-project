import 'dart:math';

import 'package:bke/bloc/chat/chat_cubit.dart';
import 'package:bke/utils/share_pref.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ChatSource {
  Stream<DocumentSnapshot<Object?>> getUserGroups(uid);
  Future<void> updateUserData({
    required String fullName,
    required String email,
    required String userUID,
  });
  Future<void> createGroup(
      {required String userName,
      required String uid,
      required String groupName,
      required String? groupIcon});
  Stream<QuerySnapshot<Map<String, dynamic>>> getChats({
    required String groupId,
    required String uid,
  });
  Future<String> getGroupAdmin({required String groupId});
  Stream<DocumentSnapshot<Object?>> getMembers({required String groupId});
  Future<List<ChatInfo>> searchSearch(String groupName);
  Future<bool> isUserInGroup(
      {required String groupName,
      required String groupId,
      required String userName,
      required String uid});
  Future<void> toggleGroupJoin(
      {required String groupId,
      required String userName,
      required String groupName,
      required String uid});
  Future<List<bool>> checkInGroups({
    required String groupName,
    required String uid,
  });
  void sendMessage(
      {required String groupId, required Map<String, dynamic> chatMessageData});
}

class ChatSourceImpl implements ChatSource {
  final sharePref = SharedPrefWrapper.instance();
  //keys
  static String userLoggedInKey = "USERLOGGEDINKEY";
  static String userNameKey = "USERNAMEKEY";
  static String userEmailKey = "USEREMAILKEY";

  //Cloud Firestore services
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference groupCollection =
      FirebaseFirestore.instance.collection("groups");
  //Saving data to Shared Preferences

  @override
  Future<void> updateUserData(
      {required String fullName,
      required String email,
      required String userUID}) async {
    return await userCollection.doc(userUID).set({
      "fullName": fullName,
      "email": email,
      "groups": [],
      "profilePicture": "",
      "uid": userUID,
    });
  }

  // get user groups
  @override
  Stream<DocumentSnapshot<Object?>> getUserGroups(uid) {
    final userGroups = userCollection.doc(uid).snapshots();
    return userGroups;
  }

  @override
  Future<void> createGroup(
      {required String userName,
      required String uid,
      required String groupName,
      required String? groupIcon}) async {
    final data = {
      "groupName": groupName,
      "groupIcon": groupIcon,
      "admin": "${uid}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
      "timeLastMessage": "",
      "timeCreate": DateTime.now().millisecondsSinceEpoch,
    };
    DocumentReference ref = await groupCollection.add(data);

    //update the members
    await ref.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": ref.id,
    });

    DocumentReference userRef = userCollection.doc(uid);
    return await userRef.update({
      "groups": FieldValue.arrayUnion(["${ref.id}_$groupName"])
    });
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getChats({
    required String groupId,
    required String uid,
  }) {
    return groupCollection
        .doc(groupId)
        .collection("messages")
        .orderBy("time")
        .snapshots();
  }

  @override
  Future<String> getGroupAdmin({required String groupId}) async {
    Map<String, dynamic> result = {};
    await groupCollection.doc(groupId).get().then((DocumentSnapshot value) {
      if (value.exists) {
        result = value.data() as Map<String, dynamic>;
      } else {
        result = {};
      }
    });
    return (result['admin'] as String)
        .substring(result['admin'].indexOf("_") + 1);
  }

  @override
  Stream<DocumentSnapshot<Object?>> getMembers({required String groupId}) {
    return groupCollection.doc(groupId).snapshots();
  }

  //search
  Future<List<ChatInfo>> searchSearch(String groupName) async {
    final List<ChatInfo> chatInfos = [];
    final clm =
        await (groupCollection.where("groupName", isEqualTo: groupName).get());
    for (final element in clm.docs) {
      chatInfos.add(
        ChatInfo(
          groupId: element['groupId'],
          groupName: element['groupName'],
          admin: element['admin'].substring(element['admin'].indexOf("_") + 1),
        ),
      );
    }

    return chatInfos;
  }

  @override
  Future<bool> isUserInGroup(
      {required String groupName,
      required String groupId,
      required String userName,
      required String uid}) async {
    DocumentReference userDocumentRef = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentRef.get();
    List<dynamic> group = await documentSnapshot['groups'];
    if (group.contains("${groupId}_$groupName")) {
      return true;
    }
    return false;
  }

  @override
  Future<void> toggleGroupJoin(
      {required String groupId,
      required String userName,
      required String groupName,
      required String uid}) async {
    DocumentReference userDoc = userCollection.doc(uid);
    DocumentReference groupDoc = groupCollection.doc(groupId);

    DocumentSnapshot docSnapshot = await userDoc.get();
    List<dynamic> groups = docSnapshot['groups'];
    //if user in group -> remove, on the other hand -> join
    if (groups.contains("${groupId}_$groupName")) {
      await userDoc.update({
        "groups": FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDoc.update({
        "members": FieldValue.arrayRemove(["${uid}_$userName"])
      });
    } else {
      await userDoc.update({
        "groups": FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDoc.update({
        "members": FieldValue.arrayUnion(["${uid}_$userName"])
      });
    }
  }

  @override
  Future<List<bool>> checkInGroups({
    required String groupName,
    required String uid,
  }) async {
    //get User's group
    DocumentReference userDoc = userCollection.doc(uid);
    DocumentSnapshot docSnapshot = await userDoc.get();
    List<dynamic> userGroupsInfos = docSnapshot['groups'];
    List<String> userGroupsId = [];
    for (final element in userGroupsInfos) {
      userGroupsId.add(element.substring(0, element.indexOf("_")));
    }

    final groups =
        await (groupCollection.where("groupName", isEqualTo: groupName).get());
    final groupInDB = groups.docs;

    /////
    List<bool> stateOfUserGroups =
        List.generate(groupInDB.length, (index) => false);

    for (int i = 0; i < groupInDB.length; i++) {
      if (userGroupsId.contains(groupInDB[i].id)) {
        stateOfUserGroups[i] = true;
      }
    }

    return stateOfUserGroups;
  }

  void sendMessage(
      {required String groupId,
      required Map<String, dynamic> chatMessageData}) async {
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update(
      {
        "recentMessage": chatMessageData['message'],
        "recentMessageSender": chatMessageData['sender'],
        "timeLastMessage": chatMessageData['time'].toString(),
      },
    );
  }
}
