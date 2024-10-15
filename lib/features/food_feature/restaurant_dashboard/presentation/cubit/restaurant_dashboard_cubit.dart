import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../../../../../core/utils/shared_pref.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../requests_history/domain/entities/food_order_entity.dart';
import '../../data/models/restaurant_orders_model.dart';
import '../../domain/usecases/get_restaurant_orders_usecase.dart';

part 'restaurant_dashboard_state.dart';

class RestaurantDashboardCubit extends Cubit<RestaurantDashboardState> {
  final GetRestaurantOrdersUseCase _getRestaurantOrdersUseCase;
  final ApiConsumer apiConsumer;

  RestaurantDashboardCubit(this._getRestaurantOrdersUseCase, this.apiConsumer)
      : super(const RestaurantDashboardState());

  void loadData() async {
    print('fromRestaurantDashboardCubitloadData');

    await getRestaurantOrders1();
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

          print("${ordersResponse.data.orders.length}aaaaaaaaaa");
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

  Future<void> getRestaurantOrders1() async {
    emit(state.copyWith(status: RestaurantDashboardStates.initState));

    // The API endpoint URL
    const String url = 'https://49dev.com/api/v1/food/get-restaurant-orders';

    try {
      // Make the GET request using ApiConsumer
      final response = await apiConsumer.get(
        url,
      );

      // Handle the response from the API
      response.fold(
        (failure) {
          print('asffadvvvdbsdv11b');

          // Handle error state
          emit(state.copyWith(status: RestaurantDashboardStates.error));
        },
        (jsonList) {
          print('asffadvvvdbsdvb');

          // Assuming the response is a JSON array with a single object
          if (jsonList.isNotEmpty) {
            print('asffadvvvdbsdvb11');

            final ordersResponse = RestaurantOrdersModel.fromJson(jsonList);

            print("$jsonList aaaaaaaaaa");
            emit(state.copyWith(orders: ordersResponse));
          } else {
            // Handle the case where the response is empty
            emit(state.copyWith(status: RestaurantDashboardStates.error));
          }
        },
      );
    } catch (e) {
      // Handle exceptions
      emit(state.copyWith(status: RestaurantDashboardStates.error));
    }
  }

  Future<void> deleteRestaurantById(context, {required String id}) async {
    emit(state.copyWith(status: RestaurantDashboardStates.initState));

    // The API endpoint URL
    final String url =
        'https://49dev.com/api/v1/restaurants/delete-restaurant/$id';

    try {
      // Make the GET request using ApiConsumer
      final response = await apiConsumer.delete(
        url,
      );

      // Handle the response from the API
      response.fold(
        (failure) {
          // Handle error state
          showErrorMessage(context, getFailureMessage(failure, context));
          Navigator.pop(context);

          emit(state.copyWith(status: RestaurantDashboardStates.error));
        },
        (jsonList) {
          showSuccessMessage(context, jsonList['message']);
          Navigator.pop(context);

          print('${jsonList}1111111111111111');
        },
      );
    } catch (e) {
      // Handle exceptions
      emit(state.copyWith(status: RestaurantDashboardStates.error));
    }
  }

  Future<void> approveRequest({required int id}) async {
    emit(state.copyWith(
        status: RestaurantDashboardStates.success,
        successMessage: Labels.bookingApproved));
    getRestaurantOrders();
  }

  Future<void> changeConnectivityStatus(isActive) async {
    const url = 'https://49dev.com/api/v1/restaurants/modify-active';

    final res = apiConsumer.patch(url, data: {
      'isActive': isActive,
    });

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
