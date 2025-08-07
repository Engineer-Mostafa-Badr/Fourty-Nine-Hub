import 'package:dartz/dartz.dart';
import '../../../../../../core/abstract/use_case.dart';
import '../../../../../../core/error/failure.dart';
import '../repositories/chat_room_repository.dart';

class CreateLableUsecase extends UseCase<bool, CreatLabelParams> {
  final ChatRoomRepository _repo;

  CreateLableUsecase(this._repo);

  @override
  Future<Either<Failure, bool>> call(CreatLabelParams params) {
    return _repo.createLable(params);
  }
}

class CreatLabelParams {
  final String name;
  final String color;
  CreatLabelParams({required this.name, required this.color});
}
