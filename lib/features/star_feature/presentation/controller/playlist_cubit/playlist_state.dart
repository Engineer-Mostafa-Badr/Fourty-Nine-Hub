part of 'playlist_cubit.dart';

enum PlaylistStatus {
  initial,
  loading,
  success,
  error,
  creating,
  updating,
  deleting
}

class PlaylistState extends Equatable {
  final PlaylistStatus status;
  final List<PlaylistEntity> playlists;
  final PlaylistEntity? selectedPlaylist;
  final Failure? failure;
  final int currentPage;
  final bool hasMore;

  const PlaylistState({
    this.status = PlaylistStatus.initial,
    this.playlists = const [],
    this.selectedPlaylist,
    this.failure,
    this.currentPage = 1,
    this.hasMore = true,
  });

  // Helper getters
  bool get isLoading => status == PlaylistStatus.loading;
  bool get isCreating => status == PlaylistStatus.creating;
  bool get isUpdating => status == PlaylistStatus.updating;
  bool get isDeleting => status == PlaylistStatus.deleting;
  bool get isSuccess => status == PlaylistStatus.success;
  bool get isError => status == PlaylistStatus.error;
  bool get hasPlaylists => playlists.isNotEmpty;
  bool get hasError => failure != null;

  PlaylistState copyWith({
    PlaylistStatus? status,
    List<PlaylistEntity>? playlists,
    PlaylistEntity? selectedPlaylist,
    Failure? failure,
    int? currentPage,
    bool? hasMore,
  }) {
    return PlaylistState(
      status: status ?? this.status,
      playlists: playlists ?? this.playlists,
      selectedPlaylist: selectedPlaylist,
      failure: failure,
      currentPage: currentPage ?? this.currentPage,
      hasMore: hasMore ?? this.hasMore,
    );
  }

  @override
  List<Object?> get props =>
      [status, playlists, selectedPlaylist, failure, currentPage, hasMore];

  @override
  String toString() {
    return 'PlaylistState(status: $status, playlistsCount: ${playlists.length}, hasError: $hasError)';
  }
}
