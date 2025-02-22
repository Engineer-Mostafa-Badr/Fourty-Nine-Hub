import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/authentication/domain/repositories/auth_repository.dart';
import 'package:fourtyninehub/res/style/const.dart';

class GetProfileViewsUseCase
    extends UseCase<List<GetProfileViewsEntity>, GetProfileViewsParams> {
  final AuthRepository _repo;

  GetProfileViewsUseCase(this._repo);

  @override
  Future<Either<Failure, List<GetProfileViewsEntity>>> call(
      GetProfileViewsParams params) {
    return _repo.getProfileViews(params);
  }
}

class GetProfileViewsParams {
  final bool isProfile;
  final String userId;
  GetProfileViewsParams({required this.isProfile, this.userId = ''});
}

class GetProfileViewsEntity {
  String name;
  String id;
  String time;
  String date;
  String avatar;
  String userId;

  GetProfileViewsEntity({
    required this.name,
    required this.id,
    required this.time,
    required this.date,
    required this.avatar,
    required this.userId,
  });

  factory GetProfileViewsEntity.fromJson(Map<String, dynamic> json) {
    return GetProfileViewsEntity(
      name: (json['userDetails']['firstName'] ?? "") +
          " " +
          (json['userDetails']['lastName'] ?? ""),
      id: json['_id'],
      time: extractTime(json['viewedAt']),
      date: extractDate(json['viewedAt']),
      avatar: (json['userDetails']['avatar'] ?? UIConst.profilePlaceHolder),
      userId: json['userId'],
    );
  }
}

String extractTime(String dateTimeString) {
  final DateTime dateTime = DateTime.parse(dateTimeString);
  final int hour = dateTime.hour;
  final int minute = dateTime.minute;
  final String period = hour >= 12 ? 'pm' : 'am';
  final int formattedHour = hour % 12 == 0 ? 12 : hour % 12;

  return '${formattedHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
}


String extractDate(String dateTimeString) {
  final DateTime dateTime = DateTime.parse(dateTimeString);
  return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
}
