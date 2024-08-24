part of 'create_menu_cubit.dart';

abstract class RestaurantMenuState {}

class RestaurantMenuInitial extends RestaurantMenuState {}

class RestaurantMenuLoading extends RestaurantMenuState {}

final class RestaurantUpLoadPhototLoading extends RestaurantMenuState {
  final String message;
  RestaurantUpLoadPhototLoading(this.message);
}

class CreateMenuCloseLoading extends RestaurantMenuState {}

class RestaurantMenuLoaded extends RestaurantMenuState {
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
