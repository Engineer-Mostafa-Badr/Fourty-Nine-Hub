import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/notifications/domain/repos/notification_repo.dart';

import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entities/status_all_services_entity.dart';

class GetStatusAllServicesUseCase
    extends UseCase<StatusAllServicesEntity, NoParams> {
  final NotificationRepo notificationRepo;

  GetStatusAllServicesUseCase({required this.notificationRepo});

  @override
  Future<Either<Failure, StatusAllServicesEntity>> call(
      NoParams params) async {
    return notificationRepo.getStatusAllServices();
  }
}
