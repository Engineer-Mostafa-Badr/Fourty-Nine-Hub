part of 'chat_cubit.dart';

enum ChatsStates { initState, loading, error ,typing }

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
  final List<ChatItemModel>? chats;

  const ChatsState({
    this.status = ChatsStates.loading,
    this.failure,
    this.chats,
  });

  ChatsState copyWith({
    ChatsStates? status,
    Failure? failure,
    List<ChatItemModel>? chats,
  }) {
    return ChatsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      chats: chats ?? this.chats,
    );
  }
}
