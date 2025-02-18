import '../../../../../core/error/failure.dart';
import '../../domain/entities/communication_privacy_entity.dart';
import '../../domain/entities/connection_privacy_entity.dart';
import '../../domain/entities/except_from_entity.dart';
import '../../domain/entities/media_privacy_entity.dart';
import '../../domain/entities/only_with_entity.dart';
import '../../domain/entities/personal_privacy_entity.dart';
import '../../domain/entities/privacy_entity.dart';
import '../../domain/entities/search_users_entity.dart';
import '../../domain/entities/update_personal_privacy_entity.dart';

enum PrivacyStates { loading, initial, error, success }

class PrivacyState {
  final PrivacyStates status;
  final Failure? failure;
  final PrivacyEntity? privacy;
  final PersonalPrivacyEntity? personalPrivacyEntity;
  final ConnectionPrivacyEntity?  connectionPrivacyEntity;
  final UpdatePersonalPrivacyDataEntity? updatePersonalPrivacyDataEntity;
  final CommunicationPrivacyEntity? communicationPrivacyEntity;
  final List<SearchUsersEntity>? searchUsers;
  final bool isSearching;
  final OnlyWithEntity? onlyWithEntity;
  final ExceptFromEntity? exceptFromEntity;
  final MediaPrivacyEntity? mediaPrivacyEntity;

  const PrivacyState({
    this.status = PrivacyStates.loading,
    this.failure,
    this.privacy,
    this.personalPrivacyEntity,
    this.connectionPrivacyEntity,
    this.updatePersonalPrivacyDataEntity,
    this.communicationPrivacyEntity,
    this.searchUsers,
    this.isSearching = false,
    this.onlyWithEntity,
    this.exceptFromEntity,
    this.mediaPrivacyEntity,

  });
  PrivacyState copyWith({
    PrivacyStates? status,
    Failure? failure,
    PrivacyEntity? privacy,
    PersonalPrivacyEntity? personalPrivacyEntity,
    ConnectionPrivacyEntity? connectionPrivacyEntity,
    UpdatePersonalPrivacyDataEntity? updatePersonalPrivacyDataEntity,
    CommunicationPrivacyEntity? communicationPrivacyEntity,
    List<SearchUsersEntity>? searchUsers,
    bool? isSearching,
    OnlyWithEntity? onlyWithEntity,
    ExceptFromEntity? exceptFromEntity,
    MediaPrivacyEntity? mediaPrivacyEntity,

  }) {
    return PrivacyState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      privacy: privacy ?? this.privacy,
      personalPrivacyEntity: personalPrivacyEntity ?? this.personalPrivacyEntity,
      connectionPrivacyEntity: connectionPrivacyEntity ?? this.connectionPrivacyEntity,
      updatePersonalPrivacyDataEntity: updatePersonalPrivacyDataEntity ?? this.updatePersonalPrivacyDataEntity,
      communicationPrivacyEntity: communicationPrivacyEntity ?? this.communicationPrivacyEntity,
      searchUsers: searchUsers ?? this.searchUsers,
      isSearching: isSearching ?? this.isSearching,
      onlyWithEntity: onlyWithEntity ?? this.onlyWithEntity,
      exceptFromEntity: exceptFromEntity ?? this.exceptFromEntity,
      mediaPrivacyEntity: mediaPrivacyEntity ?? this.mediaPrivacyEntity,

    );
  }
}
