import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../entities/chat_entity.dart';
import '../repositories/chats_repository.dart';

class GetChatsUseCase extends UseCase<List<ChatEntity>, GetChatsParams> {
  final ChatsRepository _repo;

  GetChatsUseCase(this._repo);

  @override
  Future<Either<Failure, List<ChatEntity>>> call(GetChatsParams params) {
    return _repo.getChats(params);
  }
}

class GetChatsParams {
  ChatPrivacy privacy;
  String? categoryId;
  bool? archived;
  bool? isLocked;
  bool? isUnread;
  bool? isServices;
  String? lockChatPassword;

  GetChatsParams({
    this.privacy = ChatPrivacy.normal,
    this.categoryId,
    this.archived,
    this.isLocked,
    this.isUnread,
    this.lockChatPassword,
    this.isServices,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['privacy'] = privacy.name;
    if (categoryId != null) data['categoryId'] = categoryId;
    if (archived != null) data['archived'] = archived;
    if (isLocked != null) data['isLocked'] = isLocked;
    if (isUnread != null) data['isUnread'] = isUnread;
    if (lockChatPassword != null) data['password'] = lockChatPassword;
    if (isServices != null) data['isServices'] = isServices;
    return data;
  }
}

enum ChatPrivacy { normal, anonymous }

class ChatCategoriesIds {
  static const String social = '668e7dc4e8cfec5bcc752afc';
  static const String greet = '62c8be718e28a58a3edf5f53';
  static const String anonymous = '668e7e2ce8cfec5bcc752afd';
  static const String archived = '669fa2d0c37e9147d46b050a';
}
