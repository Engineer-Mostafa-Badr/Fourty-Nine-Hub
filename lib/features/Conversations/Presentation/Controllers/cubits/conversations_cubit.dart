import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Entities/conversation_entity.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Entities/conversations_pagination.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Usecases/get_socail_conversations.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Usecases/listen_to_stop_typing_usecase.dart';
import 'package:fourtyninehub/features/Conversations/Presentation/Controllers/cubits/conversation_states.dart';

import '../../../Domain/Usecases/listen_to_start_typing.dart';
import '../../../Domain/Usecases/listen_to_update_social_list_usecase.dart';
import '../../../Domain/Usecases/start_typing_usecase.dart';
import '../../../Domain/Usecases/stop_typing_usecase.dart';

class ConversationsCubit extends Cubit<ConversationsState> {
  final GetSocialConversations getSocialConversationsUseCase;
  final ListenToUpdateSocialListUseCase listenToUpdateSocialListUseCase;
  final StartTypingUseCase startTypingUseCase;
  final ListenToStartTypingUseCase listenToStartTypingUseCase;
  final StopTypingUseCase stopTypingUseCase;
  final ListenToStopTypingUseCase listenToStopTypingUseCase;


  ConversationsCubit(
    this.getSocialConversationsUseCase,
    this.listenToUpdateSocialListUseCase,
    this.startTypingUseCase,
    this.listenToStartTypingUseCase,
    this.stopTypingUseCase,
    this.listenToStopTypingUseCase,
  ) : super(ConversationsState()){
    _listenToUpdateSocialList();
    _listenToStartTyping();
    _listenToStopTyping();
  }

  _listenToUpdateSocialList() {
    listenToUpdateSocialListUseCase((conversation) {
      if(socialConversations.any((element) => element.conversationId == conversation.conversationId)){
        // update conversation
        socialConversations[socialConversations.indexWhere((element) => element.conversationId == conversation.conversationId)] = conversation;
      }
      else{
        socialConversations.add(conversation);
      }
      emit(state.copyWith(
          status: ConversationsStates.success));
    });
  }

  Future<void> startTyping(String conversationId) async {
    final result = await startTypingUseCase(conversationId: conversationId);
    result.fold((l) => null, (r) => null);
  }

  _listenToStartTyping() {
    listenToStartTypingUseCase((conversationId) {
      socialConversations.firstWhere((element) => element.conversationId == conversationId).isTyping = true;
      emit(state.copyWith(
          status: ConversationsStates.success));
    });
  }

  Future<void> stopTyping(String conversationId) async {
    final result = await stopTypingUseCase(conversationId: conversationId);
    result.fold((l) => null, (r) => null);
  }

  _listenToStopTyping(){
    listenToStopTypingUseCase((conversationId) {
      socialConversations.firstWhere((element) => element.conversationId == conversationId).isTyping = false;
      emit(state.copyWith(
          status: ConversationsStates.success));
    });
  }



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
