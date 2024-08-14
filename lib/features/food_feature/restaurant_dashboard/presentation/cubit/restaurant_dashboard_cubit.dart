import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../requests_history/domain/entities/food_order_entity.dart';
import '../../domain/usecases/get_restaurant_orders_usecase.dart';

part 'restaurant_dashboard_state.dart';

class RestaurantDashboardCubit extends Cubit<RestaurantDashboardState> {
  final GetRestaurantOrdersUseCase _getRestaurantOrdersUseCase;
  RestaurantDashboardCubit(this._getRestaurantOrdersUseCase)
      : super(const RestaurantDashboardState());

  void loadData() async {
    await getRestaurantOrders();
  }

  Future<void> getRestaurantOrders() async {
    final response = await _getRestaurantOrdersUseCase.call(const NoParams());
    response.fold(
        (l) => emit(state.copyWith(
            failure: l, status: RestaurantDashboardStates.error)),
        (data) => emit(state.copyWith(
            orders: data, status: RestaurantDashboardStates.initState)));
  }

  Future<void> approveRequest({required int id}) async {
    emit(state.copyWith(
        status: RestaurantDashboardStates.success,
        successMessage: Labels.bookingApproved));
    getRestaurantOrders();
  }

  Future<void> changeConnectivityStatus() async {
    emit(state.copyWith(
      connected: !state.connected,
    ));
  }

  Future<void> cancelBooking({required int id}) async {
    emit(state.copyWith(
        status: RestaurantDashboardStates.success,
        successMessage: Labels.bookingRejected));
    getRestaurantOrders();
  }
}
