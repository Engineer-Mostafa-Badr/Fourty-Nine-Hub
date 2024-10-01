import '../../../../../core/error/failure.dart';
import '../../domain/entities/privacy_entity.dart';

enum PrivacyStates { loading, initial, error, success }

class PrivacyState {
  final PrivacyStates status;
  final Failure? failure;
  final PrivacyEntity? privacy;

  const PrivacyState({
    this.status = PrivacyStates.loading,
    this.failure,
    this.privacy,
  });
  PrivacyState copyWith({
    PrivacyStates? status,
    Failure? failure,
    PrivacyEntity? privacy,
  }) {
    return PrivacyState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      privacy: privacy ?? this.privacy,
    );
  }
}
