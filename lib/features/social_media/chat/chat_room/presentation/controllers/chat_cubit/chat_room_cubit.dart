import 'dart:async';
import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/common/functions/helper/file_picker_helper.dart';
import 'package:fourtyninehub/common/widgets/stateful/picker/image_picker.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/core/service/socket_service.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_tokens_use_case.dart';
import 'package:fourtyninehub/features/authentication/domain/use_cases/get_user_use_case.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/chat_messgaes_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/data/models/typing_and_online_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/deleteMessage_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/delete_message_request.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/getChatMessages_usecase.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

part 'chat_view_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final GetTokensUseCase _getTokensUseCase;
  final GetChatMessagesUseCase _getChatMessagesUseCase;
  final GetUserUseCase _getUserUseCase;
  final DeleteChatMessageUseCase _deleteChatMessageUseCase;
  final SocketServiceContract _socketService;
  List<MessageEntity> chatMessages = [];
  ChatMessagesModel chatMessagesModel = ChatMessagesModel();
  final ScrollController? scrollController = ScrollController();

  String? userToken;
  String? userId;
  String? chatId;
  final ImagePicker _imagePicker = ImagePicker();
  final FilePicker _filePicker = FilePicker.platform;

  ChatRoomCubit(
    this._getTokensUseCase,
    this._getChatMessagesUseCase,
    this._deleteChatMessageUseCase,
    this._getUserUseCase,
    this._socketService,
  ) : super(const ChatRoomState());

  Future<String?> getUserToken() async {
    return _getTokensUseCase(const NoParams()).then((value) {
      return value.fold((l) => null, (r) => r?.accessToken);
    });
  }

  // _joinRoom(String chatId) async {
  //   _socketService.joinRoom(chatId);
  // }

  // BehaviorSubject<List<MessageEntity>> messages =
  //     BehaviorSubject<List<MessageEntity>>();

  getChatMessages(String chatID) async {
    chatId = chatID;
    final response = await _getChatMessagesUseCase.call(chatID);
    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: ChatRoomStates.error)),
        (data) {
      chatMessages = data.messages ?? [];
      chatMessagesModel = data;

      emit(state.copyWith(
          chatData: data,
          chatMessages: data.messages!,
          status: ChatRoomStates.initState));
    });

    Timer(
        const Duration(milliseconds: 200),
        () => scrollController!
            .jumpTo(scrollController!.position.maxScrollExtent));

    // to listen new message
    listenToNewMessages();
  }

  Future<void> sendMessage(
      {required String message, String? replyMessageId}) async {
    if (chatId != null) {
      _socketService.sendMessage(
          message: message, chatId: chatId!, replyMessageId: replyMessageId);
      // emit.call(state.copyWith(
      //     chatData: chatMessagesModel,
      //     chatMessages: chatMessages.reversed.toList(),
      //     status: ChatRoomStates.initState));
    } else {
      debugPrint("Error chat id not found");
    }
  }

  Future<void> sendMessageFromTinder(
      {required String message,
      String? replyMessageId,
      required chatID}) async {
    if (chatID != null) {
      _socketService.sendMessage(
          message: message, chatId: chatID!, replyMessageId: replyMessageId);

      log("anonymous message sent =================");
      // emit.call(state.copyWith(
      //     chatData: chatMessagesModel,
      //     chatMessages: chatMessages.reversed.toList(),
      //     status: ChatRoomStates.initState));
    } else {
      debugPrint("Error chat id not found");
    }
  }

  typingMessage() {
    _socketService.typingMessage(chatId: chatId!);
  }

  Future<void> getUser() async {
    final result = await _getUserUseCase(const NoParams());
    result.fold(
      (failure) {
        userId = '';
      },
      (user) {
        userId = user.id;
      },
    );
  }

  listenToNewMessages() {
    _socketService.socketMessageStream.listen((event) {
      chatMessages.add(event);
      emit.call(state.copyWith(
          chatData: chatMessagesModel,
          chatMessages: chatMessages,
          status: ChatRoomStates.initState));

      Timer(
          const Duration(milliseconds: 200),
          () => scrollController!
              .jumpTo(scrollController!.position.maxScrollExtent));
    });
  }

  listenToMessageTyping() {
    _socketService.socketChatTypingStream.listen((event) {
      debugPrint("chatListen $event");

      List<TypingAndOnlineModel> chatsIds = event ?? [];
      chatsIds.map((e) {}).toList();

      emit.call(state.copyWith(
          chatData: chatMessagesModel,
          chatMessages: chatMessages,
          status: ChatRoomStates.typing));
    });
  }

  deleteMessage({required String chatId, required String messageId}) async {
    DeleteMessageParams deleteMessageParams =
        DeleteMessageParams(chatId: chatId, messageId: messageId);
    await _deleteChatMessageUseCase.call(deleteMessageParams);
    getChatMessages(chatId);
  }

  Future<void> pickDocuments() async {
    try {
      // Pick document files only
      if (await Permission.storage.request().isGranted) {
        FilePickerResult? result = await _filePicker.pickFiles(
          type: FileType.custom,
          allowMultiple: true,
          allowedExtensions: [
            'doc',
            'docx',
            'pdf',
            'txt',
            'xls',
            'xlsx',
            'ppt',
            'pptx'
          ],
        );

        if (result != null) {
          // File picked successfully

          for (var file in result.files) {
            debugPrint('Picked file: ${file.name}');
          }
          // Handle the file (e.g., upload, read, etc.)
        } else {
          // User canceled the picker
          debugPrint('File picking canceled');
        }
      } else {
        showPermissionDialog(message: 'Please allow storage permission');
      }
    } catch (e) {
      CliLogger.error('Error picking file: $e');
    }
  }

  Future<void> pickMedia() async {
    try {
      // Pick document files only
      if (await Permission.storage.request().isGranted) {
        FilePickerResult? result = await _filePicker.pickFiles(
          type: FileType.custom,
          allowMultiple: true,
          allowedExtensions: [
            // Image Extensions
            'jpg', 'jpeg', 'png', 'gif', 'bmp', 'tiff', 'webp', 'heic', 'svg',
            // Video Extensions
            'mp4', 'mov', 'avi', 'mkv', 'flv', 'wmv', 'webm', 'm4v', '3gp'
          ],
        );

        if (result != null) {
          // File picked successfully

          for (var file in result.files) {
            debugPrint('Picked file: ${file.name}');
          }
          // Handle the file (e.g., upload, read, etc.)
        } else {
          // User canceled the picker
          debugPrint('File picking canceled');
        }
      } else {
        showPermissionDialog(message: 'Please allow storage permission');
      }
    } catch (e) {
      CliLogger.error('Error picking file: $e');
    }
  }

  Future<void> pickAudio() async {
    try {
      // Pick document files only
      if (await Permission.storage.request().isGranted) {
        FilePickerResult? result = await _filePicker.pickFiles(
          type: FileType.custom,
          allowMultiple: true,
          allowedExtensions: [
            'mp3', // MPEG Layer 3 Audio
            'wav', // Waveform Audio File Format
            'flac', // Free Lossless Audio Codec
            'aac', // Advanced Audio Codec
            'ogg', // Ogg Vorbis Audio
            'm4a', // MPEG-4 Audio
            'wma', // Windows Media Audio
            'alac', // Apple Lossless Audio Codec
            'opus', // Opus Audio
            'aiff', // Audio Interchange File Format
          ],
        );

        if (result != null) {
          // File picked successfully

          for (var file in result.files) {
            debugPrint('Picked file: ${file.name}');
          }
          // Handle the file (e.g., upload, read, etc.)
        } else {
          // User canceled the picker
          debugPrint('File picking canceled');
        }
      } else {
        showPermissionDialog(message: 'Please allow storage permission');
      }
    } catch (e) {
      CliLogger.error('Error picking file: $e');
    }
  }

  Future<void> pickFromCamera() async {
    try {
      _imagePicker.pickImage(source: ImageSource.gallery);
    } catch (e) {
      debugPrint('Error picking file: $e');
    }
  }

  @override
  Future<void> close() {
    // _socketService.disposeSocket();
    return super.close();
  }
}
