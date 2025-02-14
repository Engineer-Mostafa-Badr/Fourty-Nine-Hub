import '../../../../../core/error/failure.dart';
import '../../domain/entities/connection_privacy_entity.dart';
import '../../domain/entities/personal_privacy_entity.dart';
import '../../domain/entities/privacy_entity.dart';

enum PrivacyStates { loading, initial, error, success }

class PrivacyState {
  final PrivacyStates status;
  final Failure? failure;
  final PrivacyEntity? privacy;
  final PersonalPrivacyEntity? personalPrivacyEntity;
  final ConnectionPrivacyEntity?  connectionPrivacyEntity;

  const PrivacyState({
    this.status = PrivacyStates.loading,
    this.failure,
    this.privacy,
    this.personalPrivacyEntity,
    this.connectionPrivacyEntity,
  });
  PrivacyState copyWith({
    PrivacyStates? status,
    Failure? failure,
    PrivacyEntity? privacy,
    PersonalPrivacyEntity? personalPrivacyEntity,
    ConnectionPrivacyEntity? connectionPrivacyEntity,
  }) {
    return PrivacyState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      privacy: privacy ?? this.privacy,
      personalPrivacyEntity: personalPrivacyEntity ?? this.personalPrivacyEntity,
      connectionPrivacyEntity: connectionPrivacyEntity ?? this.connectionPrivacyEntity,
    );
  }
}
