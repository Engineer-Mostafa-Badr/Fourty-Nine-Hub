enum RequestEmergencyStatus {
  noRequest,
  pending,
  rejected,
  approved,
}

extension RequestEmergencyStatusExtension on RequestEmergencyStatus {
  String get status {
    switch (this) {
      case RequestEmergencyStatus.noRequest:
        return 'no-request';
      case RequestEmergencyStatus.pending:
        return 'pending';
      case RequestEmergencyStatus.rejected:
        return 'rejected';
      case RequestEmergencyStatus.approved:
        return 'approved';
    }
  }
}
