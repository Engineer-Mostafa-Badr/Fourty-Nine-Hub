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
  final List<SubCategoryModel>? subCategories;
  final SubCategoryModel? subCategory;
  final List<CarTypeModel>? carTypes;
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
    this.carType,
    this.status = DriverRegisterStatuses.initState,
  });
  DriverRegisterState copyWith(
      {List<SubCategoryModel>? subCategories,
      SubCategoryModel? subCategory,
      List<CarTypeModel>? carTypes,
      CarTypeModel? carType,
      DriverRegisterStatuses? status,
      Failure? failure,
      RiderInfoModel? riderInfo}) {
    return DriverRegisterState(
        subCategories: subCategories ?? this.subCategories,
        subCategory: subCategory ?? this.subCategory,
        carTypes: carTypes ?? this.carTypes,
        carType: carType ?? this.carType,
        status: status ?? this.status,
        failure: failure ?? this.failure,
        riderInfo: riderInfo ?? this.riderInfo);
  }
}
