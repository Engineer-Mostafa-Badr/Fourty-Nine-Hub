part of 'emergency_cubit.dart';

sealed class HealthEmergencyState {}

final class HealthEmergencyInitial extends HealthEmergencyState {}

final class HealthEmergencyLoading extends HealthEmergencyState {}

final class HealthEmergencySuccess extends HealthEmergencyState {}

final class HealthEmergencySubCategoriesLoaded extends HealthEmergencyState {
  final List<SubCategoryEntity> subCategories;
  HealthEmergencySubCategoriesLoaded({required this.subCategories});
}

final class HealthEmergencyError extends HealthEmergencyState {
  final String message;
  HealthEmergencyError({required this.message});
}
