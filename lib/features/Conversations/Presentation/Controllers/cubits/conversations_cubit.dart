import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Entities/conversation_entity.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Entities/conversations_pagination.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Usecases/get_socail_conversations.dart';
import 'package:fourtyninehub/features/Conversations/Domain/Usecases/listen_to_stop_typing_usecase.dart';
import 'package:fourtyninehub/features/Conversations/Presentation/Controllers/cubits/conversation_states.dart';
import 'package:go_router/go_router.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../routes/pages.dart';
import '../../../../../shared_web_socket.dart';
import '../../../Data/Models/conversation_model.dart';
import '../../../Domain/Usecases/delete_conversations_use_case.dart';
import '../../../Domain/Usecases/get_conversation_logs_use_case.dart';
import '../../../Domain/Usecases/get_deleted_social_conversations_use_case.dart';
import '../../../Domain/Usecases/get_socail_anonymous_conversations_use_case.dart';
import '../../../Domain/Usecases/get_socail_greet_conversations_use_case.dart';
import '../../../Domain/Usecases/get_social_archived_conversations_use_case.dart';
import '../../../Domain/Usecases/get_social_locked_conversations_use_case.dart';
import '../../../Domain/Usecases/get_unreaded_conversations_count_use_case.dart';
import '../../../Domain/Usecases/listen_to_start_typing.dart';
import '../../../Domain/Usecases/listen_to_update_social_list_usecase.dart';
import '../../../Domain/Usecases/restore_conversations_use_case.dart';
import '../../../Domain/Usecases/start_typing_usecase.dart';
import '../../../Domain/Usecases/stop_typing_usecase.dart';
import '../../../Domain/Usecases/toggle_archived_conversation_usecase.dart';
import '../../../Domain/Usecases/toggle_mute_conversations_use_case.dart';
import '../../../Domain/Usecases/toggle_pinned_conversations_use_case.dart';

class ConversationsCubit extends Cubit<ConversationsState> {
  final GetSocialConversations getSocialConversationsUseCase;
  final GetSocialArchivedConversations getSocialArchivedConversationsUseCase;
  final GetSocialGreetConversations getSocialGreetConversationsUseCase;
  final GetSocialLockedConversations getSocialLockedConversationsUseCase;
  final GetSocialAnonymousConversationsUseCase getSocialAnonymousConversationsUseCase;
  final GetDeletedSocialConversationsUseCase getDeletedSocialConversationsUseCase;
  final GetConversationLogsUseCase getConversationLogsUseCase;
  final ListenToUpdateSocialListUseCase listenToUpdateSocialListUseCase;
  final StartTypingUseCase startTypingUseCase;
  final ListenToStartTypingUseCase listenToStartTypingUseCase;
  final StopTypingUseCase stopTypingUseCase;
  final ListenToStopTypingUseCase listenToStopTypingUseCase;
  final ToggleArchivedConversationUseCase toggleArchivedConversationUseCase;
  final TogglePinnedConversationUseCase togglePinnedConversationUseCase;
  final ToggleMuteConversationUseCase toggleMuteConversationUseCase;
  final DeleteConversationsUseCase deleteConversationsUseCase;
  final RestoreConversationsUseCase restoreConversationsUseCase;
  final GetUnreadConversationsUseCase getUnreadConversationsUseCase;

  List<ConversationEntity> selectedSocialConversation = [];
  int unreadConversationsCount = 0;
  ConversationEntity? selectedConversation;

  setSelectedConversation(ConversationEntity? conversation) {
    selectedConversation = conversation;
    emit(state);
  }

  resetSelectedConversation() {
    selectedConversation = null;
    emit(state);
  }


  ConversationsCubit(
    this.getSocialConversationsUseCase,
    this.getSocialArchivedConversationsUseCase,
    this.getSocialGreetConversationsUseCase,
    this.getDeletedSocialConversationsUseCase,
    this.getSocialLockedConversationsUseCase,
    this.getSocialAnonymousConversationsUseCase,
    this.getConversationLogsUseCase,
    this.listenToUpdateSocialListUseCase,
    this.startTypingUseCase,
    this.listenToStartTypingUseCase,
    this.stopTypingUseCase,
    this.listenToStopTypingUseCase,
    this.toggleArchivedConversationUseCase,
    this.togglePinnedConversationUseCase,
    this.toggleMuteConversationUseCase,
    this.deleteConversationsUseCase,
    this.restoreConversationsUseCase,
    this.getUnreadConversationsUseCase,
  ) : super(ConversationsState());

  Future<void> joinConversation({required String conversationId}) async {
    try {
      log("you joining conversation :  $conversationId");
      SharedWebSocket.socket?.emit(
          "join:conversation",
          conversationId);
      log("you joined conversation :  $conversationId");
    } catch (e) {
      log("can't join conversation $e");
    }
  }

  Future<void> leaveConversation({required String conversationId}) async {
    try {
      log("you leaving conversation :  $conversationId");
      SharedWebSocket.socket?.emit(
          "leave:conversation",
          conversationId);
      log("you left conversation :  $conversationId");
    } catch (e) {
      log("can't leave conversation $e");
    }
  }

  Future<void> startTyping(String conversationId) async {
    final result = await startTypingUseCase(conversationId: conversationId);
    result.fold((l) {
      log("can't start typing $l");
    }, (r) {
      log("started typing");
    });
  }

  Future<void> stopTyping(String conversationId) async {
    final result = await stopTypingUseCase(conversationId: conversationId);
    result.fold((l) => null, (r) => null);
  }

  Future<void> startRecording(String conversationId) async {
    try {
      // serviceLocator<Socket>().connect();
      CliLogger.info('start recording : $conversationId');

      SharedWebSocket.socket?.emit(
        'conversation:recording-started',
        conversationId,
      );
      log("you started recording :  $conversationId");
    } catch (e) {
      CliLogger.error(' can\'t start recording $e');
    }
  }

  Future<void> stopRecording (String conversationId) async {
    try {
      // serviceLocator<Socket>().connect();
      CliLogger.info('stop recording : $conversationId');
      SharedWebSocket.socket?.emit(
        'conversation:recording-stopped',
        conversationId,
      );
      log("you stopped recording :  $conversationId");
    } catch (e) {
      CliLogger.error(' can\'t stop recording $e');
    }
  }


  // social sockets
  initSocialSockets(){
    onlineOfflineSocial();
    listenToUpdateSocialList();
    participantJoinedSocial();
    participantLeftSocial();
    participantStartRecordingSocial();
    participantStopRecordingSocial();
    listenToStartTypingSocial();
    listenToStopTypingSocial();
  }

  onlineOfflineSocial(){
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
  }

  listenToUpdateSocialList() {
    log("listenToUpdateSocialList");
    listenToUpdateSocialListUseCase((conversation) {
      log("conversation updated :  $conversation");
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

  participantJoinedSocial(){
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
  }

  participantLeftSocial(){
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
  }

  participantStartRecordingSocial(){
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
  }

  participantStopRecordingSocial(){
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
  }

  listenToStartTypingSocial() {
    listenToStartTypingUseCase((conversationId) {
      socialConversations.firstWhere((element) => element.conversationId == conversationId).isTyping = true;
      emit(state.copyWith(
          status: ConversationsStates.success));
    });
  }

  listenToStopTypingSocial(){
    listenToStopTypingUseCase((conversationId) {
      socialConversations.firstWhere((element) => element.conversationId == conversationId).isTyping = false;
      emit(state.copyWith(
          status: ConversationsStates.success));
    });
  }



  // anonymous sockets
  initSocialAnonymousSockets(){
    onlineOfflineSocialAnonymous();
    listenToUpdateSocialAnonymousList();
    participantJoinedSocialAnonymous();
    participantLeftSocialAnonymous();
    participantStartRecordingSocialAnonymous();
    participantStopRecordingSocialAnonymous();
    listenToStartTypingSocialAnonymous();
    listenToStopTypingSocialAnonymous();
  }

  onlineOfflineSocialAnonymous(){
    // friend:status (online or offline)
    try {
      SharedWebSocket.socket?.on('friend:status', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("friend:status :  $data");

          // friend:status :  {friendUserId: 680a56fa076c551578e1b278, online: true} // profile object (userId)
          socialAnonymousConversations.firstWhere((element) => element.profile?.id == data['friendUserId']).isOnline = data['online'] ?? false;
          emit(state.copyWith(
              status: ConversationsStates.success));

        } catch (e) {
          CliLogger.error("friend:status Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("friend:status Error :  $e");
    }
  }

  listenToUpdateSocialAnonymousList() {
    log("listenToUpdateSocialAnonymousList");
    try {
      // SharedWebSocket.instance.socket!.connect();

      SharedWebSocket.socket?.on('conversation:anonymous-update-list', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("Listen to Update Social List :  $data");
          ConversationEntity conversation = ConversationModel.fromJson(data);
          log("conversation updated :  $conversation");
          if(socialAnonymousConversations.any((element) => element.conversationId == conversation.conversationId)){
            // update conversation
            socialAnonymousConversations[socialAnonymousConversations.indexWhere((element) => element.conversationId == conversation.conversationId)] = conversation;
          }
          else{
            socialAnonymousConversations.add(conversation);
          }
          emit(state.copyWith(
              status: ConversationsStates.success));
        } catch (e) {
          CliLogger.error("Listen to Update Social Anonymous List Error 1 :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("Listen to Update Social Anonymous List Error 2:  $e");
    }
  }

  participantJoinedSocialAnonymous(){
    try {
      // Participant Joined
      SharedWebSocket.socket?.on('conversation:participant-joined', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("conversation:participant-joined :  $data");

          // conversation:participant-joined :  {conversationId: 6891db829fd423658d5c72ff}
          socialAnonymousConversations.firstWhere((element) => element.conversationId == data['conversationId']).inConversation = true;
          emit(state.copyWith(
              status: ConversationsStates.success));

        } catch (e) {
          CliLogger.error("conversation:participant-joined Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("conversation:participant-joined Error :  $e");
    }
  }

  participantLeftSocialAnonymous(){
    // Participant Left
    try {

      SharedWebSocket.socket?.on('conversation:participant-left', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("conversation:participant-left :  $data");

          // conversation:participant-left :  {conversationId: 6891db829fd423658d5c72ff}
          socialAnonymousConversations.firstWhere((element) => element.conversationId == data['conversationId']).inConversation = false;
          emit(state.copyWith(
              status: ConversationsStates.success));
        } catch (e) {
          CliLogger.error("conversation:participant-left Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("conversation:participant-left Error :  $e");
    }
  }

  participantStartRecordingSocialAnonymous(){
    // Participant Start Recording
    try {

      SharedWebSocket.socket?.on('conversation:participant-started-recording', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("conversation:participant-started-recording :  $data");

          socialAnonymousConversations.firstWhere((element) => element.conversationId == data['conversationId']).isRecording = true;
          emit(state.copyWith(
              status: ConversationsStates.success));

        } catch (e) {
          CliLogger.error("conversation:participant-started-recording Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("conversation:participant-started-recording Error :  $e");
    }
  }

  participantStopRecordingSocialAnonymous(){
    // Participant Stop Recording
    try {

      SharedWebSocket.socket?.on('conversation:participant-stop-recording', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("conversation:participant-stop-recording :  $data");

          socialAnonymousConversations.firstWhere((element) => element.conversationId == data['conversationId']).isRecording = false;
          emit(state.copyWith(
              status: ConversationsStates.success));

        } catch (e) {
          CliLogger.error("conversation:participant-stop-recording Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("conversation:participant-stop-recording Error :  $e");
    }
  }

  listenToStartTypingSocialAnonymous() {
    listenToStartTypingUseCase((conversationId) {
      socialAnonymousConversations.firstWhere((element) => element.conversationId == conversationId).isTyping = true;
      emit(state.copyWith(
          status: ConversationsStates.success));
    });
  }

  listenToStopTypingSocialAnonymous(){
    listenToStopTypingUseCase((conversationId) {
      socialAnonymousConversations.firstWhere((element) => element.conversationId == conversationId).isTyping = false;
      emit(state.copyWith(
          status: ConversationsStates.success));
    });
  }


  // social locked sockets
  initSocialLockedSockets(){
    onlineOfflineSocialLocked();
    listenToUpdateSocialLockedList();
    participantJoinedSocialLocked();
    participantLeftSocialLocked();
    participantStartRecordingSocialLocked();
    participantStopRecordingSocialLocked();
    listenToStartTypingSocialLocked();
    listenToStopTypingSocialLocked();
  }

  onlineOfflineSocialLocked(){
    // friend:status (online or offline)
    try {
      SharedWebSocket.socket?.on('friend:status', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("friend:status :  $data");

          // friend:status :  {friendUserId: 680a56fa076c551578e1b278, online: true} // profile object (userId)
          socialLockedConversations.firstWhere((element) => element.profile?.id == data['friendUserId']).isOnline = data['online'] ?? false;
          emit(state.copyWith(
              status: ConversationsStates.success));

        } catch (e) {
          CliLogger.error("friend:status Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("friend:status Error :  $e");
    }
  }

  listenToUpdateSocialLockedList() {
    log("listenToUpdateSocialList");
    listenToUpdateSocialListUseCase((conversation) {
      log("conversation updated :  $conversation");
      if(socialLockedConversations.any((element) => element.conversationId == conversation.conversationId)){
        // update conversation
        socialLockedConversations[socialLockedConversations.indexWhere((element) => element.conversationId == conversation.conversationId)] = conversation;
      }
      else{
        socialLockedConversations.add(conversation);
      }
      emit(state.copyWith(
          status: ConversationsStates.success));
    });
  }

  participantJoinedSocialLocked(){
    try {
      // Participant Joined
      SharedWebSocket.socket?.on('conversation:participant-joined', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("conversation:participant-joined :  $data");

          // conversation:participant-joined :  {conversationId: 6891db829fd423658d5c72ff}
          socialLockedConversations.firstWhere((element) => element.conversationId == data['conversationId']).inConversation = true;
          emit(state.copyWith(
              status: ConversationsStates.success));

        } catch (e) {
          CliLogger.error("conversation:participant-joined Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("conversation:participant-joined Error :  $e");
    }
  }

  participantLeftSocialLocked(){
    // Participant Left
    try {

      SharedWebSocket.socket?.on('conversation:participant-left', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("conversation:participant-left :  $data");

          // conversation:participant-left :  {conversationId: 6891db829fd423658d5c72ff}
          socialLockedConversations.firstWhere((element) => element.conversationId == data['conversationId']).inConversation = false;
          emit(state.copyWith(
              status: ConversationsStates.success));
        } catch (e) {
          CliLogger.error("conversation:participant-left Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("conversation:participant-left Error :  $e");
    }
  }

  participantStartRecordingSocialLocked(){
    // Participant Start Recording
    try {

      SharedWebSocket.socket?.on('conversation:participant-started-recording', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("conversation:participant-started-recording :  $data");

          socialLockedConversations.firstWhere((element) => element.conversationId == data['conversationId']).isRecording = true;
          emit(state.copyWith(
              status: ConversationsStates.success));

        } catch (e) {
          CliLogger.error("conversation:participant-started-recording Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("conversation:participant-started-recording Error :  $e");
    }
  }

  participantStopRecordingSocialLocked(){
    // Participant Stop Recording
    try {

      SharedWebSocket.socket?.on('conversation:participant-stop-recording', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("conversation:participant-stop-recording :  $data");

          socialLockedConversations.firstWhere((element) => element.conversationId == data['conversationId']).isRecording = false;
          emit(state.copyWith(
              status: ConversationsStates.success));

        } catch (e) {
          CliLogger.error("conversation:participant-stop-recording Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("conversation:participant-stop-recording Error :  $e");
    }
  }

  listenToStartTypingSocialLocked() {
    listenToStartTypingUseCase((conversationId) {
      socialLockedConversations.firstWhere((element) => element.conversationId == conversationId).isTyping = true;
      emit(state.copyWith(
          status: ConversationsStates.success));
    });
  }

  listenToStopTypingSocialLocked(){
    listenToStopTypingUseCase((conversationId) {
      socialLockedConversations.firstWhere((element) => element.conversationId == conversationId).isTyping = false;
      emit(state.copyWith(
          status: ConversationsStates.success));
    });
  }



  // Social Archive sockets
  initSocialArchivedSockets(){
    onlineOfflineSocialArchived();
    listenToUpdateSocialArchivedList();
    participantJoinedSocialArchived();
    participantLeftSocialArchived();
    participantStartRecordingSocialArchived();
    participantStopRecordingSocialArchived();
    listenToStartTypingSocialArchived();
    listenToStopTypingSocialArchived();
  }

  onlineOfflineSocialArchived(){
    // friend:status (online or offline)
    try {
      SharedWebSocket.socket?.on('friend:status', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("friend:status :  $data");

          // friend:status :  {friendUserId: 680a56fa076c551578e1b278, online: true} // profile object (userId)
          socialArchivedConversations.firstWhere((element) => element.profile?.id == data['friendUserId']).isOnline = data['online'] ?? false;
          emit(state.copyWith(
              status: ConversationsStates.success));

        } catch (e) {
          CliLogger.error("friend:status Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("friend:status Error :  $e");
    }
  }

  listenToUpdateSocialArchivedList() {
    log("listenToUpdateSocialList");
    listenToUpdateSocialListUseCase((conversation) {
      log("conversation updated :  $conversation");
      if(socialArchivedConversations.any((element) => element.conversationId == conversation.conversationId)){
        // update conversation
        socialArchivedConversations[socialArchivedConversations.indexWhere((element) => element.conversationId == conversation.conversationId)] = conversation;
      }
      else{
        socialArchivedConversations.add(conversation);
      }
      emit(state.copyWith(
          status: ConversationsStates.success));
    });
  }

  participantJoinedSocialArchived(){
    try {
      // Participant Joined
      SharedWebSocket.socket?.on('conversation:participant-joined', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("conversation:participant-joined :  $data");

          // conversation:participant-joined :  {conversationId: 6891db829fd423658d5c72ff}
          socialArchivedConversations.firstWhere((element) => element.conversationId == data['conversationId']).inConversation = true;
          emit(state.copyWith(
              status: ConversationsStates.success));

        } catch (e) {
          CliLogger.error("conversation:participant-joined Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("conversation:participant-joined Error :  $e");
    }
  }

  participantLeftSocialArchived(){
    // Participant Left
    try {

      SharedWebSocket.socket?.on('conversation:participant-left', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("conversation:participant-left :  $data");

          // conversation:participant-left :  {conversationId: 6891db829fd423658d5c72ff}
          socialArchivedConversations.firstWhere((element) => element.conversationId == data['conversationId']).inConversation = false;
          emit(state.copyWith(
              status: ConversationsStates.success));
        } catch (e) {
          CliLogger.error("conversation:participant-left Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("conversation:participant-left Error :  $e");
    }
  }

  participantStartRecordingSocialArchived(){
    // Participant Start Recording
    try {

      SharedWebSocket.socket?.on('conversation:participant-started-recording', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("conversation:participant-started-recording :  $data");

          socialArchivedConversations.firstWhere((element) => element.conversationId == data['conversationId']).isRecording = true;
          emit(state.copyWith(
              status: ConversationsStates.success));

        } catch (e) {
          CliLogger.error("conversation:participant-started-recording Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("conversation:participant-started-recording Error :  $e");
    }
  }

  participantStopRecordingSocialArchived(){
    // Participant Stop Recording
    try {

      SharedWebSocket.socket?.on('conversation:participant-stop-recording', (data) {
        log("decoded data : \n$data");
        try {
          // final decodedData = jsonDecode(data);
          CliLogger.info("conversation:participant-stop-recording :  $data");

          socialArchivedConversations.firstWhere((element) => element.conversationId == data['conversationId']).isRecording = false;
          emit(state.copyWith(
              status: ConversationsStates.success));

        } catch (e) {
          CliLogger.error("conversation:participant-stop-recording Error :  $e");
        }
      });
    } catch (e) {
      CliLogger.error("conversation:participant-stop-recording Error :  $e");
    }
  }

  listenToStartTypingSocialArchived() {
    listenToStartTypingUseCase((conversationId) {
      socialArchivedConversations.firstWhere((element) => element.conversationId == conversationId).isTyping = true;
      emit(state.copyWith(
          status: ConversationsStates.success));
    });
  }

  listenToStopTypingSocialArchived(){
    listenToStopTypingUseCase((conversationId) {
      socialArchivedConversations.firstWhere((element) => element.conversationId == conversationId).isTyping = false;
      emit(state.copyWith(
          status: ConversationsStates.success));
    });
  }

  final int pageSize = 15;
  List<ConversationEntity> socialConversations = [];
  List<ConversationEntity> socialDeletedConversations = [];
  List<ConversationEntity> socialArchivedConversations = [];
  List<ConversationEntity> socialGreetConversations = [];
  List<ConversationEntity> socialLockedConversations = [];
  List<ConversationEntity> socialAnonymousConversations = [];
  List<DateTime> conversationLogs = [];
  bool isLoadingMoreConversationLogs = false;
  bool hasMoreDataConversationLogs = true;
  int currentPageConversationLogs = 1;
  bool isLoadingMoreSocialConversation = false;
  bool hasMoreDataSocialConversations = true;
  int currentPageSocialConversations = 1;
  bool isLoadingMoreSocialDeletedConversation = false;
  bool hasMoreDataSocialDeletedConversations = true;
  int currentPageSocialDeletedConversations = 1;
  bool isLoadingMoreSocialArchivedConversation = false;
  bool hasMoreDataSocialArchivedConversations = true;
  int currentPageSocialArchivedConversations = 1;
  bool isLoadingMoreSocialGreetConversation = false;
  bool hasMoreDataSocialGreetConversations = true;
  int currentPageSocialGreetConversations = 1;
  bool isLoadingMoreSocialLockedConversation = false;
  bool hasMoreDataSocialLockedConversations = true;
  int currentPageSocialLockedConversations = 1;
  bool isLoadingMoreSocialAnonymousConversation = false;
  bool hasMoreDataSocialAnonymousConversations = true;
  int currentPageSocialAnonymousConversations = 1;

  Future<void> loadInitialConversationLogs({required String conversationId}) async {
    conversationLogs.clear();
    currentPageConversationLogs = 1;
    hasMoreDataConversationLogs = true;
    emit(state.copyWith(status: ConversationsStates.loading));
    await _fetchConversationLogs(conversationId: conversationId);
  }

  Future<void> loadInitialSocialConversations() async {
    socialConversations.clear();
    currentPageSocialConversations = 1;
    hasMoreDataSocialConversations = true;
    emit(state.copyWith(status: ConversationsStates.loading));
    await _fetchSocialConversations();
  }

  Future<void> loadInitialSocialDeletedConversations() async {
    socialDeletedConversations.clear();
    currentPageSocialDeletedConversations = 1;
    hasMoreDataSocialDeletedConversations = true;
    emit(state.copyWith(status: ConversationsStates.loading));
    await _fetchSocialDeletedConversations();
  }

  Future<void> loadInitialSocialArchivedConversations() async {
    socialArchivedConversations.clear();
    currentPageSocialArchivedConversations = 1;
    hasMoreDataSocialArchivedConversations = true;
    emit(state.copyWith(status: ConversationsStates.loading));
    await _fetchSocialArchivedConversations();
  }

  Future<void> loadInitialSocialGreetConversations() async {
    socialGreetConversations.clear();
    currentPageSocialGreetConversations = 1;
    hasMoreDataSocialGreetConversations = true;
    emit(state.copyWith(status: ConversationsStates.loading));
    await _fetchSocialGreetConversations();
  }

  Future<void> loadInitialSocialLockedConversations() async {
    socialLockedConversations.clear();
    currentPageSocialLockedConversations = 1;
    hasMoreDataSocialLockedConversations = true;
    emit(state.copyWith(status: ConversationsStates.loading));
    await _fetchSocialLockedConversations();
  }

  Future<void> loadInitialSocialAnonymousConversations() async {
    socialAnonymousConversations.clear();
    currentPageSocialAnonymousConversations = 1;
    hasMoreDataSocialAnonymousConversations = true;
    emit(state.copyWith(status: ConversationsStates.loading));
    await _fetchSocialAnonymousConversations();
  }

  Future<void> getConversationLogs({required String conversationId}) async {
    if (hasMoreDataConversationLogs || isLoadingMoreConversationLogs) return;
    isLoadingMoreConversationLogs = true;
    emit(state.copyWith(status: ConversationsStates.loading));
    await _fetchConversationLogs(conversationId: conversationId);
  }

  Future<void> getSocialConversations() async {
    if (hasMoreDataSocialConversations || isLoadingMoreSocialConversation) return;
    isLoadingMoreSocialConversation = true;
    emit(state.copyWith(status: ConversationsStates.loading));
    await _fetchSocialConversations();
  }

  Future<void> getSocialDeletedConversations() async {
    if (hasMoreDataSocialDeletedConversations || isLoadingMoreSocialDeletedConversation) return;
    isLoadingMoreSocialDeletedConversation = true;
    emit(state.copyWith(status: ConversationsStates.loading));
    await _fetchSocialDeletedConversations();
  }

  Future<void> getSocialArchivedConversations() async {
    if (hasMoreDataSocialArchivedConversations || isLoadingMoreSocialArchivedConversation) return;
    isLoadingMoreSocialArchivedConversation = true;
    emit(state.copyWith(status: ConversationsStates.loading));
    await _fetchSocialArchivedConversations();
  }

  Future<void> getSocialGreetConversations() async {
    if (hasMoreDataSocialGreetConversations || isLoadingMoreSocialGreetConversation) return;
    isLoadingMoreSocialGreetConversation = true;
    emit(state.copyWith(status: ConversationsStates.loading));
    await _fetchSocialGreetConversations();
  }

  Future<void> getSocialLockedConversations() async {
    if (hasMoreDataSocialLockedConversations || isLoadingMoreSocialLockedConversation) return;
    isLoadingMoreSocialLockedConversation = true;
    emit(state.copyWith(status: ConversationsStates.loading));
    await _fetchSocialLockedConversations();
  }

  Future<void> getSocialAnonymousConversations() async {
    if (hasMoreDataSocialAnonymousConversations || isLoadingMoreSocialAnonymousConversation) return;
    isLoadingMoreSocialAnonymousConversation = true;
    emit(state.copyWith(status: ConversationsStates.loading));
    await _fetchSocialAnonymousConversations();
  }

  Future<void> _fetchConversationLogs({required String conversationId}) async {
    final result = await getConversationLogsUseCase(
      pagination: ConversationLogsPagination(
        page: currentPageConversationLogs,
        limit: pageSize,
        conversationId: conversationId,
      ),
    );

    result.fold(
      (l) {
        isLoadingMoreConversationLogs = false; // Reset loading state on error
        emit(state.copyWith(status: ConversationsStates.error, failure: l));
      },
      (data) {
        conversationLogs.addAll(data);
        if (data.length < pageSize) {
          hasMoreDataConversationLogs = false;
        } else {
          currentPageConversationLogs++;
        }
        isLoadingMoreConversationLogs = false;
        emit(state.copyWith(status: ConversationsStates.success));
      },
    );
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
        for (ConversationEntity conversation in data) {
          addUniqueSocialConversation(conversation);
        }
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

  void addUniqueSocialConversation(ConversationEntity conversation) {
    final exists = socialConversations.any(
          (c) => c.conversationId == conversation.conversationId,
    );

    if (!exists) {
      socialConversations.add(conversation);
    }
  }

  Future<void> _fetchSocialDeletedConversations() async {
    final result = await getDeletedSocialConversationsUseCase(
      pagination: ConversationPagination(
        page: currentPageSocialDeletedConversations,
        limit: pageSize,
      ),
    );

    result.fold(
      (l) {
        isLoadingMoreSocialDeletedConversation = false; // Reset loading state on error
        emit(state.copyWith(status: ConversationsStates.error, failure: l));
      },
      (data) {
        for (ConversationEntity conversation in data) {
          addUniqueSocialDeletedConversation(conversation);
        }
        if (data.length < pageSize) {
          hasMoreDataSocialDeletedConversations = false;
        } else {
          currentPageSocialDeletedConversations++;
        }
        isLoadingMoreSocialDeletedConversation = false;
        emit(state.copyWith(status: ConversationsStates.success));
      },
    );
  }

  void addUniqueSocialDeletedConversation(ConversationEntity conversation) {
    final exists = socialDeletedConversations.any(
          (c) => c.conversationId == conversation.conversationId,
    );

    if (!exists) {
      socialDeletedConversations.add(conversation);
    }
  }


  Future<void> _fetchSocialArchivedConversations() async {
    final result = await getSocialArchivedConversationsUseCase(
      pagination: ConversationPagination(
        page: currentPageSocialArchivedConversations,
        limit: pageSize,
      ),
    );

    result.fold(
      (l) {
        isLoadingMoreSocialArchivedConversation = false; // Reset loading state on error
        emit(state.copyWith(status: ConversationsStates.error, failure: l));
      },
      (data) {
        for (ConversationEntity conversation in data) {
          addUniqueSocialArchivedConversation(conversation);
        }

        if (data.length < pageSize) {
          hasMoreDataSocialArchivedConversations = false;
        } else {
          currentPageSocialArchivedConversations++;
        }
        isLoadingMoreSocialArchivedConversation = false;
        emit(state.copyWith(status: ConversationsStates.success));
      },
    );
  }

  void addUniqueSocialArchivedConversation(ConversationEntity conversation) {
    final exists = socialArchivedConversations.any(
          (c) => c.conversationId == conversation.conversationId,
    );

    if (!exists) {
      socialArchivedConversations.add(conversation);
    }
  }

  Future<void> _fetchSocialGreetConversations() async {
    final result = await getSocialGreetConversationsUseCase(
      pagination: ConversationPagination(
        page: currentPageSocialGreetConversations,
        limit: pageSize,
      ),
    );

    result.fold(
      (l) {
        isLoadingMoreSocialGreetConversation = false; // Reset loading state on error
        emit(state.copyWith(status: ConversationsStates.error, failure: l));
      },
      (data) {
        for (ConversationEntity conversation in data) {
          addUniqueSocialGreetConversation(conversation);
        }

        if (data.length < pageSize) {
          hasMoreDataSocialGreetConversations = false;
        } else {
          currentPageSocialGreetConversations++;
        }
        isLoadingMoreSocialGreetConversation = false;
        emit(state.copyWith(status: ConversationsStates.success));
      },
    );
  }

  void addUniqueSocialGreetConversation(ConversationEntity conversation) {
    final exists = socialGreetConversations.any(
          (c) => c.conversationId == conversation.conversationId,
    );

    if (!exists) {
      socialGreetConversations.add(conversation);
    }
  }

  Future<void> _fetchSocialLockedConversations() async {
    final result = await getSocialLockedConversationsUseCase(
      pagination: ConversationPagination(
        page: currentPageSocialLockedConversations,
        limit: pageSize,
      ),
    );

    result.fold(
      (l) {
        isLoadingMoreSocialLockedConversation = false; // Reset loading state on error
        emit(state.copyWith(status: ConversationsStates.error, failure: l));
      },
      (data) {
        for (ConversationEntity conversation in data) {
          addUniqueSocialLockedConversation(conversation);
        }

        if (data.length < pageSize) {
          hasMoreDataSocialLockedConversations = false;
        } else {
          currentPageSocialLockedConversations++;
        }
        isLoadingMoreSocialLockedConversation = false;
        emit(state.copyWith(status: ConversationsStates.success));
      },
    );
  }

  void addUniqueSocialLockedConversation(ConversationEntity conversation) {
    final exists = socialLockedConversations.any(
          (c) => c.conversationId == conversation.conversationId,
    );

    if (!exists) {
      socialLockedConversations.add(conversation);
    }
  }

  Future<void> _fetchSocialAnonymousConversations() async {
    final result = await getSocialAnonymousConversationsUseCase(
      pagination: ConversationPagination(
        page: currentPageSocialAnonymousConversations,
        limit: pageSize,
      ),
    );

    result.fold(
      (l) {
        isLoadingMoreSocialAnonymousConversation = false; // Reset loading state on error
        emit(state.copyWith(status: ConversationsStates.error, failure: l));
      },
      (data) {
        for (ConversationEntity conversation in data) {
          addUniqueSocialAnonymousConversation(conversation);
        }

        if (data.length < pageSize) {
          hasMoreDataSocialAnonymousConversations = false;
        } else {
          currentPageSocialAnonymousConversations++;
        }
        isLoadingMoreSocialAnonymousConversation = false;
        emit(state.copyWith(status: ConversationsStates.success));
      },
    );
  }

  void addUniqueSocialAnonymousConversation(ConversationEntity conversation) {
    final exists = socialAnonymousConversations.any(
          (c) => c.conversationId == conversation.conversationId,
    );

    if (!exists) {
      socialAnonymousConversations.add(conversation);
    }
  }

  void addConversationToSelectedSocialConversations({required ConversationEntity conversation}) {
    conversation.isSelected = true;
    selectedSocialConversation.add(conversation);
    emit(state.copyWith(status: ConversationsStates.success));
  }

  void removeConversationFromSelectedSocialConversations({required ConversationEntity conversation}) {
    conversation.isSelected = false;
    selectedSocialConversation.remove(conversation);
    emit(state.copyWith(status: ConversationsStates.success));
  }

  void clearSelectedSocialConversations() {
    for (ConversationEntity conversation in selectedSocialConversation) {
      conversation.isSelected = false;
    }
    selectedSocialConversation.clear();
    emit(state.copyWith(status: ConversationsStates.success));
  }

  Future<void> archiveSocialConversations() async {
    for (ConversationEntity conversation in selectedSocialConversation) {
      final result = await toggleArchivedConversationUseCase(conversationId: conversation.conversationId);
      result.fold((l) => null, (r) => null);
      conversation.isSelected = false;
      socialConversations.removeWhere((element) => element.conversationId == conversation.conversationId);
      addUniqueSocialArchivedConversation(conversation);
    }
    emit(state.copyWith(status: ConversationsStates.success));
  }


  Future<void> unArchiveSocialConversations() async {
    for (ConversationEntity conversation in selectedSocialConversation) {
      final result = await toggleArchivedConversationUseCase(conversationId: conversation.conversationId);
      result.fold((l) => null, (r) => null);
      conversation.isSelected = false;
      addUniqueSocialConversation(conversation);
      socialArchivedConversations.removeWhere((element) => element.conversationId == conversation.conversationId);
    }
    emit(state.copyWith(status: ConversationsStates.success));
  }

  Future<void> togglePinnedSocialConversations() async {
    for (ConversationEntity conversation in selectedSocialConversation) {
      conversation.isPinned = !conversation.isPinned;
      await togglePinnedConversationUseCase(conversationId: conversation.conversationId);
    }
    await loadInitialSocialConversations();
    emit(state.copyWith(status: ConversationsStates.success));
  }

  Future<void> toggleMuteSocialConversations() async {
    for (ConversationEntity conversation in selectedSocialConversation) {
      conversation.isMuted = !conversation.isMuted;
      await toggleMuteConversationUseCase(conversationId: conversation.conversationId);
    }
    await loadInitialSocialConversations();
    emit(state.copyWith(status: ConversationsStates.success));
  }

  Future<void> deleteConversations() async {
    var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
    showLoadingDialog(currentContext);
    final result = await deleteConversationsUseCase(conversationIds: selectedSocialConversation.map((conversation) => conversation.conversationId).toList());
    result.fold((l){
      clearSelectedSocialConversations();
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      currentContext.pop();
      emit(state.copyWith(status: ConversationsStates.error, failure: l));
    }, (r) {
      for (ConversationEntity conversation in selectedSocialConversation) {
        conversation.isSelected = false;
        socialConversations.removeWhere((element) => element.conversationId == conversation.conversationId);
      }
      clearSelectedSocialConversations();
      showSuccessMessage(currentContext, currentContext.isArabic? "تم حذف المحادثات بنجاح":"Conversations deleted successfully");
      currentContext.pop();
      emit(state.copyWith(status: ConversationsStates.success));
    });
  }

  Future<void> restoreConversations(
      {required String subCategoryId}
      ) async {
    var currentContext = AppPages.router.configuration.navigatorKey.currentContext!;
    showLoadingDialog(currentContext);
    final result = await restoreConversationsUseCase(conversationIds: selectedSocialConversation.map((conversation) => conversation.conversationId).toList());
    result.fold((l){
      clearSelectedSocialConversations();
      currentContext.pop();
      String errorName =
      getFailureName(l, AppPages.router.configuration.navigatorKey.currentContext!);
      errorName == 'Insufficient Funds'
          ? showDebtDialog(
          AppPages.router.configuration.navigatorKey.currentContext!,
          subCategoryId,
          AppPages.router.configuration.navigatorKey.currentContext!.isArabic
              ? "الرصيد غير كافي"
              : "Insufficient funds")
          : errorName == 'SubscribeError'
          ? showSubscribeDialog(
        title: AppPages.router.configuration.navigatorKey.currentContext!.isArabic?
        "يرجى الاشتراك لاستعادة المحادثات" : "Please subscribe to restore conversations",
          AppPages.router.configuration.navigatorKey.currentContext!, subCategoryId)
          : showErrorMessage(AppPages.router.configuration.navigatorKey.currentContext!,
          getFailureMessage(l, AppPages.router.configuration.navigatorKey.currentContext!));

      emit(state.copyWith(status: ConversationsStates.error, failure: l));
    }, (r) {
      clearSelectedSocialConversations();
      showSuccessMessage(currentContext, currentContext.isArabic? "تم استعادة المحادثات بنجاح":"Conversations restored successfully");
      currentContext.pop();
      loadInitialSocialConversations();
      emit(state.copyWith(status: ConversationsStates.success));
    });
  }

  Future<void> getUnreadConversationsCount() async {
    final result = await getUnreadConversationsUseCase();
    result.fold((l) => null, (r) {
      unreadConversationsCount = r;
      emit(state.copyWith(status: ConversationsStates.success));
    });
  }
}
