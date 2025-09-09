import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../Entities/conversation_entity.dart';
import '../Entities/conversations_pagination.dart';

abstract class ConversationsRepo {
  Future<Either<Failure, List<ConversationEntity>>> getSocialConversations({required ConversationPagination pagination});
  void listenToUpdateSocialList(Function(ConversationEntity) params);
  Future<Either<Failure, bool>> startTyping({required String conversationId});
  void listenToStartTyping(Function(String) params);
  Future<Either<Failure, bool>> stopTyping({required String conversationId});
  void listenToStopTyping(Function(String) params);
}