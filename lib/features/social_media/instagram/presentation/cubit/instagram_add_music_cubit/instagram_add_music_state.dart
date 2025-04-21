part of 'instagram_add_music_cubit.dart';

enum InstagramAddMusicStates { initial, loading, success, failure }

extension InstagramAddMusicStatesX on InstagramAddMusicStates {
  bool get isInitial => this == InstagramAddMusicStates.initial;
  bool get isLoading => this == InstagramAddMusicStates.loading;
  bool get isSuccess => this == InstagramAddMusicStates.success;
  bool get isFailure => this == InstagramAddMusicStates.failure;
}

@immutable
class InstagramAddMusicState {
  final InstagramAddMusicStates status;
  final int activeMusicSectionIndex;
  final bool isSelectedMusic;
  const InstagramAddMusicState({
    this.status = InstagramAddMusicStates.initial,
    this.activeMusicSectionIndex = 0,
    this.isSelectedMusic = false,
  });

  InstagramAddMusicState copyWith({
    InstagramAddMusicStates? status,
    int? activeMusicSectionIndex,
    bool? isSelectedMusic,
  }) {
    return InstagramAddMusicState(
      status: status ?? this.status,
      activeMusicSectionIndex: activeMusicSectionIndex ?? this.activeMusicSectionIndex,
      isSelectedMusic: isSelectedMusic ?? this.isSelectedMusic,
    );
  }
}
