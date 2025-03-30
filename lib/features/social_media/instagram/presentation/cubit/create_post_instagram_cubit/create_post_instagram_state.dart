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
  final List<AssetEntity> images;
  final Future<File?>? selectedImage;
  final bool isPermissionGranted;
  final int postTypeSelectedIndex;
  final bool multiSelect;
  final List<AssetEntity> selectedMeda;
  final String? errMessage;

  const CreatePostInstagramState({
    this.status = CreatePostInstagramStates.loading,
    this.images = const [],
    this.selectedImage,
    this.isPermissionGranted = false,
    this.postTypeSelectedIndex = 0,
    this.multiSelect = false,
    this.selectedMeda = const [],
    this.errMessage,
  });

  CreatePostInstagramState copyWith({
    CreatePostInstagramStates? status,
    List<AssetEntity>? images,
    Future<File?>? selectedImage,
    bool? isPermissionGranted,
    int? postTypeSelectedIndex,
    bool? multiSelect,
    List<AssetEntity>? selectedMeda,
    String? errMessage,
  }) {
    return CreatePostInstagramState(
      status: status ?? this.status,
      images: images ?? this.images,
      selectedImage: selectedImage ?? this.selectedImage,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      postTypeSelectedIndex:
          postTypeSelectedIndex ?? this.postTypeSelectedIndex,
      multiSelect: multiSelect ?? this.multiSelect,
      selectedMeda: selectedMeda ?? this.selectedMeda,
      errMessage: errMessage ?? this.errMessage,
    );
  }
}
