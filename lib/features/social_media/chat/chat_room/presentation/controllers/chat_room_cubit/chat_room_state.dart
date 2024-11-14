part of 'chat_room_cubit.dart';

enum ChatRoomStates { initState, loading, error, typing, success, messagesSelected }

extension ChatRoomStateX on ChatRoomState {
  bool get isInitial => status == ChatRoomStates.initState;

  bool get isLoading => status == ChatRoomStates.loading;

  bool get isError => status == ChatRoomStates.error;

  bool get isTyping => status == ChatRoomStates.typing;

  bool get isSuccess => status == ChatRoomStates.success;

  bool get isMessagesSelected => status == ChatRoomStates.messagesSelected;
}

@immutable
class ChatRoomState {
  final ChatRoomStates status;
  final Failure? failure;
  final List<MessageEntity>? messages;
  final MessageEntity? replayedMessage;
  final MessageEntity? oneTimeViewMessage;

  const ChatRoomState({
    this.status = ChatRoomStates.initState,
    this.failure,
    this.messages,
    this.replayedMessage,
    this.oneTimeViewMessage,
  });

  ChatRoomState copyWith({
    ChatRoomStates? status,
    Failure? failure,
    List<MessageEntity>? messages,
    MessageEntity? replayedMessage,
    MessageEntity? oneTimeViewMessage,
  }) {
    return ChatRoomState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      messages: messages ?? this.messages,
      replayedMessage: replayedMessage,
      oneTimeViewMessage: oneTimeViewMessage,
    );
  }
}
