
import '../../../../../core/error/failure.dart';

enum ConversationsStates {
  initState,
  loading,
  error,
  success,
}

extension ConversationsStatex on ConversationsState {
  bool get isInitial => status == ConversationsStates.initState;
  bool get isLoading => status == ConversationsStates.loading;
  bool get isError => status == ConversationsStates.error;
  bool get isSuccess => status == ConversationsStates.success;
}

class ConversationsState {
  final ConversationsStates status;
  final Failure? failure;

  ConversationsState({
    this.status = ConversationsStates.initState,
    this.failure,
  });

  ConversationsState copyWith({
    ConversationsStates? status,
    Failure? failure,
  }) {
    return ConversationsState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
