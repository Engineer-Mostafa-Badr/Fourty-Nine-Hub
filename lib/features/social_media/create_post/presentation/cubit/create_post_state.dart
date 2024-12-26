part of 'create_post_cubit.dart';

enum CreatePostStates { loading, initial, success, error }

class CreatePostState {
  final CreatePostStates status;
  final Failure? failure;
  final List<ActivityEntity>? activities;
  final List<FeelingEntity>? feelings;
  final ActivityEntity? selectedActivity;
  final FeelingEntity? selectedFeeling;
  final PlaceEntity? place;
  final List<UploadFileEntity>? images;
  final UploadFileEntity? audio;
  final List<PostUserEntity>? users;
  final List<PostUserEntity>? selectedUsers;
  final String? selectedPrivacy;
  String? backColor;
  final bool isLast;
  final bool isBiggerThan80;
  final bool isBiggerThen150;
  final bool isBiggerThen120;
  final String? music;
  CreatePostState(
      {this.status = CreatePostStates.error,
      this.failure,
      this.images,
      this.audio,
      this.activities,
      this.feelings,
      this.backColor = "#FFFFFFFF",
      this.isLast = false,
      this.isBiggerThan80 = false,
      this.isBiggerThen150 = false,
      this.isBiggerThen120 = false,
      this.selectedActivity,
      this.selectedFeeling,
      this.music,
      this.users,
      this.place,
      this.selectedUsers,
      this.selectedPrivacy});
  CreatePostState copyWith({
    CreatePostStates? status,
    List<UploadFileEntity>? images,
    UploadFileEntity? audio,
    Failure? failure,
    List<ActivityEntity>? activities,
    List<FeelingEntity>? feelings,
    ActivityEntity? selectedActivity,
    FeelingEntity? selectedFeeling,
    PlaceEntity? place,
    String? selectedPrivacy,
    List<PostUserEntity>? users,
    List<PostUserEntity>? selectedUsers,
    String? backColor,
    bool? isLast,
    bool? isBiggerThan80,
    bool? isBiggerThen150,
    bool? isBiggerThen120,
    String? music,
  }) {
    return CreatePostState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      images: images ?? this.images,
      audio: audio ?? this.audio,
      activities: activities ?? this.activities,
      feelings: feelings ?? this.feelings,
      selectedActivity: selectedActivity ?? this.selectedActivity,
      selectedFeeling: selectedFeeling ?? this.selectedFeeling,
      selectedPrivacy: selectedPrivacy ?? this.selectedPrivacy,
      backColor: backColor ?? this.backColor,
      users: users ?? this.users,
      selectedUsers: selectedUsers ?? this.selectedUsers,
      place: place ?? this.place,
      isLast: isLast ?? this.isLast,
      isBiggerThan80: isBiggerThan80 ?? this.isBiggerThan80,
      isBiggerThen150: isBiggerThen150 ?? this.isBiggerThen150,
      isBiggerThen120: isBiggerThen120 ?? this.isBiggerThen120,
      music: music ?? this.music,
    );
  }
}
