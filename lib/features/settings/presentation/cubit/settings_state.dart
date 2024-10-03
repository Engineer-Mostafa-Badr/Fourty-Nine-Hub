import 'package:fourtyninehub/features/settings/domain/entities/disable_entity.dart';

import '../../../../../core/error/failure.dart';

enum SettingStates { loading, initial, error, success, success1 }

class SettingState {
  final SettingStates status;
  final Failure? failure;
  final DisableEntity? able;

  const SettingState({
    this.status = SettingStates.loading,
    this.failure,
    this.able,
  });
  SettingState copyWith(
      {SettingStates? status, Failure? failure, DisableEntity? able}) {
    return SettingState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      able: able ?? this.able,
    );
  }
}
