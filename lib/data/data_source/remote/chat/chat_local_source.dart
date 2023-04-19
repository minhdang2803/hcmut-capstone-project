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
}
