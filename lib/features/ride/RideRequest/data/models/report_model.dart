import '../../domain/entity/report_entity.dart';

class RideReportModel extends RideReportEntity {
  RideReportModel(
      {required super.driverId,
      required super.reportReason,
      required super.requestId});
}
