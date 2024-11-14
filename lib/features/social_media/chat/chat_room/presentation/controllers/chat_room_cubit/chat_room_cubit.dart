import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/data/datasources/remote/socket/socket_data_source.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/extensions/file_extension.dart';
import 'package:fourtyninehub/core/extensions/map_extension.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_shared_contacts_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/clear_chat_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_chat_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_messages_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/get_one_time_view_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_clear_chat_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_delivered_messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_one_time_message_seen.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_pin_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_record_listend.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_seen_messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/listen_to_unpin_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/mark_message_as_seen_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/pin_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/send_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/set_record_as_listened.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/start_recording_uecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/start_typing_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/stop_listen_to_delivered_messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/stop_listen_to_seen_messages.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/stop_recording_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/stop_typing_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/usecases/unpin_message_usecase.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';
import 'package:fourtyninehub/service_locator/service_locator.dart';
import 'package:icons_launcher/utils/cli_logger.dart';
import 'package:socket_io_client/socket_io_client.dart';

part 'chat_room_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final SendMessageUseCase _sendMessageUseCase;
  final GetMessagesUseCase _getMessagesUseCase;
  final GetChatUseCase _getChatUseCase;
  final GetOneTimeViewMessageUseCase _getOneTimeMessageUseCase;
  final MarkMessageAsSeenUseCase _markMessageAsSeenUseCase;
  final ListenToSeenMessagesUseCase _listenToSeenMessagesUseCase;
  final SetRecordAsListenedUseCase _setRecordAsListenedUseCase;
  final ListenToRecordListened _listenToRecordListenedUseCase;
  final StopListenToSeenMessagesUseCase _stopListenToSeenMessagesUseCase;
  final ListenToDeliveredMessagesUseCase _listenToDeliveredMessagesUseCase;
  final ListenToOneTimeMessageSeenUseCase _listenToOneTimeMessageSeenUseCase;
  final StartTypingMessageUseCase _startTypingMessageUseCase;
  final StopTypingMessageUseCase _stopTypingMessageUseCase;
  final StartRecordingMessageUseCase _startRecordingMessageUseCase;
  final StopRecordingMessageUseCase _stopRecordingMessageUseCase;
  final PinMessageUseCase _pinMessageUseCase;
  final UnPinMessageUseCase _unpinMessageUseCase;
  final ListenToPinMessageUseCase _listenToPinMessageUseCase;
  final ListenToUnPinMessageUseCase _listenToUnPinMessageUseCase;
  final StopListenToDeliveredMessagesUseCase
      _stopListenToDeliveredMessagesUseCase;
  final ClearChatUseCase _clearChatUseCase;
  final ListenToClearChatUseCase _listenToClearChatUseCase;
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

  late ChatEntity chat;
  bool isOneTimeView = false;
  List<MessageEntity> selectedMessages = [];
  List<ChatEntity> selectedChatsToForword = [];

  ChatRoomCubit(
    this._sendMessageUseCase,
    this._getMessagesUseCase,
    this._getChatUseCase,
    this._markMessageAsSeenUseCase,
    this._listenToSeenMessagesUseCase,
    this._stopListenToSeenMessagesUseCase,
    this._listenToDeliveredMessagesUseCase,
    this._stopListenToDeliveredMessagesUseCase,
    this._startTypingMessageUseCase,
    this._stopTypingMessageUseCase,
    this._startRecordingMessageUseCase,
    this._stopRecordingMessageUseCase,
    this._getOneTimeMessageUseCase,
    this._setRecordAsListenedUseCase,
    this._listenToRecordListenedUseCase,
    this._listenToOneTimeMessageSeenUseCase,
    this._clearChatUseCase,
    this._listenToClearChatUseCase,
    this._pinMessageUseCase,
    this._unpinMessageUseCase,
    this._listenToPinMessageUseCase,
    this._listenToUnPinMessageUseCase,
  ) : super(const ChatRoomState()) {
    _listenToDeliveredMessages();
    _listenToSeenMessages();
    _listenToSeenOneTimeViewMessages();
    listenToRecordListenedUseCase();
    _listenToClearChat();
    _listenToPinMessage();
    _listenToUnPinMessage();
    serviceLocator<Socket>().emit('Chat:getRooms');
  }

  Future<void> init({required ChatEntity selectedChat}) async {
    chat = selectedChat;
    String? getChatPinnedMessage = await _getChat();
    log("Get Chat pinned message id after get chat: ${chat.pinnedMessageId}");
    if (getChatPinnedMessage != null) {
      chat.pinnedMessageId = getChatPinnedMessage;
      log("Get Chat pinned message id: ${chat.pinnedMessageId}");
    }
    await _getMessages();
  }

  Future<String?> _getChat() async {
    final response = await _getChatUseCase(GetChatParams(chatId: chat.id));
    return response.fold((failure) {
      log("Get Chat _getChat failure from get chat: $failure");
      return null;
    },
        // ignore: void_checks
        (data) {
      log("Get Chat _getChat: $data");
      return data;
    });
  }

  void addMessageToSelectedMessages({required MessageEntity message}) {
    selectedMessages.add(message);
    message.isSelected = true;
    emit(state.copyWith(status: ChatRoomStates.messagesSelected));
  }

  void removeMessageFromSelectedMessages({required MessageEntity message}) {
    selectedMessages
        .removeWhere((messageIterator) => messageIterator.id == message.id);
    message.isSelected = false;
    emit(state.copyWith(status: ChatRoomStates.messagesSelected));
  }

  void clearSelectedMessages() {
    for (var message in selectedMessages) {
      message.isSelected = false;
    }
    selectedMessages.clear();
    emit(state.copyWith(status: ChatRoomStates.messagesSelected));
  }

  Future<void> copyMessage(MessageEntity message) async {
    await Clipboard.setData(ClipboardData(text: message.text));
  }

// =========================================== get messages ===========================================
  Future<void> _getMessages() async {
    _messages.clear();
    final response = await _getMessagesUseCase(GetMessagesParams(
        chatId: chat.id, pagination: PaginationParams(limit: 20, page: 1)));

    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: ChatRoomStates.error)),
        (data) {
      for (final message in data) {
        _messages[message.id] = message;
      }
      _messages = _messages.reverse();

      log("Get Chat _getMessages pinned message id: $chat.pinnedMessageId");
      if (chat.pinnedMessageId != null) {
        log("Get Chat _getMessages pinned message: ${_messages[chat.pinnedMessageId]}");
        chat.pinnedMessage = _messages[chat.pinnedMessageId];
      }
      emit(state.copyWith(
          messages: _messages.values.toList(), status: ChatRoomStates.success));
      _scrollDown();
    });
  }

  Future<void> clearChat({required bool clearForAll}) async {
    final response = await _clearChatUseCase(
        ClearChatParams(chatId: chat.id, clearForAll: clearForAll));

    response.fold(
        (failure) => emit(
            state.copyWith(failure: failure, status: ChatRoomStates.error)),
        (data) {
      log("clear chat result $data");
      chat.lastMessage = null;
      emit(state.copyWith(status: ChatRoomStates.success));
      _scrollDown();
    });
  }

  void _listenToClearChat() async {
    _listenToClearChatUseCase.call((chatId) {
      if (chatId == chat.id) {
        log("clear chat from cubit: ${chat.id}");
        log("messages length from cubit before clear: ${_messages.length}");
        _messages.clear();
        log("messages length from cubit after clear: ${_messages.length}");
        emit(state.copyWith(messages: _messages.values.toList()));
      }
    });
  }

  Future<void> startTyping() async {
    final result = await _startTypingMessageUseCase(chat.id);
    result.fold(
        (l) => emit(state.copyWith(failure: l, status: ChatRoomStates.error)),
        (r) async {
      log("start typing result $r");
      emit(state.copyWith(status: ChatRoomStates.success));
    });
  }

  Future<void> stopTyping() async {
    final result = await _stopTypingMessageUseCase(chat.id);
    result.fold(
        (l) => emit(state.copyWith(failure: l, status: ChatRoomStates.error)),
        (r) async {
      log("stop typing result $r");
      emit(state.copyWith(status: ChatRoomStates.success));
    });
  }

  Future<void> startRecording() async {
    final result = await _startRecordingMessageUseCase(chat.id);
    result.fold(
        (l) => emit(state.copyWith(failure: l, status: ChatRoomStates.error)),
        (r) async {
      log("start recording result $r");
      emit(state.copyWith(status: ChatRoomStates.success));
    });
  }

  Future<void> stopRecording() async {
    final result = await _stopRecordingMessageUseCase(chat.id);
    result.fold(
        (l) => emit(state.copyWith(failure: l, status: ChatRoomStates.error)),
        (r) async {
      log("stop recording result $r");
      emit(state.copyWith(status: ChatRoomStates.success));
    });
  }

  Future<void> pinMessage({required MessageEntity message}) async {
    final result = await _pinMessageUseCase(
        PinMessageParams(chatId: chat.id, messageId: message.id));
    result.fold(
        (l) => emit(state.copyWith(failure: l, status: ChatRoomStates.error)),
        (r) async {
      clearSelectedMessages();
      log("pin message result $r");
      emit(state.copyWith(status: ChatRoomStates.success));
    });
  }

  Future<void> unpinMessage() async {
    final result =
        await _unpinMessageUseCase(UnPinMessageParams(chatId: chat.id));
    result.fold(
        (l) => emit(state.copyWith(failure: l, status: ChatRoomStates.error)),
        (r) async {
      log("unpin message result $r");
      emit(state.copyWith(status: ChatRoomStates.success));
    });
  }

  void _listenToPinMessage() async {
    _listenToPinMessageUseCase.call((listenToPinMessageParams) {
      if (listenToPinMessageParams.chatId == chat.id) {
        log("Pin message from cubit: ${listenToPinMessageParams.messageId}");

        setPinnedMessage(listenToPinMessageParams.messageId);
      }
    });
  }

  void _listenToUnPinMessage() async {
    _listenToUnPinMessageUseCase.call((listenToUnPinMessageParams) {
      if (listenToUnPinMessageParams.chatId == chat.id) {
        log("UnPin message from cubit: ${listenToUnPinMessageParams.chatId}");

        unSetPinnedMessage();
      }
    });
  }

  void setPinnedMessage(String messageId) {
    chat.pinnedMessage = _messages[messageId];
    chat.pinnedMessageId = messageId;
    emit(state.copyWith(status: ChatRoomStates.success));
  }

  void unSetPinnedMessage() {
    chat.pinnedMessage = null;
    chat.pinnedMessageId = null;
    emit(state.copyWith(status: ChatRoomStates.success));
  }

  Future<void> setRecordAsListened({required MessageEntity message}) async {
    final result = await _setRecordAsListenedUseCase(
      SetRecordAsListenedParams(
        chatId: chat.id,
        messageId: message.id,
      ),
    );
    result.fold((l) {
      log("set record as listened error $l");
      // emit(state.copyWith(failure: l, status: ChatRoomStates.error));
    }, (r) async {
      log("set record as listened result $r");
      // emit(state.copyWith(status: ChatRoomStates.success));
    });
  }

  void addMessage(MessageEntity message) {
    if (message.chatId == chat.id) {
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
      chat: chat,
      media: media,
      sharedContacts: selectedContactsToShare,
      oneTimeView: isOneTimeView,
      isForward: false,
    ));
    result.fold(
        (l) => emit(state.copyWith(failure: l, status: ChatRoomStates.error)),
        (r) async {
      cancelReplay();
      messageTextController.text = '';
      media.clear();
      selectedContactsToShare.clear();
      sharedContacts.clear();
      isOneTimeView = false;
// Play notification sound
      log("sound before send message");
      final player = AudioPlayer(); // Initialize the player
      await player
          .play(AssetSource('ChatSounds/Send Message.mp3')); // Play the asset
      log("sound after send message");
    });
  }

  Future<void> forwardMessages() async {
    for (ChatEntity currentChat in selectedChatsToForword) {
      for (MessageEntity message in selectedMessages) {
        final result = await _sendMessageUseCase(SendMessageParams(
          replyMessageId: null,
          message: message.text,
          chat: currentChat,
          media: [],
          sharedContacts: [],
          oneTimeView: false,
          isForward: true,
        ));
        message.isSelected = false;
      }
      currentChat.isSelected = false;
    }
    selectedChatsToForword.clear();
    selectedMessages.clear();
    emit(state.copyWith(status: ChatRoomStates.success));
  }

  void addChatToSelectedChats({required ChatEntity chat}) {
    selectedChatsToForword.add(chat);
    chat.isSelected = true;
    emit(state.copyWith(status: ChatRoomStates.success));
  }

  void removeChatToSelectedChats({required ChatEntity chat}) {
    selectedChatsToForword.removeWhere((chatIterator) => chatIterator.id == chat.id);
    chat.isSelected = false;
    emit(state.copyWith(status: ChatRoomStates.success));
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
    await _markMessageAsSeenUseCase(MarkMessageAsSeenParams(chatId: chat.id));
  }

  void _listenToSeenMessages() async {
    _listenToSeenMessagesUseCase.call((messages) {
      for (final message in messages) {
        if (message.chatId == chat.id) {
          _messages[message.id]?.markAsSeen();
          emit(state.copyWith(messages: _messages.values.toList()));
        }
      }
    });
  }

  void _listenToSeenOneTimeViewMessages() async {
    _listenToOneTimeMessageSeenUseCase.call((message) {
      if (message.chatId == chat.id) {
        log("message id from listen to seen one time view message cubit : ${message.id}");
        log("message isOneTimeView from listen to seen one time view message cubit : ${message.isOneTimeSeenMessage}");
        _messages[message.id]?.markAsOneTimeView();
        emit(state.copyWith(messages: _messages.values.toList()));
      }
    });
  }

  void listenToRecordListenedUseCase() async {
    _listenToRecordListenedUseCase.call((setRecordAsListenedParams) {
      if (setRecordAsListenedParams.chatId == chat.id) {
        _messages[setRecordAsListenedParams.messageId]?.markAsListened();
        emit(state.copyWith(messages: _messages.values.toList()));
      }
    });
  }

  void _listenToDeliveredMessages() async {
    List<MessageEntity> messagesList = [];
    _listenToDeliveredMessagesUseCase.call((chatId) {
      if (chatId == chat.id) {
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

  Future<void> getOneTimeViewMessage({required MessageEntity message}) async {
    final result = await _getOneTimeMessageUseCase(
        GetOneTimeViewMessageParams(chatId: chat.id, messageId: message.id));
    result.fold((l) {
      log(l.toString());
      emit(state.copyWith(failure: l, status: ChatRoomStates.error));
    }, (r) {
      // _oneTimeViewMessage = r;
      // message.isOneTimeSeenMessage = true;
      log("one time view message chat room cubit Right: $r");
      emit(state.copyWith(
          // oneTimeViewMessage: _oneTimeViewMessage,
          status: ChatRoomStates.success));
    });
  }

  // =========================================================================================================

  void _scrollDown() => Timer(const Duration(milliseconds: 200),
      () => scrollController.jumpTo(scrollController.position.maxScrollExtent));

  @override
  Future<void> close() {
    _stopListenToSeenMessagesUseCase(const NoParams());
    _stopListenToDeliveredMessagesUseCase(const NoParams());
    serviceLocator<Socket>().off(SocketIOListeners.setRecordAsListened);
    serviceLocator<Socket>().off(SocketIOListeners.oneTimeMessageSeen);
    serviceLocator<Socket>().off(SocketIOListeners.clearChat);
    serviceLocator<Socket>().off(SocketIOListeners.pinMessage);
    serviceLocator<Socket>().off(SocketIOListeners.unPinMessage);
    return super.close();
  }
}
