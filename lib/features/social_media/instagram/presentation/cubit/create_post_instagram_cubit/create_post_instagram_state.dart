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
  final List<AssetEntity> galleryPost;
  final List<AssetEntity> selectedGalleryPost;
  final List<AssetEntity> galleryReels;
  final List<AssetEntity> selectedGalleryReels;
  final bool loadingReelsScreen;
  // final bool isVideoInitialized;
  final bool isPermissionGranted;
  final int postTypeSelectedIndex;
  final bool multiSelectGalleryPost;
  final bool multiSelectGalleryReel;
  // final List<File> selectedMeda;
  final Failure? failure;
  final int currentPage;
  final bool hasMoreImages;
  final List<UserTagEntity> usersTag;
  LocationInstagramEntity? location;
  final bool isImageCover;

   CreatePostInstagramState({
    this.status = CreatePostInstagramStates.loading,
    this.galleryPost = const [],
    this.selectedGalleryPost = const [],
    this.galleryReels = const [],
    this.selectedGalleryReels = const [],
    this.loadingReelsScreen = false,
    // this.isVideoInitialized = false,
    this.isPermissionGranted = false,
    this.postTypeSelectedIndex = 0,
    this.multiSelectGalleryPost = false,
    this.multiSelectGalleryReel = false,
    // this.selectedMeda = const [],
    this.failure,
    this.currentPage = 0,
    this.hasMoreImages = true,
    this.usersTag = const [],
    this.location,
    this.isImageCover = false,
  });

  CreatePostInstagramState copyWith({
    CreatePostInstagramStates? status,
    List<AssetEntity>? galleryPost,
    List<AssetEntity>? selectedGalleryPost,
    List<AssetEntity>? galleryReels,
    List<AssetEntity>? selectedGalleryReels,
    // bool? isVideoInitialized,
    bool? loadingReelsScreen,
    bool? isPermissionGranted,
    int? postTypeSelectedIndex,
    bool? multiSelectGalleryPost,
    bool? multiSelectGalleryReel,
    // List<File>? selectedMeda,
    Failure? failure,
    int? currentPage,
    bool? hasMoreImages,
    List<UserTagEntity>? usersTag,
    LocationInstagramEntity? location,
    bool? isImageCover,
    bool? clearLocation, // إضافة parameter للـ clear
  }) {
    return CreatePostInstagramState(
      status: status ?? this.status,
      galleryPost: galleryPost ?? this.galleryPost,
      selectedGalleryPost: selectedGalleryPost ?? this.selectedGalleryPost,
      galleryReels: galleryReels ?? this.galleryReels,
      selectedGalleryReels: selectedGalleryReels ?? this.selectedGalleryReels,
      loadingReelsScreen: loadingReelsScreen ?? this.loadingReelsScreen,
      // isVideoInitialized: isVideoInitialized ?? this.isVideoInitialized,
      isPermissionGranted: isPermissionGranted ?? this.isPermissionGranted,
      postTypeSelectedIndex:
          postTypeSelectedIndex ?? this.postTypeSelectedIndex,
      multiSelectGalleryPost:
          multiSelectGalleryPost ?? this.multiSelectGalleryPost,
      multiSelectGalleryReel:
          multiSelectGalleryReel ?? this.multiSelectGalleryReel,
      // selectedMeda: selectedMeda ?? this.selectedMeda,
      failure: failure ?? this.failure,
      currentPage: currentPage ?? this.currentPage,
      hasMoreImages: hasMoreImages ?? this.hasMoreImages,
      location: clearLocation == true ? null : (location ?? this.location),
      usersTag: usersTag ?? this.usersTag,
      isImageCover: isImageCover ?? this.isImageCover,
    );
  }
}
