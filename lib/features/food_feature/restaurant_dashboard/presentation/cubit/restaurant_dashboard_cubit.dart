import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/common/models/public/pagination_params.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/delete_restaurant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/get_restaurant_statistics_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/domain/usecases/get_restaurant_usecase.dart';
import 'package:fourtyninehub/features/food_feature/restaurant_dashboard/presentation/cubit/restaurant_statistics_cubit.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/is_restaurant_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/data/models/restaurant_2_model.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/change_connectivity_use_case.dart';
import 'package:fourtyninehub/features/food_feature/restaurants_list/domain/usecases/is_resturant_usecase.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/error/failure.dart';
import '../../../../../res/strings/labels.dart';
import '../../data/models/restaurant_orders_model.dart';
import '../../domain/usecases/get_restaurant_orders_usecase.dart';

part 'restaurant_dashboard_state.dart';

class RestaurantDashboardCubit extends Cubit<RestaurantDashboardState> {
  final GetRestaurantStatisticUseCase _getRestaurantStatisticUseCase;
  final GetRestaurantInfoUseCase _getRestaurantInfoUseCase;
  final IsResturantUsecase _isRestaurantUsecase;
  final DeleteRestaurantUseCase _deleteRestaurantUseCase;
  final GetRestaurantOrdersUseCase _getRestaurantOrdersUseCase;
  final ChangeConnectivityUseCase _changeConnectivityUseCase;

  RestaurantDashboardCubit(
      this._getRestaurantStatisticUseCase,
      this._getRestaurantOrdersUseCase,
      this._getRestaurantInfoUseCase,
      this._isRestaurantUsecase,
      this._changeConnectivityUseCase,
      this._deleteRestaurantUseCase)
      : super(const RestaurantDashboardState());

  void initialize() {
    getRestaurantInfo();
  }

  // Future<void> getRestaurantOrders () async{
  //   emit(state.copyWith(status: RestaurantDashboardStates.loading));
  //
  //   final response = await _getRestaurantOrdersUseCase(const NoParams());
  //   response.fold(
  //         (failure) {
  //       emit(state.copyWith(status: RestaurantDashboardStates.error));
  //     },
  //         (data) async{
  //       emit(state.copyWith(orders: data,status: RestaurantDashboardStates.success));
  //     },
  //   );
  // }

  void loadData() async {
    emit(state.copyWith(status: RestaurantDashboardStates.loading));
    orders.clear();
    currentPage = 1;
    hasMoreData = true;
    await getOrders();
  }

  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 3;
  List<RestaurantOrder> orders = [];

  Future<void> getOrders() async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _getRestaurantOrdersUseCase(
        PaginationParams(page: currentPage, limit: pageSize));

    response.fold(
      (failure) => emit(state.copyWith(
          failure: failure, status: RestaurantDashboardStates.error)),
      (data) {
        orders.addAll(data.data.orders);

        if (data.data.orders.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(
            status: RestaurantDashboardStates.initState, orders: data));
      },
    );
  }

  Future<void> getRestaurantInfo() async {
    emit(state.copyWith(status: RestaurantDashboardStates.loading));

    final response = await _getRestaurantInfoUseCase(const NoParams());
    response.fold(
      (failure) {
        emit(state.copyWith(status: RestaurantDashboardStates.error));
      },
      (data) async {
        await isRestaurant();
        await getRestaurantStatistics();
        // await getRestaurantOrders();
        emit(state.copyWith(
            info: data, status: RestaurantDashboardStates.success));
      },
    );
  }

  Future<void> getRestaurantStatistics() async {
    emit(state.copyWith(status: RestaurantDashboardStates.loading));

    final response = await _getRestaurantStatisticUseCase(const NoParams());
    response.fold(
      (failure) {
        emit(state.copyWith(status: RestaurantDashboardStates.error));
      },
      (data) async {
        emit(state.copyWith(
            statistics: data, status: RestaurantDashboardStates.success));
      },
    );
  }

  Future<void> isRestaurant() async {
    final response = await _isRestaurantUsecase(const NoParams());
    response.fold((failure) => {}, (data) {
      emit(state.copyWith(isRestaurant: data));
    });
  }

  Future<void> changeConnectivityStatus(isActive) async {
    print("objectssssss$isActive");
    final response = await _changeConnectivityUseCase(params: isActive);
    response.fold(
        (failure) =>
            emit(state.copyWith(status: RestaurantDashboardStates.error)),
        (data) async {
      await isRestaurant();
    });
  }

  Future<void> deleteRestaurantById(BuildContext context,
      {required String id, required String subCategoryId}) async {
    final response = await _deleteRestaurantUseCase(
        DeleteResturantParams(restaurantId: id, subCategoryId: subCategoryId));
    response.fold(
        (failure) =>
            emit(state.copyWith(status: RestaurantDashboardStates.error)),
        (data) async {
      context.pop(true);
    });
  }

  Future<void> approveRequest({required int id}) async {
    emit(state.copyWith(
        status: RestaurantDashboardStates.success,
        successMessage: Labels.bookingApproved));
    // getRestaurantOrders();
  }

  // Future<void> changeConnectivityStatus(isActive) async {
  //   const url = 'https://49dev.com/api/v1/restaurants/modify-active';
  //
  //   final res =await apiConsumer.patch(url, data: {
  //     'isActive': isActive,
  //   });
  //
  //   emit(state.copyWith(
  //     connected: !state.connected,
  //   ));
  // }

  Future<void> cancelBooking({required int id}) async {
    emit(state.copyWith(
        status: RestaurantDashboardStates.success,
        successMessage: Labels.bookingRejected));
    // getRestaurantOrders();
  }
}
