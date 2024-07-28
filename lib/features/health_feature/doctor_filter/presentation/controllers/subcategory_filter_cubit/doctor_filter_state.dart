part of 'doctor_filter_cubit.dart';

sealed class DoctorSubcategoryFilterState {}

final class DoctorSubcategoryFilterInitial
    extends DoctorSubcategoryFilterState {}

final class DoctorSubcategoryFilterLoading
    extends DoctorSubcategoryFilterState {}

final class DoctorSubcategoryFilterLoaded extends DoctorSubcategoryFilterState {
  final List<SubCategoryEntity> subCategories;
  DoctorSubcategoryFilterLoaded({required this.subCategories});
}

class Entity {
}

final class DoctorSubcategoryFilterError extends DoctorSubcategoryFilterState {
  final String message;
  DoctorSubcategoryFilterError({required this.message});
}
