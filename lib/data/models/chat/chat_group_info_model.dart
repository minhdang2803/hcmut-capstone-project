class ChatGroupData {
  ChatGroupData(
      {required this.lastMessage,
      required this.lastSentTime,
      required this.groupId});
  final String groupId;
  final String lastMessage;
  final String lastSentTime;
}
class ChatInfo {
  final String groupName;
  final String admin;
  final String groupId;
  ChatInfo({
    required this.groupId,
    required this.groupName,
    required this.admin,
  });
}
