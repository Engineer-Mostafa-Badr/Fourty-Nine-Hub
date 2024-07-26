part of 'chat_room_cubit.dart';

enum ChatRoomStates { initState, loading, error }

extension ChatRoomStateX on ChatRoomState {
  bool get isInitial => status == ChatRoomStates.initState;

  bool get isLoading => status == ChatRoomStates.loading;

  bool get isError => status == ChatRoomStates.error;
}

@immutable
class ChatRoomState {
  final ChatRoomStates status;
  final Failure? failure;
  final List<MessageEntity>? chatMessages;
  final ChatMessagesModel? chatData;

  const ChatRoomState({
    this.status = ChatRoomStates.loading,
    this.failure,
    this.chatMessages,
    this.chatData,
  });

  ChatRoomState copyWith({
    ChatRoomStates? status,
    Failure? failure,
    List<MessageEntity>? chatMessages,
    ChatMessagesModel? chatData,
  }) {
    return ChatRoomState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      chatMessages: chatMessages,
      chatData: chatData,
    );
  }
}
