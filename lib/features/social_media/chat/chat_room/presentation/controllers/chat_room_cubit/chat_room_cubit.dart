import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/file_extension.dart';
import 'package:fourtyninehub/core/extensions/map_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_shared_contacts_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_messages_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_delivered_messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_seen_messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/mark_message_as_seen_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/send_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/stop_listen_to_delivered_messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/stop_listen_to_seen_messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

part 'chat_room_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final SendMessageUseCase _sendMessageUseCase;
  final GetMessagesUseCase _getMessagesUseCase;
  final MarkMessageAsSeenUseCase _markMessageAsSeenUseCase;
  final ListenToSeenMessagesUseCase _listenToSeenMessagesUseCase;
  final StopListenToSeenMessagesUseCase _stopListenToSeenMessagesUseCase;
  final ListenToDeliveredMessagesUseCase _listenToDeliveredMessagesUseCase;
  final StopListenToDeliveredMessagesUseCase
      _stopListenToDeliveredMessagesUseCase;
  final ScrollController scrollController = ScrollController();
  final TextEditingController messageTextController = TextEditingController();
  final FilePicker _filePicker = FilePicker.platform;
  List<File> media = [];
  List<MessageSharedContactsEntity> sharedContacts = [];
  List<MessageSharedContactsEntity> selectedContactsToShare = [];
  Map<String, MessageEntity> _messages = {};
  List<MessageEntity> mediaMessages = [];
  List<MessageEntity> documentMessages = [];
  List<MessageEntity> linksMessages = [];
  MessageEntity? _replayMessage;
  late ChatEntity _chat;

  ChatRoomCubit(
    this._sendMessageUseCase,
    this._getMessagesUseCase,
    this._markMessageAsSeenUseCase,
    this._listenToSeenMessagesUseCase,
    this._stopListenToSeenMessagesUseCase,
    this._listenToDeliveredMessagesUseCase,
    this._stopListenToDeliveredMessagesUseCase,
  ) : super(const ChatRoomState()) {
    _listenToDeliveredMessages();
    _listenToSeenMessages();
    serviceLocator<Socket>().emit('Chat:getRooms');
  }

  Future<void> init({required ChatEntity chat}) async {
    _chat = chat;
    await _getMessages();
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
      log(message.text);
      for (var media in message.media) {
        log(media.url);
      }
      _messages[message.id] = message;
      emit(state.copyWith(
          messages: _messages.values.toList(), status: ChatRoomStates.success));

      _scrollDown();
      if (!message.byMe) {
        _markMessageAsSeen();
      }
    }
  }

  // =========================================== send message ===========================================

  Future<void> sendMessage() async {
    final result = await _sendMessageUseCase(SendMessageParams(
        replyMessageId: _replayMessage?.id,
        message: messageTextController.text,
        chat: _chat,
        media: media,
        sharedContacts: selectedContactsToShare,
        oneTimeView: false));
    result.fold(
        (l) => emit(state.copyWith(failure: l, status: ChatRoomStates.error)),
        (r) {
      cancelReplay();
      messageTextController.text = '';
      media.clear();
      selectedContactsToShare.clear();
      sharedContacts.clear();
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

  // =========================================== seen ============================================

  Future<void> _markMessageAsSeen() async {
    await _markMessageAsSeenUseCase(MarkMessageAsSeenParams(chatId: _chat.id));
  }

  void _listenToSeenMessages() async {
    _listenToSeenMessagesUseCase.call((messages) {
      for (final message in messages) {
        if (message.chatId == _chat.id) {
          _messages[message.id]?.markAsSeen();
          emit(state.copyWith(messages: _messages.values.toList()));
        }
      }
    });
  }

  void _listenToDeliveredMessages() async {
    List<MessageEntity> messagesList = [];
    _listenToDeliveredMessagesUseCase.call((chatId) {
      if (chatId == _chat.id) {
        messagesList = _messages.values.toList();

        for (int i = messagesList.length - 1;
            i >= 0 && !(messagesList[i].seen);
            i--) {
          messagesList[i].markAsDelivered();
        }
        emit(state.copyWith(messages: messagesList));
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
          media.add(File(file.path!));
        }
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
          media.add(File(file.path!));
        }
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
          media.add(File(file.path!));
        }
      }
    } catch (e) {
      CliLogger.error('Error picking file: $e');
      if (e is PlatformException) {
        showPermissionDialog(message: 'Please allow access to files');
      }
    }
  }

  void convertContactsToSharedContacts(
      {required List<Contact>? contacts}) async {
    try {
      if (contacts != null) {
        for (var contact in contacts) {
          if (contact.phones.isNotEmpty) {
            // log(contact.toString());
            sharedContacts.add(MessageSharedContactsEntity(
              name: contact.displayName,
              phoneNumber: contact.phones[0].number,
            ));
          }
        }
      }
    } catch (e) {
      CliLogger.error('Error picking file: $e');
    }
  }

  addToSelectedContacts({required MessageSharedContactsEntity contact}) {
    selectedContactsToShare.add(contact);
  }

  removeFromSelectedContacts({required MessageSharedContactsEntity contact}) {
    selectedContactsToShare
        .removeWhere((element) => contact.name == element.name);
  }

  checkRegirterdContacts(
      {required List<MessageSharedContactsEntity> contacts}) {
    for (var contact in contacts) {
      for (var myContact in sharedContacts) {
        if (contact.name == myContact.name ||
            contact.phoneNumber == myContact.phoneNumber) {
          contact.isRegistered = true;
          break;
        }
      }
    }
  }

  // =========================================================================================================

  void _scrollDown() => Timer(const Duration(milliseconds: 200),
      () => scrollController.jumpTo(scrollController.position.maxScrollExtent));

  @override
  Future<void> close() {
    _stopListenToSeenMessagesUseCase(const NoParams());
    _stopListenToDeliveredMessagesUseCase(const NoParams());
    return super.close();
  }
}
