import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/notifications/domain/repos/notification_repo.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/user_trip_entity.dart';

class GetAllUserTripsUseCase extends UseCase<List<UserTripEntity>, NoParams>{
  final NotificationRepo notificationRepo;

  GetAllUserTripsUseCase({required this.notificationRepo});

  @override
  Future<Either<Failure, List<UserTripEntity>>> call(NoParams params) async {
   return notificationRepo.getAllUserTrips();
  }
}
