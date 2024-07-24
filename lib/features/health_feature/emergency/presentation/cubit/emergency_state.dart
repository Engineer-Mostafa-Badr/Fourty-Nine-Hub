part of 'emergency_cubit.dart';

sealed class EmergencyState {}

final class EmergencyInitial extends EmergencyState {}

final class EmergencyLoading extends EmergencyState {}

final class EmergencyLoaded extends EmergencyState {
  final List<SubCategoryEntity> subCategories;
  EmergencyLoaded({required this.subCategories});
}

final class EmergencyError extends EmergencyState {
  final String message;
  EmergencyError({required this.message});
}
