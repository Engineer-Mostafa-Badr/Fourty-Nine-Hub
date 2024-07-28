part of 'create_post_cubit.dart';

enum CreatePostStates { loading, initial, success, error }

class CreatePostState {
  final CreatePostStates status;
  final Failure? failure;
  final List<ActivityEntity>? activities;
  final List<FeelingEntity>? feelings;
  final ActivityEntity? selectedActivity;
  final FeelingEntity? selectedFeeling;
  final UploadFileEntity? fileEntity;
  final Color backColor;
  const CreatePostState(
      {
      this.status = CreatePostStates.error,
        this.failure,
        this.fileEntity,
      this.activities,
      this.feelings,
      this.backColor = Colors.white,
      this.selectedActivity,
      this.selectedFeeling});
  CreatePostState copyWith({
    CreatePostStates? status,
    UploadFileEntity? fileEntity,
    Failure? failure,
    List<ActivityEntity>? activities,
    List<FeelingEntity>? feelings,
    ActivityEntity? selectedActivity,
    FeelingEntity? selectedFeeling,
    Color? backColor,
  }) {
    return CreatePostState(
      status: status?? this.status,
      failure: failure ?? this.failure,
      fileEntity: fileEntity ?? this.fileEntity,
      activities: activities ?? this.activities,
      feelings: feelings ?? this.feelings,
      selectedActivity: selectedActivity ?? this.selectedActivity,
      selectedFeeling: selectedFeeling ?? this.selectedFeeling,
      backColor: backColor ?? this.backColor,
    );
  }
}
