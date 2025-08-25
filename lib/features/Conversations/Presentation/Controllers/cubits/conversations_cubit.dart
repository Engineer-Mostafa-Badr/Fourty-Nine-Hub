import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Entities/conversation_entity.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Entities/conversations_pagination.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Usecases/get_socail_conversations.dart';
import 'package:fourtyninehub/features/Conversations/Presentation/Controllers/cubits/conversation_states.dart';

class ConversationsCubit extends Cubit<ConversationsState> {
  final GetSocialConversations getSocialConversationsUseCase;

  ConversationsCubit(
    this.getSocialConversationsUseCase,
  ) : super(ConversationsState());

  final int pageSize = 15;
  List<ConversationEntity> socialConversations = [];
  bool isLoadingMoreSocialConversation = false;
  bool hasMoreDataSocialConversations = true;
  int currentPageSocialConversations = 1;

  Future<void> loadInitialSocialConversations() async {
    socialConversations.clear();
    currentPageSocialConversations = 1;
    hasMoreDataSocialConversations = true;
    emit(state.copyWith(status: ConversationsStates.loading));
    await _fetchSocialConversations();
  }

  Future<void> getSocialConversations() async {
    if (!hasMoreDataSocialConversations || isLoadingMoreSocialConversation) return;
    isLoadingMoreSocialConversation = true;
    emit(state.copyWith(status: ConversationsStates.loading));
    await _fetchSocialConversations();
  }

  Future<void> _fetchSocialConversations() async {
    final result = await getSocialConversationsUseCase(
      pagination: ConversationPagination(
        page: currentPageSocialConversations,
        limit: pageSize,
      ),
    );

    result.fold(
      (l) {
        isLoadingMoreSocialConversation = false; // Reset loading state on error
        emit(state.copyWith(status: ConversationsStates.error, failure: l));
      },
      (data) {
        socialConversations.addAll(data);

        if (data.length < pageSize) {
          hasMoreDataSocialConversations = false;
        } else {
          currentPageSocialConversations++;
        }
        isLoadingMoreSocialConversation = false;
        emit(state.copyWith(status: ConversationsStates.success));
      },
    );
  }
}
