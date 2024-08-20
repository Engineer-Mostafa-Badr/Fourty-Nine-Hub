part of 'restaurant_dashboard_cubit.dart';

enum RestaurantDashboardStates { loading, error, initState, success }

class RestaurantDashboardState {
  final RestaurantDashboardStates status;
  final Failure? failure;
  final String? successMessage;
  final bool connected;
  final List<FoodOrderEntity>? orders;
  const RestaurantDashboardState(
      {this.status = RestaurantDashboardStates.loading,
      this.failure,
      this.connected = true,
      this.successMessage,
      this.orders});
  RestaurantDashboardState copyWith(
      {RestaurantDashboardStates? status,
      Failure? failure,
      List<FoodOrderEntity>? orders,
      bool? connected,
      String? successMessage}) {
    return RestaurantDashboardState(
        status: status ?? this.status,
        failure: failure ?? this.failure,
        connected: connected ?? this.connected,
        successMessage: successMessage ?? this.successMessage,
        orders: orders ?? this.orders);
  }
}
