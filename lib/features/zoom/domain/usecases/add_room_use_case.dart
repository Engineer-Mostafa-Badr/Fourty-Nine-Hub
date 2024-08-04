import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../repositories/meeting_repository.dart';

class AddRoomUseCase extends UseCase<void,MeetingParams>{
  final MeetingRepository repository;

  AddRoomUseCase(this.repository);
  @override
  Future<Either<Failure, void>> call(MeetingParams params) {
    return repository.addRoom(params);
  }

}







class MeetingParams extends Equatable {
  final String id;

  const MeetingParams({
    required this.id,
  });
  //post method data
  Map<String, dynamic> toJson() => {
        'roomId': id,
      };

  @override
  List<Object?> get props => [
        id,
      ];
}
