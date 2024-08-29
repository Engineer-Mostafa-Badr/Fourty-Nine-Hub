import 'package:dio/dio.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';

import '../repositories/meeting_repository.dart';
import 'add_room_use_case.dart';

class JoinRoomUseCase extends NormalUseCase<Future<Response?>, MeetingParams> {
  final MeetingRepository repository;

  JoinRoomUseCase(this.repository);
  @override
  Future<Response?> call(MeetingParams params) {
    return repository.join(params);
  }
}
