part of 'chats_cubit.dart';

enum ChatsStates { success, init, error, typing, newMessage, loading , chatsSelected}

extension ChatMessagesStateX on ChatsState {
  bool get isSuccess => status == ChatsStates.success;

  bool get isInitial => status == ChatsStates.init;

  bool get isLoading => status == ChatsStates.loading;

  bool get isError => status == ChatsStates.error;

  bool get isTyping => status == ChatsStates.typing;

  bool get isNewMessage => status == ChatsStates.newMessage;

  bool get isChatsSelected => status == ChatsStates.chatsSelected;
}

@immutable
class ChatsState {
  final ChatsStates status;
  final Failure? failure;
  final List<ChatEntity>? chats;
  final MessageEntity? newMessage;

  const ChatsState({
    this.status = ChatsStates.init,
    this.failure,
    this.chats,
    this.newMessage,
  });

  ChatsState copyWith({
    ChatsStates? status,
    Failure? failure,
    List<ChatEntity>? chats,
    MessageEntity? newMessage,
  }) {
    return ChatsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      chats: chats ?? this.chats,
      newMessage: newMessage,
    );
  }
}

class SeenHistoryState extends ChatsState {
  final List<SeenHistoryModel> seenHistoryData;

  const SeenHistoryState(this.seenHistoryData);
}
