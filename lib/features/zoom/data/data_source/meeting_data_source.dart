import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';

// ignore: unused_import
import 'package:fourtyninehub/core/data/models/meeting_error_message_model.dart';
import 'package:fourtyninehub/core/extensions/context_extension.dart';
import 'package:fourtyninehub/features/authentication/presentation/controllers/user_cubit/user_cubit.dart';
import 'package:fourtyninehub/features/zoom/data/model/schedule_meeting_model.dart';
import 'package:fourtyninehub/features/zoom/domain/entities/scheduled_meeting.dart';
import 'package:fourtyninehub/features/zoom/domain/usecases/add_room_use_case.dart';
import 'package:fourtyninehub/routes/pages.dart';

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

  MeetingDataSourceImpl(this.apiConsumer);

  @override
  Future<Either<Failure, bool>> addRoom(MeetingParams params) async {
    final result =
        await apiConsumer.post(EndPoints.createMeeting, data: params.toJson());
    // if(params.title!=null){
    //   getScheduledMeetings();
    // }
    return result.fold((l) {
      return Left(l);
    }, (r) {
      return Right(r['status']);
    });
  }

  @override
  Future<Either<Failure, void>> endRoom(MeetingParams params) async {
    // print('deleted');
    final result = await apiConsumer.put(EndPoints.endMeeting(params.id));
    return result.fold((l) => Left(l), (r) => Right(r));
    // throw Exception('UnImplemented Finish Func');
  }

  @override
  Future<Either<Failure, List<ScheduledMeeting>>> getScheduledMeetings(
      MeetingParams params) async {
    final result =
        await apiConsumer.get(EndPoints.getScheduledMeetings(params.id));
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
  Future<Either<Failure, bool>> joinRoom(MeetingParams params) async {
    final result =
        await apiConsumer.put(EndPoints.joinMeeting(params.id), headers: {
      'lang':
          AppPages.router.configuration.navigatorKey.currentContext!.isArabic
              ? 'ar'
              : 'en',
    });
    return result.fold((l) {
      return Left(l);
    }, (r) {
      return Right(_idEquality(r));
    });
  }

  bool _idEquality(Map<String, dynamic> r) =>
      r['data']['userId'] == UserCubit.to.state.data!.id;
}
//
// Either<String, int> checkType(dynamic r) {
//   if (r is int) {
//     return Right(r);
//   } else {
//     return Left(r);
//   }
// }
