import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/file_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/deleteMessage_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/delete_message_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_messages_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/send_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

part 'chat_room_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final DeleteChatMessageUseCase _deleteChatMessageUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  final GetMessagesUseCase _getMessagesUseCase;
  final ScrollController scrollController = ScrollController();
  MessageEntity? _replayMessage;
  late ChatEntity _chat;
  final FilePicker _filePicker = FilePicker.platform;
  List<MessageEntity> _messages = [];

  ChatRoomCubit(
    this._deleteChatMessageUseCase,
    this._sendMessageUseCase,
    this._getMessagesUseCase,
  ) : super(const ChatRoomState());

  void init({required ChatEntity chat}) {
    _chat = chat;
    _getMessages();
  }

  Future<void> _getMessages() async {
    _messages.clear();
    final response = await _getMessagesUseCase(GetMessagesParams(
        chatId: _chat.id, pagination: PaginationParams.basic()));

    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: ChatRoomStates.error)),
        (data) {
      _messages = data;
      emit(state.copyWith(messages: _messages));
    });
  }

  Future<void> sendMessage({required String message}) async {
    _sendMessageUseCase(SendMessageParams(
        replyMessageId: _replayMessage?.id,
        message: message,
        chatId: _chat.id,
        mediaIds: [],
        oneTimeView: false));
  }

  typingMessage() {}

  listenToMessageTyping() {
    // _socketService.socketChatTypingStream.listen((event) {
    //   debugPrint("chatListen $event");
    //
    //   List<TypingAndOnlineModel> chatsIds = event ?? [];
    //   chatsIds.map((e) {}).toList();
    //
    //   emit.call(state.copyWith(
    //       chatData: chatMessagesModel,
    //       messages: chatMessages,
    //       status: ChatRoomStates.typing));
    // });
  }

  deleteMessage({required String chatId, required String messageId}) async {
    DeleteMessageParams deleteMessageParams =
        DeleteMessageParams(chatId: chatId, messageId: messageId);
    await _deleteChatMessageUseCase.call(deleteMessageParams);
    // getMessages();
  }

  void selectMessageForReplaying(MessageEntity message) {
    _replayMessage = message;
    emit(state.copyWith(replayedMessage: _replayMessage));
  }

  void cancelReplay() {
    _replayMessage = null;
    emit(state.copyWith(replayedMessage: _replayMessage));
  }

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

  void _scrollDown() => Timer(const Duration(milliseconds: 200),
      () => scrollController.jumpTo(scrollController.position.maxScrollExtent));
}
