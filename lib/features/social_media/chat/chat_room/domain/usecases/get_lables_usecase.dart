import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/chat_room_repository.dart';

class GetLablesUsecase
    extends UseCase<List<GetLablesEntity>, GetLablesParams> {
  final ChatRoomRepository _chatRoomRepository;

  GetLablesUsecase(this._chatRoomRepository);

  @override
  Future<Either<Failure, List<GetLablesEntity>>> call(GetLablesParams params) {
    return _chatRoomRepository.getLables(params);
  }
}

class GetLablesParams {
  final String chatId;

  GetLablesParams({required this.chatId});
}


class GetLablesEntity {
  final String id;
  final String name;
  final String color;
  bool isSelected;

  GetLablesEntity(this.isSelected, {required this.id, required this.name, required this.color});

  GetLablesEntity.fromJson(Map<String, dynamic> json)
      : id = json['_id']?? '',
        name = json['name']?? '',
        color = json['color']?? 'Colors.green',
        isSelected = json['isSelected'] ?? false;
}
