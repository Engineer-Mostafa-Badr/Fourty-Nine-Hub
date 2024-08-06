part of 'create_post_cubit.dart';

enum CreatePostStates { loading, initial, success, error }

class CreatePostState {
  final CreatePostStates status;
  final Failure? failure;
  final List<ActivityEntity>? activities;
  final List<FeelingEntity>? feelings;
  final ActivityEntity? selectedActivity;
  final FeelingEntity? selectedFeeling;
  final List<UploadFileEntity>? images;
  final String? selectedPrivacy;
  final String backColor;
  const CreatePostState(
      {
      this.status = CreatePostStates.error,
        this.failure,
        this.images,
      this.activities,
      this.feelings,
      this.backColor = "#FFFFFFFF",
      this.selectedActivity,
      this.selectedFeeling,
      this.selectedPrivacy});
  CreatePostState copyWith({
    CreatePostStates? status,
  List<UploadFileEntity>? images,
    Failure? failure,
    List<ActivityEntity>? activities,
    List<FeelingEntity>? feelings,
    ActivityEntity? selectedActivity,
    FeelingEntity? selectedFeeling,
    String? selectedPrivacy,
    String? backColor,
  }) {
    return CreatePostState(
      status: status?? this.status,
      failure: failure ?? this.failure,
      images: images ?? this.images,
      activities: activities ?? this.activities,
      feelings: feelings ?? this.feelings,
      selectedActivity: selectedActivity ?? this.selectedActivity,
      selectedFeeling: selectedFeeling ?? this.selectedFeeling,
      selectedPrivacy: selectedPrivacy ?? this.selectedPrivacy,
      backColor: backColor ?? this.backColor,
    );
  }
}
