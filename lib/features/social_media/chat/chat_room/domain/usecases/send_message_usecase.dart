import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/entities/message_entity.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/entities/chat_entity.dart';

class SendMessageUseCase extends UseCase<bool, SendMessageParams> {
  final ChatRoomRepository _repo;

  SendMessageUseCase(this._repo);

  @override
  Future<Either<Failure, bool>> call(SendMessageParams params) {
    return _repo.sendMessage(params);
  }
}

class SendMessageParams {
  final String message;
  final ChatEntity chat;
  final String? replyMessageId;
  List<File> media;
  final bool oneTimeView;

  SendMessageParams({
    required this.message,
    this.replyMessageId,
    required this.chat,
    required this.media,
    required this.oneTimeView,
  });

  @override
  String toString() {
    return "message: $message, chat: ${chat.id}, replyMessageId: $replyMessageId, media: $media, oneTimeView: $oneTimeView";
  }
}
