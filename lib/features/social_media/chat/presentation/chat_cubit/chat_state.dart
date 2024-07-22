part of 'chat_cubit.dart';

enum ChatMessagesStates { initState, loading, error }

extension ChatMessagesStateX on ChatMessageState {
  bool get isInitial => status == ChatMessagesStates.initState;

  bool get isLoading => status == ChatMessagesStates.loading;

  bool get isError => status == ChatMessagesStates.error;
}

@immutable
class ChatMessageState {
  final ChatMessagesStates status;
  final Failure? failure;
  final List<MessageEntity>? chatMessages;

  const ChatMessageState({
    this.status = ChatMessagesStates.loading,
    this.failure,
    this.chatMessages,
  });

  ChatMessageState copyWith({
    ChatMessagesStates? status,
    Failure? failure,
    List<MessageEntity>? chatMessages,
  }) {
    return ChatMessageState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      chatMessages: chatMessages,
    );
  }
}
