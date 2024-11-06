// part of 'restaurant_dashboard_cubit.dart';
//
// enum RestaurantDashboardStates { loading,filterLoading, initState, error, success,requestSuccess,requestLoading }
// extension RestaurantDashboardStatesX on RestaurantDashboardStates {
//   bool get isInitial => status == RestaurantDashboardStates.initState;
//   bool get isLoading => status == RestaurantDashboardStates.loading;
//   bool get isFilterLoading => status == RestaurantDashboardStates.filterLoading;
//   bool get isError => status == RestaurantDashboardStates.error;
//   bool get isSuccess => status == RestaurantDashboardStates.success;
//   bool get isRequestSuccess => status == RestaurantDashboardStates.requestSuccess;
//   bool get isRequestLoading => status == RestaurantDashboardStates.requestLoading;}
//
// @immutable
// class RestaurantDashboardState {
//   final RestaurantDashboardStates status;
//   final Failure? failure;
//   final String? successMessage;
//   final Restaurant2Model? info;
//   final IsRestaurantModel? isRestaurant;
//   final bool connected;
//   final RestaurantOrdersModel? orders;
//   const RestaurantDashboardState(
//       {this.status = RestaurantDashboardStates.loading,
//       this.failure,
//       this.info,
//       this.isRestaurant,
//       this.connected = true,
//       this.successMessage,
//       this.orders});
//   RestaurantDashboardState copyWith(
//       {RestaurantDashboardStates? status,
//       Failure? failure,
//         IsRestaurantModel? isRestaurant,
//       RestaurantOrdersModel? orders,
//         Restaurant2Model? info,
//       bool? connected,
//       String? successMessage}) {
//     return RestaurantDashboardState(
//         status: status ?? this.status,
//         failure: failure ?? this.failure,
//         connected: connected ?? this.connected,
//         info: info ?? this.info,
//         isRestaurant: isRestaurant ?? this.isRestaurant,
//         successMessage: successMessage ?? this.successMessage,
//         orders: orders ?? this.orders);
//   }
// }
//
//



part of 'restaurant_dashboard_cubit.dart';

enum RestaurantDashboardStates { loading,filterLoading, initState, error, success,requestSuccess,requestLoading }

extension RestaurantDashboardStateX on RestaurantDashboardState {
  bool get isInitial => status == RestaurantDashboardStates.initState;
  bool get isLoading => status == RestaurantDashboardStates.loading;
  bool get isFilterLoading => status == RestaurantDashboardStates.filterLoading;
  bool get isError => status == RestaurantDashboardStates.error;
  bool get isSuccess => status == RestaurantDashboardStates.success;
  bool get isRequestSuccess => status == RestaurantDashboardStates.requestSuccess;
  bool get isRequestLoading => status == RestaurantDashboardStates.requestLoading;}

@immutable
class RestaurantDashboardState {
  final RestaurantDashboardStates status;
  final Failure? failure;
  final String? successMessage;
  final Restaurant2Model? info;
  final RestaurantStatistics? statistics;
  final IsRestaurantModel? isRestaurant;
  final bool connected;
  final RestaurantOrdersModel? orders;
  RestaurantDashboardState(
      {this.status = RestaurantDashboardStates.loading,
        this.failure,
        this.info,
        this.isRestaurant,
        this.statistics,
        this.connected = true,
        this.successMessage,
        this.orders});
  RestaurantDashboardState copyWith(
      {RestaurantDashboardStates? status,
        Failure? failure,
        IsRestaurantModel? isRestaurant,
        RestaurantOrdersModel? orders,
        Restaurant2Model? info,
        RestaurantStatistics? statistics,
        bool? connected,
        String? successMessage}) {
    return RestaurantDashboardState(
        status: status ?? this.status,
        failure: failure ?? this.failure,
        connected: connected ?? this.connected,
        statistics: statistics ?? this.statistics,
        info: info ?? this.info,
        isRestaurant: isRestaurant ?? this.isRestaurant,
        successMessage: successMessage ?? this.successMessage,
        orders: orders ?? this.orders);
  }
}
