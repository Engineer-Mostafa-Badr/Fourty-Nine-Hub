
import '../../../../../core/error/failure.dart';


enum SettingStates { loading, initial, error,success }

class SettingState {
  final SettingStates status;
  final Failure? failure;

  const SettingState({
    this.status = SettingStates.loading,
    this.failure,
  });
  SettingState copyWith({
    SettingStates? status,
    Failure? failure,
  }) {
    return SettingState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
