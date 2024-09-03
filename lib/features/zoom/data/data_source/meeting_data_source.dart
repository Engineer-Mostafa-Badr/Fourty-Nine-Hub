import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/api/api_consumer.dart';
import 'package:fourtyninehub/core/api/end_points.dart';
// ignore: unused_import
import 'package:fourtyninehub/core/data/models/meeting_error_message_model.dart';
import 'package:fourtyninehub/features/zoom/data/model/schedule_meeting_model.dart';
import 'package:fourtyninehub/features/zoom/domain/entities/scheduled_meeting.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/add_room_use_case.dart';
import 'package:icons_launcher/utils/cli_logger.dart';

import '../../../../core/error/failure.dart';

abstract class MeetingDataSource {
  Future<Either<Failure, bool>> addRoom(MeetingParams params);
  Future<Either<Failure, bool>> joinRoom(MeetingParams params);
  Future<Either<Failure, void>> endRoom(MeetingParams params);
  Future<Either<Failure, List<ScheduledMeeting>>> getScheduledMeetings(
      MeetingParams params);
}

class MeetingDataSourceImpl extends MeetingDataSource {
  final ApiConsumer apiConsumer;
  final Dio _dio;

  MeetingDataSourceImpl(this.apiConsumer, this._dio);
  @override
  Future<Either<Failure, bool>> addRoom(MeetingParams params) async {
    final result =
        await apiConsumer.post(EndPoints.createMeeting, data: params.toJson());
    return result.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r['status']);
    });
  }

  @override
  Future<Either<Failure, void>> endRoom(MeetingParams params) async {
    // print('deleted');
    // final result =
    //     await apiConsumer.put(EndPoints.endMeeting(params.meetingId));
    // return result.fold((l) => Left(l), (r) => Right(r));
    throw Exception('UnImplemented Finish Func');
  }

  @override
  // Future<Response?> joinRoom(MeetingParams params) async {
  //   final url = EndPoints.joinMeeting(params.meetingId);
  //   try {
  //     final response = await _dio.put(url);
  //
  //     if (response.statusCode == 200) {
  //       print('stata is ok');
  //       return response;
  //       // Handle success
  //     } else {
  //       // Handle other status codes
  //       return response;
  //     }
  //   } on DioException catch (e) {
  //     // Handle network error
  //     if (e.response != null && e.response?.statusCode == 404) {
  //       return e.response;
  //     } else if (e.response != null) {
  //       return e.response;
  //     } else {
  //       // Handle cases where no response was returned (e.g., network error)
  //
  //       return null;
  //     }
  //   }
  // }

  @override
  Future<Either<Failure, List<ScheduledMeeting>>> getScheduledMeetings(
      MeetingParams params) async {
    final result =
        await apiConsumer.get(EndPoints.getScheduledMeetings(params.meetingId));
    return result.fold((l) {
      // throw MeetingErrorMessageModel.fromJson(l);
      return Left(l);
    }, (r) {
      final List<ScheduledMeeting> rooms = List.from(r['data']['docs'])
          .map((e) => ScheduledMeetingModel.fromJson(e))
          .toList();
      return Right(rooms);
    });
  }

  @override
  Future<Either<Failure, bool>> joinRoom(MeetingParams params) async{
    final result =
        await apiConsumer.put(EndPoints.joinMeeting(params.meetingId));
    return result.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r['status']);
    });
  }
}
