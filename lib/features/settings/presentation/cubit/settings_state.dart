import 'package:fourtyninehub/features/settings/domain/entities/disable_entity.dart';

import '../../../../../core/error/failure.dart';

enum SettingStates { loading, initial, error, success, success1 }

class SettingState {
  final SettingStates status;
  final Failure? failure;
  final DisableEntity? able;
  final bool? floatingNavigator;

  const SettingState({
    this.status = SettingStates.loading,
    this.failure,
    this.able,
    this.floatingNavigator,
  });

  SettingState copyWith(
      {SettingStates? status, Failure? failure, DisableEntity? able,bool? floatingNavigator}) {
    return SettingState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      able: able ?? this.able,
      floatingNavigator: floatingNavigator ?? this.floatingNavigator,
    );
  }
}
