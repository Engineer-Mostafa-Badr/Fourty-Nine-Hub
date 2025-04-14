part of 'create_post_instagram_cubit.dart';

enum CreatePostInstagramStates { loading, initial, success, error }

extension CreatePostInstagramStateX on CreatePostInstagramStates {
  bool get isInitial => this == CreatePostInstagramStates.initial;
  bool get isLoading => this == CreatePostInstagramStates.loading;
  bool get isError => this == CreatePostInstagramStates.error;
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
  final String? errMessage;
  final int currentPage;
  final bool hasMoreImages;

  const CreatePostInstagramState({
    this.status = CreatePostInstagramStates.loading,
    this.images = const [],
    this.selectedImages = const [],
    this.isPermissionGranted = false,
    this.postTypeSelectedIndex = 0,
    this.multiSelect = false,
    this.selectedMeda = const [],
    this.errMessage,
    this.currentPage = 0,
    this.hasMoreImages = true,
  });

  CreatePostInstagramState copyWith({
    CreatePostInstagramStates? status,
    List<File>? images,
    List<File>? selectedImages,
    bool? isPermissionGranted,
    int? postTypeSelectedIndex,
    bool? multiSelect,
    List<File>? selectedMeda,
    String? errMessage,
    int? currentPage,
    bool? hasMoreImages,
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
      errMessage: errMessage ?? this.errMessage,
      currentPage: currentPage ?? this.currentPage,
      hasMoreImages: hasMoreImages ?? this.hasMoreImages,
    );
  }
}
