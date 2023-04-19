part of 'chat_cubit.dart';

enum ChatGetDataStatus { initial, done, fail, loading }

enum ChatInProcessStatus { initial, sending, receiving, sendingDone }

class ChatState extends Equatable {
  ChatState({
    this.chattingStatus,
    this.errorMessage,
    this.updatingDataStatus,
  });
  late final ChatGetDataStatus? updatingDataStatus;
  late final ChatInProcessStatus? chattingStatus;
  late final String? errorMessage;

  ChatState.initial() {
    updatingDataStatus = ChatGetDataStatus.initial;
    chattingStatus = ChatInProcessStatus.initial;
    errorMessage = "";
  }

  ChatState copyWith({
    final ChatGetDataStatus? updatingDataStatus,
    final ChatInProcessStatus? chattingStatus,
    final String? errorMessage,
    final Stream<DocumentSnapshot<Object?>>? groups,
  }) {
    return ChatState(
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
