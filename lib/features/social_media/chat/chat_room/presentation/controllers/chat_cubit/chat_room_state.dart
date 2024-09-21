part of 'chat_room_cubit.dart';

enum ChatRoomStates { initState, loading, error, typing, success }

extension ChatRoomStateX on ChatRoomState {
  bool get isInitial => status == ChatRoomStates.initState;

  bool get isLoading => status == ChatRoomStates.loading;

  bool get isError => status == ChatRoomStates.error;

  bool get isTyping => status == ChatRoomStates.typing;

  bool get isSuccess => status == ChatRoomStates.success;
}

@immutable
class ChatRoomState {
  final ChatRoomStates status;
  final Failure? failure;
  final List<MessageEntity>? messages;
  // final ChatMessagesModel? chatData;
  final MessageEntity? replayedMessage;

  const ChatRoomState({
    this.status = ChatRoomStates.initState,
    this.failure,
    this.messages,
    // this.chatData,
    this.replayedMessage,
  });

  ChatRoomState copyWith({
    ChatRoomStates? status,
    Failure? failure,
    List<MessageEntity>? messages,
    // ChatMessagesModel? chatData,
    MessageEntity? replayedMessage,
  }) {
    return ChatRoomState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      messages: messages,
      // chatData: chatData,
      replayedMessage: replayedMessage,
    );
  }
}
