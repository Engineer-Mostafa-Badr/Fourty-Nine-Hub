import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/file_extension.dart';
import 'package:fourtyninehub/core/extensions/map_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/deleteMessage_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/delete_message_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_messages_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_seen_messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/mark_message_as_seen_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/send_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/stop_listen_to_seen_messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

part 'chat_room_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final DeleteChatMessageUseCase _deleteChatMessageUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final GetMessagesUseCase _getMessagesUseCase;
  final MarkMessageAsSeenUseCase _markMessageAsSeenUseCase;
  final ListenToSeenMessagesUseCase _listenToSeenMessagesUseCase;
  final StopListenToSeenMessagesUseCase _stopListenToSeenMessagesUseCase;
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageTextController = TextEditingController();
  final FilePicker _filePicker = FilePicker.platform;

  Map<String, MessageEntity> _messages = {};
  MessageEntity? _replayMessage;
  late ChatEntity _chat;

  ChatRoomCubit(
    this._deleteChatMessageUseCase,
    this._sendMessageUseCase,
    this._getMessagesUseCase,
    this._markMessageAsSeenUseCase,
    this._listenToSeenMessagesUseCase,
    this._stopListenToSeenMessagesUseCase,
  ) : super(const ChatRoomState()) {
    _listenToSeenMessages();
  }

  void init({required ChatEntity chat}) {
    _chat = chat;
    _getMessages();
  }

// =========================================== get messages ===========================================
  Future<void> _getMessages() async {
    _messages.clear();
    final response = await _getMessagesUseCase(GetMessagesParams(
        chatId: _chat.id, pagination: PaginationParams(limit: 20, page: 1)));

    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: ChatRoomStates.error)),
        (data) {
      for (final message in data) {
        _messages[message.id] = message;
      }
      _messages = _messages.reverse();
      emit(state.copyWith(messages: _messages.values.toList()));
      _scrollDown();
    });
  }

  void addMessage(MessageEntity message) {
    if (message.chatId == _chat.id) {
      if (!message.byMe) {
        _markMessageAsSeen(message);
      }
      _messages[message.id] = message;
      emit(state.copyWith(
          messages: _messages.values.toList(), status: ChatRoomStates.success));

      _scrollDown();
    }
  }

  // =========================================== send message ===========================================

  Future<void> sendMessage() async {
    final result = await _sendMessageUseCase(SendMessageParams(
        replyMessageId: _replayMessage?.id,
        message: messageTextController.text,
        chatId: _chat.id,
        mediaIds: [],
        oneTimeView: false));
    result.fold(
        (l) => emit(state.copyWith(failure: l, status: ChatRoomStates.error)),
        (r) {
      cancelReplay();
      messageTextController.text = '';
    });
  }

  void selectMessageForReplaying(MessageEntity message) {
    _replayMessage = message;
    emit(state.copyWith(replayedMessage: _replayMessage));
  }

  void cancelReplay() {
    _replayMessage = null;
    emit(state.copyWith(replayedMessage: _replayMessage));
  }

  // =========================================== delete message ===========================================

  deleteMessage({required String chatId, required String messageId}) async {
    DeleteMessageParams deleteMessageParams =
        DeleteMessageParams(chatId: chatId, messageId: messageId);
    await _deleteChatMessageUseCase.call(deleteMessageParams);
    // getMessages();
  }

  // =========================================== seen ============================================

  Future<void> _markMessageAsSeen(MessageEntity message) async {
    await _markMessageAsSeenUseCase
        .call(MarkMessageAsSeenParams(chatId: _chat.id));
  }

  void _listenToSeenMessages() async {
    _listenToSeenMessagesUseCase.call((messages) {
      for (final message in messages) {
        if (message.chatId == _chat.id) {
          _messages[message.id] = message;
          emit(state.copyWith(messages: _messages.values.toList()));
        }
      }
    });
  }

  // =========================================== pick attachments ===========================================
  Future<void> pickDocuments() async {
    try {
      FilePickerResult? result = await _filePicker.pickFiles(
        type: FileType.custom,
        allowMultiple: true,
        allowedExtensions: docsExtensions,
      );

      if (result != null) {
        for (var file in result.files) {
          debugPrint('Picked file: ${file.name}');
        }
      } else {
        debugPrint('File picking canceled');
      }
    } catch (e) {
      CliLogger.error('Error picking file: $e');
      if (e is PlatformException) {
        showPermissionDialog(message: 'Please allow access to files');
      }
    }
  }

  Future<void> pickMedia() async {
    try {
      FilePickerResult? result = await _filePicker.pickFiles(
        type: FileType.media,
        allowMultiple: true,
      );

      if (result != null) {
        for (var file in result.files) {
          debugPrint('Picked file: ${file.name}');
        }
      } else {
        debugPrint('File picking canceled');
      }
    } catch (e) {
      CliLogger.error('Error picking file: $e');
      if (e is PlatformException) {
        showPermissionDialog(message: 'Please allow access to files');
      }
    }
  }

  Future<void> pickAudio() async {
    try {
      FilePickerResult? result = await _filePicker.pickFiles(
        type: FileType.audio,
        allowMultiple: true,
      );

      if (result != null) {
        for (var file in result.files) {
          debugPrint('Picked file: ${file.name}');
        }
      } else {
        debugPrint('File picking canceled');
      }
    } catch (e) {
      CliLogger.error('Error picking file: $e');
      if (e is PlatformException) {
        showPermissionDialog(message: 'Please allow access to files');
      }
    }
  }

  // =========================================================================================================

  void _scrollDown() => Timer(const Duration(milliseconds: 200),
      () => scrollController.jumpTo(scrollController.position.maxScrollExtent));

  @override
  Future<void> close() {
    _stopListenToSeenMessagesUseCase(const NoParams());
    return super.close();
  }
}
