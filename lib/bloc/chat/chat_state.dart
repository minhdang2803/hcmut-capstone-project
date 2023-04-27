part of 'chat_cubit.dart';

enum ChatGetDataStatus { initial, done, fail, loading }

enum ChatInProcessStatus { initial, sending, receiving, sendingDone }

class ChatState extends Equatable {
  ChatState({
    this.chattingStatus,
    this.errorMessage,
    this.updatingDataStatus,
    this.admin,
    this.groupName,
    this.groupId,
  });
  late final String? groupName;
  late final String? admin;
  late final String? groupId;
  late final ChatGetDataStatus? updatingDataStatus;
  late final ChatInProcessStatus? chattingStatus;
  late final String? errorMessage;

  ChatState.initial() {
    updatingDataStatus = ChatGetDataStatus.initial;
    chattingStatus = ChatInProcessStatus.initial;
    errorMessage = "";
    groupName = "";
    admin = "";
    groupId = "";
  }

  ChatState copyWith({
    String? groupName,
    String? admin,
    ChatGetDataStatus? updatingDataStatus,
    ChatInProcessStatus? chattingStatus,
    String? errorMessage,
    String? groupId,
  }) {
    return ChatState(
      groupId: groupId ?? this.groupId,
      admin: admin ?? this.admin,
      groupName: groupName ?? this.groupName,
      chattingStatus: chattingStatus ?? this.chattingStatus,
      errorMessage: errorMessage ?? this.errorMessage,
      updatingDataStatus: updatingDataStatus ?? this.updatingDataStatus,
    );
  }

  @override
  List<Object?> get props => [
        chattingStatus,
        errorMessage,
        updatingDataStatus,
      ];
}
