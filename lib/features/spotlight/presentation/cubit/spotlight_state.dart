part of 'spotlight_cubit.dart';
class SpotlightState {
  final StateStatus? status;
  final Failure? failure;
  final SpotlightEntity? spotlightEntity;

  SpotlightState({
    this.status,
    this.failure,
    this.spotlightEntity,


  });

  SpotlightState copyWith({
    StateStatus? status,
    Failure? failure,
    SpotlightEntity? spotlightEntity,
  }) {
    return SpotlightState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      spotlightEntity: spotlightEntity ?? this.spotlightEntity,


    );
  }
}
