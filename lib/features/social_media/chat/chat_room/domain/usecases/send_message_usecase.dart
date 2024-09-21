import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_room/domain/repositories/chat_room_repository.dart';

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
  final String chatId;
  final String? replyMessageId;
  List<String> mediaIds;
  final String? groupId;
  final bool oneTimeView;

  SendMessageParams({
    required this.message,
    this.replyMessageId,
    required this.chatId,
    required this.mediaIds,
    this.groupId,
    required this.oneTimeView,
  });

  String toSocketParams() {
    return json.encode({
      "chatId": chatId,
      "type": 1,
      "mediaIds": mediaIds,
      "text": message,
      "groupId": null,
      // if (replyMessageId != null) "replyMessageId": replyMessageId
    });
  }
}
