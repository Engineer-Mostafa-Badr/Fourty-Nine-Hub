part of 'create_post_cubit.dart';

enum CreatePostStates { loading,loadingCreatePost, initial, success, error }

class CreatePostState {
  final CreatePostStates status;
  final Failure? failure;
  final List<ActivityEntity>? activities;
  final List<ActivityEntity>? subActivities;
  final List<FeelingEntity>? feelings;
  final ActivityEntity? selectedActivity;
  final FeelingEntity? selectedFeeling;
  final PlaceEntity? place;
  final List<UploadFileEntity>? images;
  final List<UploadFileEntity>? lifeEventImages;
  final UploadFileEntity? audio;
  final String? gifImage;
  final List<PostUserEntity>? users;
  final List<PostUserEntity>? selectedUsers;
  final String? selectedPrivacy;
  final String? selectedLocation;
  final bool? isSheetOpen;
  final LifeEventEntity? selectedLifeEvent;
  String? backColor;
  final bool isLast;
  final bool showBallet;
  final bool isBiggerThan80;
  final bool isBiggerThen150;
  final bool isBiggerThen120;
  final bool? onTweet;
  final bool? onInsta;
  final String? music;
  final int? pageIndex;
  final DateTime? pickedDate;
  CreatePostState(
      {this.status = CreatePostStates.error,
      this.failure,
      this.images,
      this.lifeEventImages,
      this.audio,
      this.gifImage,
      this.activities,
      this.subActivities,
      this.feelings,
      this.backColor = "#FFFFFFFF",
      this.isLast = false,
      this.showBallet = false,
      this.isSheetOpen = true,
      this.isBiggerThan80 = false,
      this.isBiggerThen150 = false,
      this.isBiggerThen120 = false,
      this.onTweet = false,
      this.onInsta = false,
      this.pageIndex = 0,
      this.selectedActivity,
      this.selectedFeeling,
      this.music,
      this.pickedDate,
      this.users,
      this.place,
      this.selectedLifeEvent,
      this.selectedLocation,
      this.selectedUsers,
      this.selectedPrivacy});
  CreatePostState copyWith({
    CreatePostStates? status,
    List<UploadFileEntity>? images,
    List<UploadFileEntity>? lifeEventImages,
    UploadFileEntity? audio,
    Failure? failure,
    String? gifImage,
    List<ActivityEntity>? activities,
    List<ActivityEntity>? subActivities,
    List<FeelingEntity>? feelings,
    ActivityEntity? selectedActivity,
    FeelingEntity? selectedFeeling,
    PlaceEntity? place,
    String? selectedPrivacy,
    List<PostUserEntity>? users,
    List<PostUserEntity>? selectedUsers,
    String? backColor,
    bool? isLast,
    bool? onTweet,
    bool? onInsta,
    bool? showBallet,
    String? selectedLocation,
    LifeEventEntity? selectedLifeEvent,
    int? pageIndex,
    bool? isSheetOpen,
    bool? isBiggerThan80,
    bool? isBiggerThen150,
    bool? isBiggerThen120,
    String? music,
    DateTime? pickedDate,
  }) {
    return CreatePostState(
      status: status ?? this.status,
      onTweet: onTweet ?? this.onTweet,
      onInsta: onInsta ?? this.onInsta,
      failure: failure ?? this.failure,
      images: images ?? this.images,
      lifeEventImages: lifeEventImages ?? this.lifeEventImages,
      audio: audio ?? this.audio,
      activities: activities ?? this.activities,
      subActivities: subActivities ?? this.subActivities,
      feelings: feelings ?? this.feelings,
      selectedActivity: selectedActivity ?? this.selectedActivity,
      selectedFeeling: selectedFeeling ?? this.selectedFeeling,
      selectedPrivacy: selectedPrivacy ?? this.selectedPrivacy,
      backColor: backColor ?? this.backColor,
      users: users ?? this.users,
      selectedUsers: selectedUsers ?? this.selectedUsers,
      place: place ?? this.place,
      isSheetOpen: isSheetOpen ?? this.isSheetOpen,
      isLast: isLast ?? this.isLast,
      showBallet: showBallet ?? this.showBallet,
      isBiggerThan80: isBiggerThan80 ?? this.isBiggerThan80,
      isBiggerThen150: isBiggerThen150 ?? this.isBiggerThen150,
      isBiggerThen120: isBiggerThen120 ?? this.isBiggerThen120,
      music: music ?? this.music,
      gifImage: gifImage ?? this.gifImage,
      selectedLocation: selectedLocation ?? this.selectedLocation,
      pageIndex: pageIndex ?? this.pageIndex,
      pickedDate: pickedDate ?? this.pickedDate,
      selectedLifeEvent: selectedLifeEvent ?? this.selectedLifeEvent,
    );
  }
}
