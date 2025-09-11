import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Entities/conversation_entity.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Entities/conversations_pagination.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Usecases/get_socail_conversations.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Usecases/listen_to_stop_typing_usecase.dart';
import 'package:fourtyninehub/features/Conversations/Presentation/Controllers/cubits/conversation_states.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../../shared_web_socket.dart';
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
    try {
      // Participant Joined
      SharedWebSocket.socket?.on('conversation:participant-joined', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("conversation:participant-joined :  $data");

          // conversation:participant-joined :  {conversationId: 6891db829fd423658d5c72ff}
          socialConversations.firstWhere((element) => element.conversationId == data['conversationId']).inConversation = true;
          emit(state.copyWith(
              status: ConversationsStates.success));

        } catch (e) {
          CliLogger.error("conversation:participant-joined Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("conversation:participant-joined Error :  $e");
    }

    // Participant Left
    try {

      SharedWebSocket.socket?.on('conversation:participant-left', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("conversation:participant-left :  $data");

          // conversation:participant-left :  {conversationId: 6891db829fd423658d5c72ff}
          socialConversations.firstWhere((element) => element.conversationId == data['conversationId']).inConversation = false;
          emit(state.copyWith(
              status: ConversationsStates.success));

        } catch (e) {
          CliLogger.error("conversation:participant-left Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("conversation:participant-left Error :  $e");
    }

    // friend:status (online or offline)
    try {
      SharedWebSocket.socket?.on('friend:status', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("friend:status :  $data");

          // friend:status :  {friendUserId: 680a56fa076c551578e1b278, online: true} // profile object (userId)
          socialConversations.firstWhere((element) => element.profile?.id == data['friendUserId']).isOnline = data['online'] ?? false;
          emit(state.copyWith(
              status: ConversationsStates.success));

        } catch (e) {
          CliLogger.error("friend:status Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("friend:status Error :  $e");
    }

    // Participant Start Recording
    try {

      SharedWebSocket.socket?.on('conversation:participant-started-recording', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("conversation:participant-started-recording :  $data");

          socialConversations.firstWhere((element) => element.conversationId == data['conversationId']).isRecording = true;
          emit(state.copyWith(
              status: ConversationsStates.success));

        } catch (e) {
          CliLogger.error("conversation:participant-started-recording Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("conversation:participant-started-recording Error :  $e");
    }

    // Participant Stop Recording
    try {

      SharedWebSocket.socket?.on('conversation:participant-stop-recording', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("conversation:participant-stop-recording :  $data");

          socialConversations.firstWhere((element) => element.conversationId == data['conversationId']).isRecording = false;
          emit(state.copyWith(
              status: ConversationsStates.success));

        } catch (e) {
          CliLogger.error("conversation:participant-stop-recording Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("conversation:participant-stop-recording Error :  $e");
    }

    // Conversation Update List
    _listenToUpdateSocialList();
    // Conversation Start Typing
    _listenToStartTyping();
    // Conversation Stop Typing
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
    if (hasMoreDataSocialConversations || isLoadingMoreSocialConversation) return;
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
