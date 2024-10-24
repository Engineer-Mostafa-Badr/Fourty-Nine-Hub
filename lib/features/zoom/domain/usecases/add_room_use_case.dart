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
  final String id;
  final DateTime? startedAt;
  final DateTime? endsAt;
  final String? title;

  const MeetingParams({
    required this.id,
    this.startedAt,
    this.endsAt,
    this.title,
  });

  //post method data
  Map<String, dynamic> toJson() => {
        'roomId': id,
        'title': title,
        'startDate': startedAt?.toUtc().toString(),
        'endDate': endsAt?.toUtc().toString(),
      };

  Map<String, dynamic> createIdJson() => {
        'roomId': id,
      };

  @override
  List<Object?> get props => [
        id,
        startedAt,
        endsAt,
        title,
      ];
}
