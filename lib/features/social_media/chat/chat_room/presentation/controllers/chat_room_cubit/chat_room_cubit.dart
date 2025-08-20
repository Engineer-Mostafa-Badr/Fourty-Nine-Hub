import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_contacts/contact.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../../../../common/models/public/pagination_params.dart';
import '../../../../../../../core/abstract/use_case.dart';
import '../../../../../../../core/data/datasources/remote/socket/socket_data_source.dart';
import '../../../../../../../core/extensions/file_extension.dart';
import '../../../../../../../core/extensions/map_extension.dart';
import '../../../../../../../shared_web_socket.dart';
import '../../../../chat_view/domain/entities/chat_entity.dart';
import '../../../../chat_view/domain/usecases/show_deleted_message_usecase.dart';
import '../../../domain/entities/message_entity.dart';
import '../../../domain/entities/message_shared_contacts_entity.dart';
import '../../../domain/usecases/assign_labels_usecase.dart';
import '../../../domain/usecases/clear_chat_usecase.dart';
import '../../../domain/usecases/create_lable_usecase.dart';
import '../../../domain/usecases/delete_message_usecase.dart';
import '../../../domain/usecases/get_chat_usecase.dart';
import '../../../domain/usecases/get_lables_usecase.dart';
import '../../../domain/usecases/get_messages_usecase.dart';
import '../../../domain/usecases/get_one_time_view_message_usecase.dart';
import '../../../domain/usecases/listen_to_clear_chat_usecase.dart';
import '../../../domain/usecases/listen_to_delete_message.dart';
import '../../../domain/usecases/listen_to_delivered_messages.dart';
import '../../../domain/usecases/listen_to_one_time_message_seen.dart';
import '../../../domain/usecases/listen_to_pin_message_usecase.dart';
import '../../../domain/usecases/listen_to_record_listend.dart';
import '../../../domain/usecases/listen_to_seen_messages.dart';
import '../../../domain/usecases/listen_to_unpin_message_usecase.dart';
import '../../../domain/usecases/mark_message_as_seen_usecase.dart';
import '../../../domain/usecases/pin_message_usecase.dart';
import '../../../domain/usecases/send_message_usecase.dart';
import '../../../domain/usecases/set_record_as_listened.dart';
import '../../../domain/usecases/start_recording_uecase.dart';
import '../../../domain/usecases/start_typing_message_usecase.dart';
import '../../../domain/usecases/stop_listen_to_delivered_messages.dart';
import '../../../domain/usecases/stop_listen_to_seen_messages.dart';
import '../../../domain/usecases/stop_recording_usecase.dart';
import '../../../domain/usecases/stop_typing_usecase.dart';
import '../../../domain/usecases/unpin_message_usecase.dart';

part 'chat_room_state.dart';

class ChatRoomCubit extends Cubit<ChatRoomState> {
  final SendMessageUseCase _sendMessageUseCase;
  final GetMessagesUseCase _getMessagesUseCase;
  final GetChatUseCase _getChatUseCase;
  final GetOneTimeViewMessageUseCase _getOneTimeMessageUseCase;
  final MarkMessageAsSeenUseCase _markMessageAsSeenUseCase;
  final ListenToSeenMessagesUseCase _listenToSeenMessagesUseCase;
  final SetRecordAsListenedUseCase _setRecordAsListenedUseCase;
  final DeleteMessageUseCase _deleteMessageUseCase;
  final ListenToDeleteMessageUseCase _listenToDeleteMessageUseCase;
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
  final GetLablesUsecase _getLabelsUseCase;
  final CreateLableUsecase _createLableUsecase;
  final AssignLabelsUsecase _assignLableUsecase;

  final ListenToPinMessageUseCase _listenToPinMessageUseCase;
  final ListenToUnPinMessageUseCase _listenToUnPinMessageUseCase;
  final StopListenToDeliveredMessagesUseCase
      _stopListenToDeliveredMessagesUseCase;
  final ClearChatUseCase _clearChatUseCase;
  final ShowDeletedMessageUseCase _showDeletedMessageUseCase;
  MessageEntity? deletedMessage;

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
    this._deleteMessageUseCase,
    this._listenToDeleteMessageUseCase,
    this._showDeletedMessageUseCase,
    this._getLabelsUseCase,
    this._createLableUsecase,
    this._assignLableUsecase,
  ) : super(const ChatRoomState()) {
    _listenToDeliveredMessages();
    _listenToSeenMessages();
    _listenToSeenOneTimeViewMessages();
    listenToRecordListenedUseCase();
    _listenToClearChat();
    _listenToPinMessage();
    _listenToUnPinMessage();
    _listenToDeleteMessage();
    SharedWebSocket.socket!.emit('Chat:getRooms');
  }

  void addChatToSelectedChats({required ChatEntity chat}) {
    selectedChatsToForword.add(chat);
    chat.isSelected = true;
    emit(state.copyWith(status: ChatRoomStates.success));
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

  void addMessageToSelectedMessages({required MessageEntity message}) {
    selectedMessages.add(message);
    message.isSelected = true;
    emit(state.copyWith(status: ChatRoomStates.messagesSelected));
  }

  addToSelectedContacts({required MessageSharedContactsEntity contact}) {
    selectedContactsToShare.add(contact);
  }

  Future<void> assignLabels() async {
    final response = await _assignLableUsecase(
      AssignLabelParams(
        chatId: chat.id,
        labelsId: chat.lables
            .where((element) => element.isSelected)
            .map((label) => label.id)
            .toList(),
      ),
    );
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: ChatRoomStates.error));
    }, (data) async {
      log("Assign label result $data");
      chat.lastMessage = null;
      await getLabels();
      emit(state.copyWith(status: ChatRoomStates.success));
    });
  }

  void cancelReplay() {
    _replayMessage = null;
    emit(state.copyWith(replayedMessage: _replayMessage));
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

  Future<void> clearChat({required bool clearForAll}) async {
    final response = await _clearChatUseCase(
        ClearChatParams(chatId: chat.id, clearForAll: clearForAll));

    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: ChatRoomStates.error));
    }, (data) {
      log("clear chat result $data");
      chat.lastMessage = null;
      emit(state.copyWith(status: ChatRoomStates.success));
      _scrollDown();
    });
  }

  void clearSelectedMessages() {
    for (var message in selectedMessages) {
      message.isSelected = false;
    }
    selectedMessages.clear();
    emit(state.copyWith(status: ChatRoomStates.messagesSelected));
  }

  @override
  Future<void> close() {
    _stopListenToSeenMessagesUseCase(const NoParams());
    _stopListenToDeliveredMessagesUseCase(const NoParams());
    SharedWebSocket.socket!.off(SocketIOListeners.setRecordAsListened);
    SharedWebSocket.socket!.off(SocketIOListeners.oneTimeMessageSeen);
    SharedWebSocket.socket!.off(SocketIOListeners.clearChat);
    SharedWebSocket.socket!.off(SocketIOListeners.pinMessage);
    SharedWebSocket.socket!.off(SocketIOListeners.unPinMessage);
    SharedWebSocket.socket!.off(SocketIOListeners.messageDeleted);
    return super.close();
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

  Future<void> copyMessage(MessageEntity message) async {
    await Clipboard.setData(ClipboardData(text: message.text));
  }

  Future<void> createLable(
      {required String color, required String name}) async {
    final response =
        await _createLableUsecase(CreatLabelParams(name: name, color: color));

    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: ChatRoomStates.error));
    }, (data) async {
      log("Create label result $data");
      chat.lastMessage = null;
      await getLabels();
      emit(state.copyWith(status: ChatRoomStates.success));
    });
  }

  Future<void> deleteMessages() async {
    for (MessageEntity message in selectedMessages) {
      await _deleteMessageUseCase(DeleteMessageParams(
        chatId: chat.id,
        messageId: message.id,
      ));
      message.isSelected = false;
    }
    selectedMessages.clear();
    emit(state.copyWith(status: ChatRoomStates.success));
  }

  Future<void> forwardMessages() async {
    for (ChatEntity currentChat in selectedChatsToForword) {
      for (MessageEntity message in selectedMessages) {
        final result = await _sendMessageUseCase(SendMessageParams(
          replyMessageId: null,
          message: message.text,
          chat: currentChat,
          media: [],
          sharedContacts: message.sharedContacts,
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

  Future<void> getLabels() async {
    final response = await _getLabelsUseCase(GetLablesParams(chatId: chat.id));
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: ChatRoomStates.error));
    }, (data) {
      log("get labels result $data");
      chat.lables.clear();
      for (final label in data) {
        log("lable name ${label.name}");
        chat.lables.add(label);
      }
      emit(state.copyWith(status: ChatRoomStates.success));
    });
  }

  // =========================================== get messages ===========================================
  Future<void> getMessages({required int pageNumber}) async {
    // _messages.clear();
    final response = await _getMessagesUseCase(GetMessagesParams(
        chatId: chat.id,
        pagination: PaginationParams(limit: 20, page: pageNumber)));

    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(failure: failure, status: ChatRoomStates.error));
    }, (data) {
      _messages = _messages.reverse();
      for (final message in data) {
        if (!message.isTimerExpired) {
          // remove messages that are expired
          _messages[message.id] = message;
        }
      }
      _messages = _messages.reverse();

      log("Get Chat _getMessages pinned message id: $chat.pinnedMessageId");
      if (chat.pinnedMessageId != null) {
        log("Get Chat _getMessages pinned message: ${_messages[chat.pinnedMessageId]}");
        chat.pinnedMessage = _messages[chat.pinnedMessageId];
      }
      emit(state.copyWith(
          messages: _messages.values.toList(), status: ChatRoomStates.success));
      if (pageNumber == 1) {
        _scrollDown();
      }
    });
  }

  int getMessagesCount() {
    return _messages.length;
  }

  Future<void> getOneTimeViewMessage({required MessageEntity message}) async {
    final result = await _getOneTimeMessageUseCase(
        GetOneTimeViewMessageParams(chatId: chat.id, messageId: message.id));
    result.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
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

  Future<void> init({required ChatEntity selectedChat}) async {
    chat = selectedChat;
    String? getChatPinnedMessage = await _getChat();
    log("Get Chat pinned message id after get chat: ${chat.pinnedMessageId}");
    if (getChatPinnedMessage != null) {
      chat.pinnedMessageId = getChatPinnedMessage;
      log("Get Chat pinned message id: ${chat.pinnedMessageId}");
    }
    _messages.clear();
    await getMessages(pageNumber: 1);
  }

  void listenToRecordListenedUseCase() async {
    _listenToRecordListenedUseCase.call((setRecordAsListenedParams) {
      if (setRecordAsListenedParams.chatId == chat.id) {
        _messages[setRecordAsListenedParams.messageId]?.markAsListened();
        emit(state.copyWith(messages: _messages.values.toList()));
      }
    });
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

  Future<void> pinMessage({required MessageEntity message}) async {
    final result = await _pinMessageUseCase(
        PinMessageParams(chatId: chat.id, messageId: message.id));
    result.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: ChatRoomStates.error));
    }, (r) async {
      clearSelectedMessages();
      log("pin message result $r");
      emit(state.copyWith(status: ChatRoomStates.success));
    });
  }

  void removeChatToSelectedChats({required ChatEntity chat}) {
    selectedChatsToForword
        .removeWhere((chatIterator) => chatIterator.id == chat.id);
    chat.isSelected = false;
    emit(state.copyWith(status: ChatRoomStates.success));
  }

  removeFromSelectedContacts({required MessageSharedContactsEntity contact}) {
    selectedContactsToShare
        .removeWhere((element) => contact.name == element.name);
  }

  void removeMessageFromSelectedMessages({required MessageEntity message}) {
    selectedMessages
        .removeWhere((messageIterator) => messageIterator.id == message.id);
    message.isSelected = false;
    emit(state.copyWith(status: ChatRoomStates.messagesSelected));
  }

  void selectMessageForReplaying(MessageEntity message) {
    _replayMessage = message;
    emit(state.copyWith(replayedMessage: _replayMessage));
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
    result.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: ChatRoomStates.error));
    }, (r) async {
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

  void setPinnedMessage(String messageId) {
    chat.pinnedMessage = _messages[messageId];
    chat.pinnedMessageId = messageId;
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
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      log("set record as listened error $l");
      // emit(state.copyWith(failure: l, status: ChatRoomStates.error));
    }, (r) async {
      log("set record as listened result $r");
      // emit(state.copyWith(status: ChatRoomStates.success));
    });
  }

  Future<void> showDeletedMessage({required MessageEntity message}) async {
    final result = await _showDeletedMessageUseCase(
        ShowDeletedMessageParams(chatId: chat.id, messageId: message.id));
    result.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      log(l.toString());
      emit(state.copyWith(failure: l, status: ChatRoomStates.error));
    }, (r) {
      deletedMessage = r;
      log("show deleted message chat room cubit Right: $r");
      emit(state.copyWith(status: ChatRoomStates.success));
    });
  }

  Future<void> startRecording() async {
    final result = await _startRecordingMessageUseCase(chat.id);
    result.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: ChatRoomStates.error));
    }, (r) async {
      log("start recording result $r");
      emit(state.copyWith(status: ChatRoomStates.success));
    });
  }

  void startSearching() {
    chat.isSearching = true;
    emit(state.copyWith(status: ChatRoomStates.success));
  }

  Future<void> startTyping() async {
    final result = await _startTypingMessageUseCase(chat.id);
    result.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: ChatRoomStates.error));
    }, (r) async {
      log("start typing result $r");
      emit(state.copyWith(status: ChatRoomStates.success));
    });
  }

  Future<void> stopRecording() async {
    final result = await _stopRecordingMessageUseCase(chat.id);
    result.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: ChatRoomStates.error));
    }, (r) async {
      log("stop recording result $r");
      emit(state.copyWith(status: ChatRoomStates.success));
    });
  }

  void stopSearching() {
    chat.isSearching = false;
    emit(state.copyWith(status: ChatRoomStates.success));
  }

  Future<void> stopTyping() async {
    final result = await _stopTypingMessageUseCase(chat.id);
    result.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: ChatRoomStates.error));
    }, (r) async {
      log("stop typing result $r");
      emit(state.copyWith(status: ChatRoomStates.success));
    });
  }

  Future<void> unpinMessage() async {
    final result =
        await _unpinMessageUseCase(UnPinMessageParams(chatId: chat.id));
    result.fold((l) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(currentContext, getFailureMessage(l, currentContext));
      emit(state.copyWith(failure: l, status: ChatRoomStates.error));
    }, (r) async {
      log("unpin message result $r");
      emit(state.copyWith(status: ChatRoomStates.success));
    });
  }

  void unSetPinnedMessage() {
    chat.pinnedMessage = null;
    chat.pinnedMessageId = null;
    emit(state.copyWith(status: ChatRoomStates.success));
  }

  void updateLabelSelection(int index, bool? newValue) {
    final label = chat.lables[index];
    label.isSelected = newValue ?? false;
    emit(state.copyWith(
        status:
            ChatRoomStates.success)); // Emit a new state to trigger a rebuild
  }

  Future<String?> _getChat() async {
    final response = await _getChatUseCase(GetChatParams(chatId: chat.id));
    return response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      log("Get Chat _getChat failure from get chat: $failure");
      return null;
    },
        // ignore: void_checks
        (data) {
      log("Get Chat _getChat: $data");
      return data;
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

  void _listenToDeleteMessage() {
    _listenToDeleteMessageUseCase.call((deleteMessageParams) {
      if (deleteMessageParams.chatId == chat.id) {
        _messages[deleteMessageParams.messageId]?.markAsDeleted();
        if (chat.lastMessage != null) {
          if (chat.lastMessage?.id == deleteMessageParams.messageId) {
            chat.lastMessage?.text = 'Message Deleted';
            chat.lastMessage?.isDeleted = true;
          }
        }
        log('Deleteeeee Messageeeeeeeeeeeeee: ${_messages[deleteMessageParams.messageId]?.text}');
        emit(
          state.copyWith(
            messages: _messages.values.toList(),
            status: ChatRoomStates.success,
          ),
        );
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

  void _listenToPinMessage() async {
    _listenToPinMessageUseCase.call((listenToPinMessageParams) {
      if (listenToPinMessageParams.chatId == chat.id) {
        log("Pin message from cubit: ${listenToPinMessageParams.messageId}");

        setPinnedMessage(listenToPinMessageParams.messageId);
      }
    });
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

  void _listenToUnPinMessage() async {
    _listenToUnPinMessageUseCase.call((listenToUnPinMessageParams) {
      if (listenToUnPinMessageParams.chatId == chat.id) {
        log("UnPin message from cubit: ${listenToUnPinMessageParams.chatId}");

        unSetPinnedMessage();
      }
    });
  }

  // =========================================== seen ============================================

  Future<void> _markMessageAsSeen() async {
    await _markMessageAsSeenUseCase(MarkMessageAsSeenParams(chatId: chat.id));
  }

  // =========================================================================================================

  void _scrollDown() => Timer(const Duration(milliseconds: 200),
      () => scrollController.jumpTo(scrollController.position.maxScrollExtent));
}
