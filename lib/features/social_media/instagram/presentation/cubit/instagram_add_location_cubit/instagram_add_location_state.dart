part of 'instagram_add_location_cubit.dart';

enum InstagramAddLocationStates {
  initial,
  loading,
  success,
  failure,
}

extension InstagramAddLocationStateX on InstagramAddLocationStates {
  bool get isInitial => this == InstagramAddLocationStates.initial;
  bool get isLoading => this == InstagramAddLocationStates.loading;
  bool get isSuccess => this == InstagramAddLocationStates.success;
  bool get isFailure => this == InstagramAddLocationStates.failure;
}

@immutable
class InstagramAddLocationState {
  final InstagramAddLocationStates status;
  final LocationInstagramEntity? location;
  final Failure? failure;

  const InstagramAddLocationState({
    this.status = InstagramAddLocationStates.initial,
    this.location,
    this.failure,
  });

  InstagramAddLocationState copyWith({
    InstagramAddLocationStates? status,
    LocationInstagramEntity? location,
    Failure? failure,
  }) {
    return InstagramAddLocationState(
      status: status ?? this.status,
      location: location ?? this.location,
      failure: failure ?? failure,
    );
  }
}
