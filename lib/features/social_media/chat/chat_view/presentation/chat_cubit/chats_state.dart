part of 'chats_cubit.dart';

enum ChatsStates { initState, loading, error, typing }

extension ChatMessagesStateX on ChatsState {
  bool get isInitial => status == ChatsStates.initState;

  bool get isLoading => status == ChatsStates.loading;

  bool get isError => status == ChatsStates.error;
  bool get isTyping => status == ChatsStates.typing;
}

@immutable
class ChatsState {
  final ChatsStates status;
  final Failure? failure;
  final List<ChatModel>? chats;
  final List<MessageEntity>? messages;

  const ChatsState({
    this.status = ChatsStates.loading,
    this.failure,
    this.chats,
    this.messages,
  });

  ChatsState copyWith({
    ChatsStates? status,
    Failure? failure,
    List<ChatModel>? chats,
    List<MessageEntity>? messages,
  }) {
    return ChatsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      chats: chats ?? this.chats,
      messages: messages ?? this.messages,
    );
  }
}

class SeenHistoryState extends ChatsState {
  final List<SeenHistoryModel> seenHistoryData;

  const SeenHistoryState(this.seenHistoryData);
}
