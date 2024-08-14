part of 'driver_register_cubit.dart';

enum DriverRegisterStatuses {
  initState,
  loading,
  error,
}

extension DriverRegisterStateX on DriverRegisterState {
  bool get isInitial => status == DriverRegisterStatuses.initState;
  bool get loading => status == DriverRegisterStatuses.loading;
  bool get error => status == DriverRegisterStatuses.error;
}

@immutable
class DriverRegisterState {
  final List<SubCategoryEntity>? subCategories;
  final SubCategoryEntity? subCategory;
  final List<CarTypeModel>? carTypes;
  final List<RideServicesEnum>? selectedOptions;
  final CarTypeModel? carType;
  final RiderInfoModel? riderInfo;
  final DriverRegisterStatuses status;
  final Failure? failure;

  const DriverRegisterState({
    this.failure,
    this.riderInfo,
    this.subCategories,
    this.carTypes,
    this.subCategory,
    this.selectedOptions,
    this.carType,
    this.status = DriverRegisterStatuses.initState,
  });
  DriverRegisterState copyWith(
      {List<SubCategoryEntity>? subCategories,
      SubCategoryEntity? subCategory,
      List<CarTypeModel>? carTypes,
      CarTypeModel? carType,
      DriverRegisterStatuses? status,
      Failure? failure,
      List<RideServicesEnum>? selectedOptions,
      RiderInfoModel? riderInfo}) {
    return DriverRegisterState(
        subCategories: subCategories ?? this.subCategories,
        subCategory: subCategory ?? this.subCategory,
        carTypes: carTypes ?? this.carTypes,
        carType: carType ?? this.carType,
        status: status ?? this.status,
        failure: failure ?? this.failure,
        selectedOptions: selectedOptions ?? this.selectedOptions,
        riderInfo: riderInfo ?? this.riderInfo);
  }
}
