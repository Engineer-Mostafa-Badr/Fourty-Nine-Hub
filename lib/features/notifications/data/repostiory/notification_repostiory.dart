import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/notification_data_source.dart';
import 'package:fourtyninehub/core/error/failure.dart';

class NotificationRepostiory {
  final NotificationDataSource dataSource;
  NotificationRepostiory({required this.dataSource});
  Future<Either<Failure, Map<String, dynamic>>> getAllNotification() async {
    var response = await dataSource.getAllNotification();
    return response;
  }
}
