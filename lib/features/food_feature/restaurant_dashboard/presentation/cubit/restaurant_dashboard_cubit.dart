import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/shared_pref.dart';
import '../../../../../res/strings/labels.dart';
import '../../data/models/restaurant_orders_model.dart';
import '../../domain/usecases/get_restaurant_orders_usecase.dart';

part 'restaurant_dashboard_state.dart';

class RestaurantDashboardCubit extends Cubit<RestaurantDashboardState> {
  final GetRestaurantOrdersUseCase _getRestaurantOrdersUseCase;

  RestaurantDashboardCubit(this._getRestaurantOrdersUseCase)
      : super(const RestaurantDashboardState());

  void loadData() async {
    print('fromRestaurantDashboardCubitloadData');

    await getRestaurantOrders();
  }

  String? _token;

  Future<void> _ensureTokenInitialized() async {
    _token ??= await TokenManager.getAccessToken();
  }

  // Future<void> getRestaurantOrders() async {
  //   final response = await _getRestaurantOrdersUseCase.call(const NoParams());
  //   response.fold(
  //       (l) => emit(state.copyWith(
  //           failure: l, status: RestaurantDashboardStates.error)),
  //       (data) => emit(state.copyWith(
  //           orders: data, status: RestaurantDashboardStates.initState)));
  // }

  Future<void> getRestaurantOrders() async {
    await _ensureTokenInitialized(); // Ensure token is initialized

    emit(state.copyWith(status: RestaurantDashboardStates.initState));

    final url =
        Uri.parse('https://49dev.com/api/v1/food/get-restaurant-orders');

    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );
      print("${response.body}$_token aaaaaaaaaa");

      if (response.statusCode == 200) {
        // Assuming the response is a JSON array with a single object
        final List<dynamic> jsonList = json.decode(response.body);

        if (jsonList.isNotEmpty) {
          final RestaurantOrdersModel ordersResponse =
              RestaurantOrdersModel.fromJson(jsonList[0]);

          print("${ordersResponse.data.length}aaaaaaaaaa");
          emit(state.copyWith(orders: ordersResponse));
        } else {
          emit(state.copyWith(status: RestaurantDashboardStates.error));
        }
      } else {
        emit(state.copyWith(status: RestaurantDashboardStates.error));
      }
    } catch (e) {
      emit(state.copyWith(status: RestaurantDashboardStates.error));
    }
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
