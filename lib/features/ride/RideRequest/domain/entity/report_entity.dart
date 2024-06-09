class RideReportEntity {
  final int driverId;
  final int requestId;
  final String reportReason;
  RideReportEntity(
      {required this.driverId,
      required this.reportReason,
      required this.requestId});
}
