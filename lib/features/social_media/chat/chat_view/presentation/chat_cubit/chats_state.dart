part of 'chats_cubit.dart';

enum ChatsStates {
  success,
  init,
  error,
  typing,
  recording,
  newMessage,
  loading,
  chatsSelected,
  archived,
}

extension ChatMessagesStateX on ChatsState {
  bool get isSuccess => status == ChatsStates.success;

  bool get isInitial => status == ChatsStates.init;

  bool get isLoading => status == ChatsStates.loading;

  bool get isError => status == ChatsStates.error;

  bool get isTyping => status == ChatsStates.typing;

  bool get isNewMessage => status == ChatsStates.newMessage;

  bool get isChatsSelected => status == ChatsStates.chatsSelected;

  bool get isArchived => status == ChatsStates.archived;

  bool get isRecording => status == ChatsStates.recording;
}

@immutable
class ChatsState {
  final ChatsStates status;
  final Failure? failure;
  final List<ChatEntity>? chats;
  final MessageEntity? newMessage;
  final bool? archived;
  final List<ChatEntity>? archivedChats;
  final ListenToTypingParams? listenToTypingParams;
  final ListenToRecordingParams? listenToRecordingParams;

  const ChatsState({
    this.status = ChatsStates.init,
    this.failure,
    this.chats,
    this.newMessage,
    this.archived,
    this.archivedChats = const [],
    this.listenToTypingParams ,
    this.listenToRecordingParams,
  });

  ChatsState copyWith({
    ChatsStates? status,
    Failure? failure,
    List<ChatEntity>? chats,
    MessageEntity? newMessage,
    bool? archived,
    List<ChatEntity>? archivedChats,
    ListenToTypingParams? listenToTypingParams,
    ListenToRecordingParams? listenToRecordingParams,
  }) {
    return ChatsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      chats: chats ?? this.chats,
      newMessage: newMessage,
      archived: archived ?? this.archived,
      archivedChats: archivedChats ?? this.archivedChats,
      listenToTypingParams: listenToTypingParams,
      listenToRecordingParams: listenToRecordingParams,
    );
  }
}

class SeenHistoryState extends ChatsState {
  final List<SeenHistoryModel> seenHistoryData;

  const SeenHistoryState(this.seenHistoryData);
}
