part of 'restaurant_dashboard_cubit.dart';

enum RestaurantDashboardStates {
  loading,
  filterLoading,
  initState,
  error,
  success,
  requestSuccess,
  requestLoading
}

extension RestaurantDashboardStateX on RestaurantDashboardState {
  bool get isInitial => status == RestaurantDashboardStates.initState;

  bool get isLoading => status == RestaurantDashboardStates.loading;

  bool get isFilterLoading => status == RestaurantDashboardStates.filterLoading;

  bool get isError => status == RestaurantDashboardStates.error;

  bool get isSuccess => status == RestaurantDashboardStates.success;

  bool get isRequestSuccess =>
      status == RestaurantDashboardStates.requestSuccess;

  bool get isRequestLoading =>
      status == RestaurantDashboardStates.requestLoading;
}

@immutable
class RestaurantDashboardState {
  final RestaurantDashboardStates status;
  final Failure? failure;
  final String? successMessage;
  final String? subCategoryId;
  final Restaurant2Model? info;
  final RestaurantStatistics? statistics;
  final IsRestaurantModel? isRestaurant;
  final bool connected;
  final GetFoodRequestEntity? orders;
  final GetFoodRequestEntity? availableOrders;
  final GetFoodRequestEntity? pastOrders;
  final List<SubCategoryEntity>? subCategories;
  final List<GovernorateEntity>? governorates;
  final List<CityEntity>? cities;
  final String? uploadImageError;
  final List<XFile>? files;
  final bool? isRestaurantPhoto;
  final bool? isName;
  final CompleteOrderEntity? completeOrderEntity;

  const RestaurantDashboardState({
    this.status = RestaurantDashboardStates.loading,
    this.failure,
    this.info,
    this.isRestaurant,
    this.statistics,
    this.subCategoryId,
    this.connected = true,
    this.successMessage,
    this.subCategories,
    this.governorates,
    this.orders,
    this.cities,
    this.uploadImageError,
    this.files,
    this.isRestaurantPhoto,
    this.isName,
    this.availableOrders,
    this.pastOrders,
    this.completeOrderEntity,

  });

  RestaurantDashboardState copyWith({
    RestaurantDashboardStates? status,
    Failure? failure,
    List<SubCategoryEntity>? subCategories,
    IsRestaurantModel? isRestaurant,
    GetFoodRequestEntity? orders,
    GetFoodRequestEntity? availableOrders,
    GetFoodRequestEntity? pastOrders,
    Restaurant2Model? info,
    RestaurantStatistics? statistics,
    bool? connected,
    String? subCategoryId,
    String? successMessage,
    List<GovernorateEntity>? governorates,
    List<CityEntity>? cities,
    String? uploadImageError,
    List<XFile>? files,
    bool? isRestaurantPhoto,
    bool? isName,
    CompleteOrderEntity? completeOrderEntity,
  }) {
    return RestaurantDashboardState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      connected: connected ?? this.connected,
      statistics: statistics ?? this.statistics,
      info: info ?? this.info,
      subCategoryId: subCategoryId ?? this.subCategoryId,
      isRestaurant: isRestaurant ?? this.isRestaurant,
      successMessage: successMessage ?? this.successMessage,
      orders: orders ?? this.orders,
      subCategories: subCategories ?? this.subCategories,
      governorates: governorates ?? this.governorates,
      cities: cities ?? this.cities,
      uploadImageError: uploadImageError ?? this.uploadImageError,
      files: files ?? this.files,
      isRestaurantPhoto: isRestaurantPhoto ?? this.isRestaurantPhoto,
      isName: isName ?? this.isName,
      availableOrders: availableOrders ?? this.availableOrders,
      pastOrders: pastOrders ?? this.pastOrders,
      completeOrderEntity: completeOrderEntity ?? this.completeOrderEntity,

    );
  }
}
