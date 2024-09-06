part of 'create_menu_cubit.dart';

sealed class RestaurantMenuState {}

final class RestaurantMenuInitial extends RestaurantMenuState {}

final class RestaurantMenuLoading extends RestaurantMenuState {}

final class RestaurantUpLoadPhototLoading extends RestaurantMenuState {
  final String message;
  RestaurantUpLoadPhototLoading(this.message);
}

final class CreateMenuCloseLoading extends RestaurantMenuState {}

final class RestaurantMenuLoaded extends RestaurantMenuState {
  final List<RestaurantMneuModel> menu;

  RestaurantMenuLoaded(this.menu);
}

class RestaurantMenuError extends RestaurantMenuState {
  final String error;

  RestaurantMenuError(this.error);
}

class RestaurantMenuImagePicked extends RestaurantMenuState {
  final String imagePath;

  RestaurantMenuImagePicked(this.imagePath);
}
