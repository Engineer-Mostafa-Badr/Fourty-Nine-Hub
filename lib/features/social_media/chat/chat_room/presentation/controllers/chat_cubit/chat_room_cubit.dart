import 'dart:async';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/file_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_user_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/deleteMessage_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/delete_message_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_messages_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_new_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/send_message_usecase.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

part 'chat_room_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final GetMessagesUseCase _getMessagesUseCase;
  final DeleteChatMessageUseCase _deleteChatMessageUseCase;
  final ListenToNewMessageUseCase _listenToNewMessageUseCase;
  final SendMessageUseCase _sendMessageUseCase;
  List<MessageEntity> chatMessages = [];

   final ScrollController scrollController = ScrollController();
   final StreamController<MessageEntity> messagesStreamController  = StreamController<MessageEntity>();

  String? chatId;
  final FilePicker _filePicker = FilePicker.platform;

  ChatRoomCubit(
    this._listenToNewMessageUseCase,
    this._getMessagesUseCase,
    this._deleteChatMessageUseCase,
    this._sendMessageUseCase,
  ) : super(const ChatRoomState());

  Future<void> getMessages(String chatID) async {
    emit(state.copyWith(status: ChatRoomStates.loading));
    chatId = chatID;
    final response = await _getMessagesUseCase(GetMessagesParams(
        chatId: chatID, pagination: PaginationParams(limit:50, page: 1)));
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: ChatRoomStates.error)),
        (data) {
      chatMessages = data;

      emit(state.copyWith(
          messages: chatMessages, status: ChatRoomStates.success));
      _scrollDown();
      listenToNewMessages();
    });
  }

  Future<void> sendMessage(
      {required String message, String? replyMessageId}) async {
    if (chatId != null) {
      _sendMessageUseCase(SendMessageParams(
          message: message, chatId: chatId!, mediaIds: [], oneTimeView: false));
    } else {
      CliLogger.error("Error chat id not found");
    }
  }

  typingMessage() {}

  listenToNewMessages() {
    messagesStreamController.stream.listen((message) {
      chatMessages.add(message);
      emit(state.copyWith(
          // chatData: chatMessagesModel,
          messages: chatMessages,
          status: ChatRoomStates.success));
    });

    _listenToNewMessageUseCase(
      (message) {
        messagesStreamController.add(message);
      },
    );
  }

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
    getMessages(chatId);
  }

  void selectMessageForReplaying(MessageEntity message) {
    emit(state.copyWith(replayedMessage: message));
  }

  void cancelReplay() {
    emit(state.copyWith(replayedMessage: null));
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
