import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/core/messages/messages.dart';
import 'package:fourtyninehub/routes/pages.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../common/functions/global/upload_file.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/localization/locale_keys.g.dart';
import '../../../../../res/strings/labels.dart';
import '../../../../authentication/presentation/controllers/user_cubit/user_cubit.dart';
import '../../../../health_feature/create_doctor/domain/entities/city.dart';
import '../../../../health_feature/create_doctor/domain/entities/governorate_entity.dart';
import '../../../../health_feature/create_doctor/domain/usecases/get_cities.dart';
import '../../../../health_feature/create_doctor/domain/usecases/get_governorates.dart';
import '../../../../health_feature/health/domain/usecases/get_health_subcategories.dart';
import '../../../../health_feature/health/presentation/controllers/shared_data/health_shared_data.dart';
import '../../../../subcategories/domain/entities/sub_category_entity.dart';
import '../../../restaurants_list/data/models/is_restaurant_model.dart';
import '../../../restaurants_list/domain/entities/restaurant.dart';
import '../../../restaurants_list/domain/usecases/change_connectivity_use_case.dart';
import '../../../restaurants_list/domain/usecases/create_restaurant.dart';
import '../../../restaurants_list/domain/usecases/is_resturant_usecase.dart';
import '../../domain/entity/complete_order_entity.dart';
import '../../domain/entity/order_food_entity.dart';
import '../../domain/usecases/complete_order_restaurant_usecase.dart';
import '../../domain/usecases/delete_restaurant_usecase.dart';
import '../../domain/usecases/get_restaurant_orders_usecase.dart';
import '../../domain/usecases/get_restaurant_statistics_usecase.dart';
import '../../domain/usecases/get_restaurant_usecase.dart';
import '../../domain/usecases/update_restaurant_usecase.dart';
import 'restaurant_statistics_cubit.dart';

part 'restaurant_dashboard_state.dart';

class RestaurantDashboardCubit extends Cubit<RestaurantDashboardState> {
  final GetRestaurantStatisticUseCase _getRestaurantStatisticUseCase;
  final GetRestaurantInfoUseCase _getRestaurantInfoUseCase;
  final IsResturantUsecase _isRestaurantUsecase;
  final DeleteRestaurantUseCase _deleteRestaurantUseCase;
  final GetRestaurantOrdersUseCase _getRestaurantOrdersUseCase;
  final ChangeConnectivityUseCase _changeConnectivityUseCase;
  final GetHealthSubcategoriesUseCase _getHealthSubcategoriesUseCase;
  final GetGovernoratesUseCase _getGovernoratesUseCase;
  final GetCitiesUseCase _getCitiesUseCase;
  final HealthSharedData _shareCubit;
  final UpdateRestaurantUseCase _updateRestaurantUseCase;
  final CompleteOrderUseCase completeOrderUseCase;
  List<XFile> restaurantImages = [];

  List<String> restaurantImagesIds = [];

  final CreateRestaurantParams createRestaurantParams =
      CreateRestaurantParams();

  bool isLoadingMore = false;
  bool hasMoreData = true;
  int currentPage = 1;
  int pageSize = 3;

  List<OrderEntity> orders = [];

  List<OrderEntity> ordersPast = [];

  bool isLoadingMorePast = false;

  bool hasMoreDataPast = true;

  int currentPagePast = 1;

  RestaurantDashboardCubit(
      this._getRestaurantStatisticUseCase,
      this._getRestaurantOrdersUseCase,
      this._getRestaurantInfoUseCase,
      this._isRestaurantUsecase,
      this._changeConnectivityUseCase,
      this._deleteRestaurantUseCase,
      this._getHealthSubcategoriesUseCase,
      this._getGovernoratesUseCase,
      this._getCitiesUseCase,
      this._shareCubit,
      this._updateRestaurantUseCase,
      this.completeOrderUseCase)
      : super(const RestaurantDashboardState());

  Future<void> approveRequest({required int id}) async {
    emit(state.copyWith(
        status: RestaurantDashboardStates.success,
        successMessage: Labels.bookingApproved));
    // getRestaurantOrders();
  }

  Future<void> cancelBooking({required int id}) async {
    emit(state.copyWith(
        status: RestaurantDashboardStates.success,
        successMessage: Labels.bookingRejected));
    // getRestaurantOrders();
  }

  Future<void> changeConnectivityStatus(isActive) async {
    print("objectssssss$isActive");
    final response = await _changeConnectivityUseCase(params: isActive);
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(status: RestaurantDashboardStates.error));
    }, (data) async {
      await isRestaurant();
    });
  }

  Future<void> completeOrder(String orderId) async {
    emit(state.copyWith(status: RestaurantDashboardStates.loading));

    final response = await completeOrderUseCase(
      CompleteOrderParams(orderId: orderId),
    );

    response.fold(
      (failure) async {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: RestaurantDashboardStates.error));
        // await loadData();
        // await loadDataPast();
      },
      (blockHealthEntity) async {
        emit(state.copyWith(
          completeOrderEntity: blockHealthEntity,
          status: RestaurantDashboardStates.success,
        ));
        await loadData(); // refresh current orders
        await loadDataPast(); // refresh past orders
      },
    );
  }

  Future<void> deleteRestaurantById(BuildContext context,
      {required String id, required String subCategoryId}) async {
    final response = await _deleteRestaurantUseCase(
        DeleteResturantParams(restaurantId: id, subCategoryId: subCategoryId));
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
      emit(state.copyWith(status: RestaurantDashboardStates.error));
    }, (data) async {
      context.pop(true);
    });
  }

  Future<void> getCities(String governorateId) async {
    // emit(CreateResturantCitiesLoading());
    final response = await _getCitiesUseCase.call(governorateId);

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure));
      },
      (data) => emit(state.copyWith(cities: data)),
    );
  }

  Future<void> getGovernorates() async {
    if (_shareCubit.governorates.isEmpty) {
      final response = await _getGovernoratesUseCase.call(const NoParams());
      response.fold((failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure));
      }, (data) {
        _shareCubit.governorates = data;
        emit(state.copyWith(governorates: data));
      });
    } else {
      emit(state.copyWith(governorates: _shareCubit.governorates));
    }
  }

  Future<void> getOrders(bool isCompleted) async {
    if (!hasMoreData || isLoadingMore) return;

    isLoadingMore = true;

    final response = await _getRestaurantOrdersUseCase(
        PaginationOrderFoodParams(
            page: currentPage, limit: pageSize, isCompleted: isCompleted));

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: RestaurantDashboardStates.error));
      },
      (data) {
        orders.addAll(data.data!.orders!);

        if (data.data!.orders!.length < pageSize) {
          hasMoreData = false;
        } else {
          currentPage++;
        }

        isLoadingMore = false;
        emit(state.copyWith(
            status: RestaurantDashboardStates.success, orders: data));
      },
    );
  }

  Future<void> getOrdersPast(bool isCompleted) async {
    if (!hasMoreDataPast || isLoadingMorePast) return;

    isLoadingMorePast = true;

    final response = await _getRestaurantOrdersUseCase(
        PaginationOrderFoodParams(
            page: currentPagePast, limit: pageSize, isCompleted: isCompleted));

    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(
            failure: failure, status: RestaurantDashboardStates.error));
      },
      (data) {
        ordersPast.addAll(data.data!.orders!);

        if (data.data!.orders!.length < pageSize) {
          hasMoreDataPast = false;
        } else {
          currentPagePast++;
        }

        isLoadingMorePast = false;
        emit(state.copyWith(
            status: RestaurantDashboardStates.success, ordersPast: data));
      },
    );
  }

  Future<void> getRestaurantInfo() async {
    if (isClosed) return; // Prevent emitting after closing

    emit(state.copyWith(status: RestaurantDashboardStates.loading));

    final response = await _getRestaurantInfoUseCase(const NoParams());
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        if (!isClosed) {
          emit(state.copyWith(status: RestaurantDashboardStates.error));
        }
      },
      (data) async {
        await isRestaurant();
        await getRestaurantStatistics();

        if (!isClosed) {
          emit(state.copyWith(
            info: data,
            status: RestaurantDashboardStates.success,
          ));
        }
      },
    );
  }

  Future<void> getRestaurantInfo1() async {
    emit(state.copyWith(status: RestaurantDashboardStates.loading));

    final response = await _getRestaurantInfoUseCase(const NoParams());
    response.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
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
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(status: RestaurantDashboardStates.error));
      },
      (data) async {
        emit(state.copyWith(
            statistics: data, status: RestaurantDashboardStates.success));
      },
    );
  }

  // Future<void> selectGovernorate(GovernorateEntity value) async {
  //   _createDoctorParams.address.governorateId = value.id;
  //   await _getCities(value.id);
  // }
  //
  // void selectCity(CityEntity value) {
  //   _createDoctorParams.address.cityId = value.id;
  // }
  //
  // void selectSubcategory(SubCategoryEntity subCategoryModel) {
  //   _createDoctorParams.subCategoryId = subCategoryModel.id;
  // }

  Future<void> getSubCategories() async {
    final userId = UserCubit.to.state.data?.id;

    if (_shareCubit.subCategories.isEmpty) {
      final response = await _getHealthSubcategoriesUseCase.call(userId ?? '');
      response.fold((failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        emit(state.copyWith(failure: failure));
      }, (data) {
        _shareCubit.subCategories = data;
        emit(state.copyWith(subCategories: data));
      });
    } else {
      emit(state.copyWith(subCategories: _shareCubit.subCategories));
    }
  }

  void initialize() {
    getRestaurantInfo();
  }

  Future<void> isRestaurant() async {
    final response = await _isRestaurantUsecase(const NoParams());
    response.fold((failure) {
      var currentContext =
          AppPages.router.configuration.navigatorKey.currentContext!;
      showErrorMessage(
          currentContext, getFailureMessage(failure, currentContext));
    }, (data) {
      emit(state.copyWith(isRestaurant: data));
    });
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

  Future<void> loadData() async {
    print("Current $orders");
    emit(state.copyWith(status: RestaurantDashboardStates.loading));
    orders.clear();
    currentPage = 1;
    hasMoreData = true;
    await getOrders(false);
  }

  Future<void> loadDataPast() async {
    print("past $orders");

    emit(state.copyWith(status: RestaurantDashboardStates.loading));
    ordersPast.clear();
    currentPagePast = 1;
    hasMoreDataPast = true;
    await getOrdersPast(true);
  }

  void removeFile(XFile file) {
    // Remove from both the state and the maintained list
    final files = state.files?.where((f) => f.path != file.path).toList() ?? [];
    restaurantImages.removeWhere((f) => f.path == file.path);
    emit(state.copyWith(files: files));
  }

  Future<void> updateRestaurant1(
      {required UpdateRestaurantParams params}) async {
    if (isClosed) return; // Prevent errors if cubit is closed

    final result = await _updateRestaurantUseCase(params);

    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));

        if (!isClosed) {
          emit(state.copyWith(status: RestaurantDashboardStates.error));
        }
      },
      (updatedRestaurant) async {
        if (!isClosed) {
          // await getRestaurantInfo();
          emit(state.copyWith(status: RestaurantDashboardStates.success));
        }
      },
    );
  }

  Future<void> updateRestaurant12(
      {required UpdateRestaurantParams params}) async {
    // emit(state.copyWith(status: StateStatus.loading));

    final result = await _updateRestaurantUseCase(params);

    result.fold(
      (failure) {
        var currentContext =
            AppPages.router.configuration.navigatorKey.currentContext!;
        showErrorMessage(
            currentContext, getFailureMessage(failure, currentContext));
        // showErrorMessage(context, getFailureMessage(failure, context));
      },
      (updatedRestaurant) {
        getRestaurantInfo();
        emit(state.copyWith(status: RestaurantDashboardStates.success));
        // emit(state.copyWith(
        //   restaurantEntity: updatedRestaurant,
        //   status: StateStatus.success,
        //   showSnackbar: true,
        // ));
      },
    );
  }

  Future<void> uploadProfileImage(
      {subcategoryId, required BuildContext context}) async {
    await _uploadImage(
        subcategoryId: subcategoryId,
        context: context,
        onUploaded: (media) {
          // Clear previous images if needed, or just append
          restaurantImages.add(media.file);
          restaurantImagesIds.add(media.mediaId);
          createRestaurantParams.restaurantMedia = restaurantImagesIds;

          // Use the restaurantImages list directly to ensure consistency
          emit(state.copyWith(files: List.from(restaurantImages)));
        });
  }

  Future<void> uploadProfileImage1(
      {subcategoryId, required BuildContext context}) async {
    await _uploadImage(
        subcategoryId: subcategoryId,
        context: context,
        onUploaded: (media) {
          restaurantImages.add(media.file);
          restaurantImagesIds.add(media.mediaId);
          createRestaurantParams.restaurantMedia = restaurantImagesIds;

          emit(state.copyWith(files: restaurantImages));
        });
  }

  Future<void> _uploadImage(
      {required dynamic Function(UploadFileEntity) onUploaded,
      required BuildContext context,
      subcategoryId}) async {
    if (createRestaurantParams.subcategoryId != null ||
        createRestaurantParams.subcategoryId != "" ||
        subcategoryId != null) {
      emit(state.copyWith(uploadImageError: LocaleKeys.uploadingImage.tr()));
      await UploadFile().uploadImage(
        subCategoryId:
            createRestaurantParams.subcategoryId ?? subcategoryId ?? '',
        onUploaded: (value) {
          onUploaded(value);
        },
        context: context,
      );
      // emit(CreateRestaurantCloseLoading());
    } else {
      emit(state.copyWith(
          uploadImageError: LocaleKeys.selectSubcategoryFirst.tr()));
    }
  }
}
