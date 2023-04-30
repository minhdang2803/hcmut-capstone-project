part of 'chat_cubit.dart';

enum ChatGetDataStatus { initial, done, fail, loading }

enum ChatSearchStatus { initial, done, fail, loading, joiningChat }

enum ChatResultLoading { initial, done, fail, loading }

enum ChatInProcessStatus {
  initial,
  ready,
  sending,
  receiving,
  sendingDone,
}

class ChatState extends Equatable {
  ChatState({
    this.chattingStatus,
    this.errorMessage,
    this.updatingDataStatus,
    this.admin,
    this.groupName,
    this.groupId,
    this.listChatInfo,
    this.chatSearchStatus,
    this.isInGroup,
    this.chatResultLoading,
    this.chatLength,
    this.chatStream,
    this.groupData,
    this.listChatData,
    this.groupList,
  });
  late final String? groupName;
  late final String? admin;
  late final String? groupId;
  late final ChatGetDataStatus? updatingDataStatus;
  late final ChatInProcessStatus? chattingStatus;
  late final ChatSearchStatus? chatSearchStatus;
  late final List<ChatResultLoading>? chatResultLoading;
  late final String? errorMessage;
  late final List<ChatInfo>? listChatInfo;
  late final List<bool>? isInGroup;
  late final int? chatLength;
  late final DocumentSnapshot<Object?>? groupData;
  late final Stream<QuerySnapshot<Map<String, dynamic>>>? chatStream;
  late final List<ChatGroupData>? listChatData;
  late final Stream<DocumentSnapshot<Object?>>? groupList;

  ChatState.initial() {
    updatingDataStatus = ChatGetDataStatus.initial;
    chattingStatus = ChatInProcessStatus.initial;
    chatSearchStatus = ChatSearchStatus.initial;
    chatResultLoading = [];
    errorMessage = "";
    groupName = "";
    admin = "";
    groupId = "";
    isInGroup = [];
    listChatInfo = [];
    chatLength = 0;
    chatStream = null;
    groupData = null;
    listChatData = [];
    groupList = null;
  }

  ChatState copyWith({
    String? groupName,
    String? admin,
    ChatGetDataStatus? updatingDataStatus,
    ChatInProcessStatus? chattingStatus,
    String? errorMessage,
    String? groupId,
    ChatSearchStatus? chatSearchStatus,
    List<ChatInfo>? listChatInfo,
    List<bool>? isInGroup,
    List<ChatResultLoading>? chatResultLoading,
    int? chatLength,
    Stream<QuerySnapshot<Map<String, dynamic>>>? chatStream,
    DocumentSnapshot<Object?>? groupData,
    List<ChatGroupData>? listChatData,
    Stream<DocumentSnapshot<Object?>>? groupList,
  }) {
    return ChatState(
      groupId: groupId ?? this.groupId,
      admin: admin ?? this.admin,
      groupName: groupName ?? this.groupName,
      chattingStatus: chattingStatus ?? this.chattingStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      updatingDataStatus: updatingDataStatus ?? this.updatingDataStatus,
      chatSearchStatus: chatSearchStatus ?? this.chatSearchStatus,
      listChatInfo: listChatInfo ?? this.listChatInfo,
      isInGroup: isInGroup ?? this.isInGroup,
      chatResultLoading: chatResultLoading ?? this.chatResultLoading,
      chatLength: chatLength ?? this.chatLength,
      chatStream: chatStream ?? this.chatStream,
      groupData: groupData ?? this.groupData,
      listChatData: listChatData ?? this.listChatData,
      groupList: groupList ?? this.groupList,
    );
  }

  @override
  List<Object?> get props => [
        chattingStatus,
        errorMessage,
        updatingDataStatus,
        admin,
        groupName,
        groupId,
        listChatInfo,
        chatSearchStatus,
        isInGroup,
        chatResultLoading,
        chatLength,
        chatStream,
        groupData,
        listChatData,
        groupList,
      ];
}
