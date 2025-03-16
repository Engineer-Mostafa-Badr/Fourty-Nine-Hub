enum RegistrationStatus { initial, pending, approved ,rejected }

extension RegistrationStatusExtension on RegistrationStatus {
  String get status {
    switch (this) {
      case RegistrationStatus.initial:
        return 'initial';
      case RegistrationStatus.pending:
        return 'pending';
      case RegistrationStatus.approved:
        return 'approved';
      case RegistrationStatus.rejected:
        return 'rejected';
    }
  }
}