import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/datasources/chats_remote_datasourse.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/data/models/chat_item_model.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/usecases/chats_request.dart';

class ChatsRepositoryImplementation extends ChatsRepository {
  final ChatsRemoteDataSource _chatsRemoteDataSource;
  ChatsRepositoryImplementation(this._chatsRemoteDataSource);

  @override
  Future<Either<Failure, List<ChatItemModel>>> getChats(ChatsRequestParams chatsRequestParams) {
    return _chatsRemoteDataSource.getChats(privacy: chatsRequestParams.privacyId,categoryId: chatsRequestParams.categoryId,);
  }
}
