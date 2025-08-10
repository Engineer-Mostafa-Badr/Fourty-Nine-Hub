part of 'spot_light_cubit.dart';

sealed class SpotLightState extends Equatable {
  const SpotLightState();

  @override
  List<Object?> get props => [];
}

final class SpotLightInitial extends SpotLightState {}

final class SpotlightLoading extends SpotLightState {}

final class SpotlightProfileLoading extends SpotLightState {}

final class SpotlightMediaLoading extends SpotLightState {}

final class SpotlightUploadLoading extends SpotLightState {
  final double progress;
  final String status;

  const SpotlightUploadLoading(
      {this.progress = 0.0, this.status = 'Preparing upload...'});

  @override
  List<Object?> get props => [progress, status];
}

class SpotlightProfileLoaded extends SpotLightState {
  final SpotlightProfileEntity profile;
  final bool isMyProfile;

  const SpotlightProfileLoaded({
    required this.profile,
    this.isMyProfile = false,
  });

  @override
  List<Object?> get props => [profile, isMyProfile];
}

class SpotlightMediaLoaded extends SpotLightState {
  final PaginatedResponseEntity<SpotlightMediaEntity> mediaResponse;
  final List<SpotlightMediaEntity> allMedia;
  final bool isLoadingMore;
  final bool hasReachedMax;
  final String? userId; // null means my media

  const SpotlightMediaLoaded({
    required this.mediaResponse,
    required this.allMedia,
    this.isLoadingMore = false,
    this.hasReachedMax = false,
    this.userId,
  });

  SpotlightMediaLoaded copyWith({
    PaginatedResponseEntity<SpotlightMediaEntity>? mediaResponse,
    List<SpotlightMediaEntity>? allMedia,
    bool? isLoadingMore,
    bool? hasReachedMax,
    String? userId,
  }) {
    return SpotlightMediaLoaded(
      mediaResponse: mediaResponse ?? this.mediaResponse,
      allMedia: allMedia ?? this.allMedia,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props =>
      [mediaResponse, allMedia, isLoadingMore, hasReachedMax, userId];
}

class SpotlightUploadSuccess extends SpotLightState {
  final UploadConfirmEntity uploadResult;

  const SpotlightUploadSuccess({required this.uploadResult});

  @override
  List<Object?> get props => [uploadResult];
}

class SpotlightActionSuccess extends SpotLightState {
  final String message;

  const SpotlightActionSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class SpotlightError extends SpotLightState {
  final Failure? failureMessage;

  const SpotlightError({required this.failureMessage});

  @override
  List<Object?> get props => [failureMessage];
}
