
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/features/RideFeature/domain/usecases/get_shipping_categories_usecase.dart';
import 'package:fourtyninehub/features/RideFeature/presentation/controllers/cubits/ride_states.dart';

import '../../../../../core/error/failure.dart';
import '../../../domain/entities/ride_category_entity.dart';
import '../../../domain/usecases/get_ride_categories_usecase.dart';



class RideCubit extends Cubit<RideState> {
  final GetRideCategoriesUseCase getRideCategories;
  final GetShippingCategoriesUsecase getShippingCategoriesUsecase;

  RideCubit(
        this.getRideCategories,
        this.getShippingCategoriesUsecase,
      ) : super(const RideState()) {}

  Future<void> fetchRideCategories(String userId) async {
    if (isClosed) return;  // Prevents state emission if the cubit is already disposed.
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, RideCategoryEntityUpdated> result = await getRideCategories(userId);

    if (isClosed) return;  // Double-check before emitting a state
    result.fold(
          (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
          (rideCategory) => emit(state.copyWith(status: RideStates.success, rideCategory: rideCategory)),
    );
  }


  Future<void> fetchShippingCategories(String userId) async {
    emit(state.copyWith(status: RideStates.loading));

    final Either<Failure, RideCategoryEntityUpdated> result = await getShippingCategoriesUsecase(userId);

    result.fold(
          (failure) => emit(state.copyWith(status: RideStates.error, failure: failure)),
          (rideCategory) => emit(state.copyWith(status: RideStates.success, shippingCategory: rideCategory)),
    );
  }
}
