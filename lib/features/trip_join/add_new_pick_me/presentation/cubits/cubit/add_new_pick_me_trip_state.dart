part of 'add_new_pick_me_trip_cubit.dart';

sealed class AddNewPickMeTripState {
  const AddNewPickMeTripState();
}

final class AddNewPickMeTripInitial extends AddNewPickMeTripState {}

final class AddNewPickMeTripLoading extends AddNewPickMeTripState {}

final class AddNewPickMeTripFailure extends AddNewPickMeTripState {
  final String errorMessage;

  AddNewPickMeTripFailure({required this.errorMessage});
}

final class AddNewPickMeTripSuccess extends AddNewPickMeTripState {
  final AddNewPickMeModel addNewPickMeModel;

  AddNewPickMeTripSuccess({required this.addNewPickMeModel});
}
