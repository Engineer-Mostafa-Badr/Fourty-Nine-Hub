part of 'create_post_instagram_cubit.dart';

enum CreatePostInstagramStates { loading, initial, success, failure }

extension CreatePostInstagramStateX on CreatePostInstagramStates {
  bool get isInitial => this == CreatePostInstagramStates.initial;
  bool get isLoading => this == CreatePostInstagramStates.loading;
  bool get isError => this == CreatePostInstagramStates.failure;
  bool get isSuccess => this == CreatePostInstagramStates.success;
}

class CreatePostInstagramState {
  final CreatePostInstagramStates status;
  final List<File> images;
  final List<File> selectedImages;
  final bool isPermissionGranted;
  final int postTypeSelectedIndex;
  final bool multiSelect;
  final List<File> selectedMeda;
  final Failure? failure;
  final int currentPage;
  final bool hasMoreImages;
  final List<UserTagEntity> usersTag;
  final LocationInstagramEntity? location;

  const CreatePostInstagramState({
    this.status = CreatePostInstagramStates.loading,
    this.images = const [],
    this.selectedImages = const [],
    this.isPermissionGranted = false,
    this.postTypeSelectedIndex = 0,
    this.multiSelect = false,
    this.selectedMeda = const [],
    this.failure,
    this.currentPage = 0,
    this.hasMoreImages = true,
    this.usersTag = const [],
    this.location,
  });

  CreatePostInstagramState copyWith({
    CreatePostInstagramStates? status,
    List<File>? images,
    List<File>? selectedImages,
    bool? isPermissionGranted,
    int? postTypeSelectedIndex,
    bool? multiSelect,
    List<File>? selectedMeda,
    Failure? failure,
    int? currentPage,
    bool? hasMoreImages,
    List<UserTagEntity>? usersTag,
    LocationInstagramEntity? location,
  }) {
    return CreatePostInstagramState(
      status: status ?? this.status,
      images: images ?? this.images,
      selectedImages: selectedImages ?? this.selectedImages,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      postTypeSelectedIndex:
          postTypeSelectedIndex ?? this.postTypeSelectedIndex,
      multiSelect: multiSelect ?? this.multiSelect,
      selectedMeda: selectedMeda ?? this.selectedMeda,
      failure: failure ?? this.failure,
      currentPage: currentPage ?? this.currentPage,
      hasMoreImages: hasMoreImages ?? this.hasMoreImages,
      usersTag: usersTag ?? this.usersTag,
      location: location ?? this.location,
    );
  }
}
