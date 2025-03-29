part of 'edit_food_cubit.dart';

enum EditFoodStates {
  loading,
  filterLoading,
  initState,
  error,
  success,
  requestSuccess,
  requestLoading
}

extension EditFoodStateX on EditFoodState {
  bool get isInitial => status == EditFoodStates.initState;
  bool get isLoading => status == EditFoodStates.loading;
  bool get isFilterLoading => status == EditFoodStates.filterLoading;
  bool get isError => status == EditFoodStates.error;
  bool get isSuccess => status == EditFoodStates.success;
  bool get isRequestSuccess => status == EditFoodStates.requestSuccess;
  bool get isRequestLoading => status == EditFoodStates.requestLoading;
}

@immutable
class EditFoodState {
  final EditFoodStates status;
  final Failure? failure;
  final Restaurant? restaurant;
  final String? successMessage;
  final String? imagePath;
  final bool connected;
  final List<RestaurantMenu>? meals;
  final IsRestaurantModel? isResturant;
  final List<XFile>? files;
  const EditFoodState({
    this.status = EditFoodStates.loading,
    this.failure,
    this.restaurant,
    this.imagePath,
    this.meals,
    this.connected = true,
    this.successMessage,
    this.isResturant,
    this.files,
  });
  EditFoodState copyWith({
    EditFoodStates? status,
    Failure? failure,
    Restaurant? restaurant,
    List<RestaurantMenu>? meals,
    bool? connected,
    String? imagePath,
    String? successMessage,
    IsRestaurantModel? isResturant,
    List<XFile>? files,
  }) {
    return EditFoodState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      imagePath: imagePath ?? this.imagePath,
      connected: connected ?? this.connected,
      restaurant: restaurant ?? this.restaurant,
      meals: meals ?? this.meals,
      successMessage: successMessage ?? this.successMessage,
      isResturant: isResturant ?? this.isResturant,
      files: files ?? this.files,
    );
  }
}
