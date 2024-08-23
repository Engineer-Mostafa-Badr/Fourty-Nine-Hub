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
  final List<PostUserEntity>? users;
  final List<PostUserEntity>? selectedUsers;
  final String? selectedPrivacy;
  final String backColor;
  final bool isLast;
  const CreatePostState(
      {this.status = CreatePostStates.error,
      this.failure,
      this.images,
      this.activities,
      this.feelings,
      this.backColor = "#FFFFFFFF",
      this.isLast = false,
      this.selectedActivity,
      this.selectedFeeling,
      this.users,
      this.place,
      this.selectedUsers,
      this.selectedPrivacy});
  CreatePostState copyWith({
    CreatePostStates? status,
    List<UploadFileEntity>? images,
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
  }) {
    return CreatePostState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      images: images ?? this.images,
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
    );
  }
}
