import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
// ignore: unused_import
import 'package:fourtyninehub/core/data/models/meeting_error_message_model.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/add_room_use_case.dart';

import '../../../../core/error/failure.dart';

abstract class MeetingDataSource {
  Future<Either<Failure, void>> addRoom(MeetingParams params);
  Future<Either<Failure, void>> joinRoom(MeetingParams params);
  Future<Either<Failure, void>> endRoom(MeetingParams params);
}

class MeetingDataSourceImpl extends MeetingDataSource {
  final ApiConsumer apiConsumer;

  MeetingDataSourceImpl(this.apiConsumer);
  @override
  Future<Either<Failure, void>> addRoom(MeetingParams params) async {
    final result =
        await apiConsumer.post(EndPoints.createMeeting, data: params.toJson());
    return result.fold((l) {
      // throw MeetingErrorMessageModel.fromJson(l);
      return Left(l);
    }, (r) {
      return Right(r);
    });
  }

  @override
  Future<Either<Failure, void>> endRoom(MeetingParams params) async {
    final result = await apiConsumer.put(EndPoints.endMeeting(params.id));
    return result.fold((l) => Left(l), (r) => Right(r));
  }

  @override
  Future<Either<Failure, void>> joinRoom(MeetingParams params) async {
    final result = await apiConsumer.put(EndPoints.joinMeeting(params.id));
    return result.fold((l) => Left(l), (r) => Right(r));
  }
}
