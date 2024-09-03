// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../repositories/meeting_repository.dart';

class AddRoomUseCase extends UseCase<bool, MeetingParams> {
  final MeetingRepository repository;

  AddRoomUseCase(this.repository);
  @override
  Future<Either<Failure, bool>> call(MeetingParams params) {
    return repository.addRoom(params);
  }
}

class MeetingParams extends Equatable {
  final String meetingId;
  final DateTime? startedAt;
  final DateTime? endsAt;
  final String? title;
  const MeetingParams({
    required this.meetingId,
    this.startedAt,
    this.endsAt,
    this.title,
  });
  //post method data
  Map<String, dynamic> toJson() => {
        'roomId': meetingId
      };

  @override
  List<Object?> get props => [
        meetingId,
        startedAt,
        endsAt,
        title,
      ];
}
