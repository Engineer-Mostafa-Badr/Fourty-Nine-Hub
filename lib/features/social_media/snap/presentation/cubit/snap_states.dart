import '../../domain/entity/filter_entity.dart';

import '../../../../../../core/error/failure.dart';

enum SnapStates { loading, initial, error, success }

extension SnapStatesX on SnapState {
  bool get isInitial => status == SnapStates.initial;
  bool get isLoading => status == SnapStates.loading;
  bool get isError => status == SnapStates.error;
  bool get isSuccess => status == SnapStates.success;
}

class SnapState {
  final SnapStates status;
  final Failure? failure;
  final List<FilterEntity>? snap;

  const SnapState({
    this.status = SnapStates.loading,
    this.failure,
    this.snap,
  });
  SnapState copyWith({
    SnapStates? status,
    Failure? failure,
    List<FilterEntity>? snap,
  }) {
    return SnapState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      snap: snap ?? this.snap,
    );
  }
}
