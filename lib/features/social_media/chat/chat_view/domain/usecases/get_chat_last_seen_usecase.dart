import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';

class GetChatLastSeenUseCase extends UseCase<List<LastSeenChatsEntity>, String> {
  final ChatsRepository _repo;

  GetChatLastSeenUseCase(this._repo);

  @override
  Future<Either<Failure, List<LastSeenChatsEntity>>> call(String params) {
    return _repo.getChatLastSeen(params);
  }
}

class LastSeenChatsEntity {
  String name;
  String id;
  String time;
  String date;

  LastSeenChatsEntity({
    required this.name,
    required this.id,
    required this.time,
    required this.date,
  });

  factory LastSeenChatsEntity.fromJson(Map<String, dynamic> json) {
    return LastSeenChatsEntity(
      name: json['name'],
      id: json['_id'],
      time: json['time'],
      date: json['date'],
    );
  }
}
