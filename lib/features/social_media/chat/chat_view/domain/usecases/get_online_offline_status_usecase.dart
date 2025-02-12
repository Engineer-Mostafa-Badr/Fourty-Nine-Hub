import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/chat/chat_view/domain/repositories/chats_repository.dart';
import 'package:intl/intl.dart';

class GetOnlineOfflineStatusUseCase
    extends UseCase<GetOnlineOfflineStatusEntity, String> {
  final ChatsRepository _repo;

  GetOnlineOfflineStatusUseCase(this._repo);

  @override
  Future<Either<Failure, GetOnlineOfflineStatusEntity>> call(String params) {
    return _repo.getOnlineOfflineStatus(userId: params);
  }
}

class GetOnlineOfflineStatusEntity {
  String status;
  String formatDate;

  GetOnlineOfflineStatusEntity(
      {required this.status, required this.formatDate});

  factory GetOnlineOfflineStatusEntity.fromJson(Map<String, dynamic> json) {
    String formattedDate = _formatDate(json['lastSeen']);
    return GetOnlineOfflineStatusEntity(
        status: json['status'],
        formatDate: json['formatDate'] ?? formattedDate);
  }
  static String _formatDate(String dateTime) {
    DateTime parsedDate = DateTime.parse(dateTime).toLocal();
    return DateFormat('hh:mm a').format(parsedDate);
  }
}
