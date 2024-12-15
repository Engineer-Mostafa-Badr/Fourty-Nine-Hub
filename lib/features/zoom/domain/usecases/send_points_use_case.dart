// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../repositories/meeting_repository.dart';

class SendPointsUseCase extends UseCase<bool, SendPointsParams> {
  final MeetingRepository repository;

  SendPointsUseCase(this.repository);

  @override
  Future<Either<Failure, bool>> call(SendPointsParams params) {
    return repository.sendPoints(params);
  }
}


class SendPointsParams {
  final String streamId;
  final String memberId;

  SendPointsParams({required this.streamId, required this.memberId});

  //toJson
  Map<String, dynamic> toJson() => {
    'streamId': streamId,
    'memberId': memberId,
    'points':50
  };
}