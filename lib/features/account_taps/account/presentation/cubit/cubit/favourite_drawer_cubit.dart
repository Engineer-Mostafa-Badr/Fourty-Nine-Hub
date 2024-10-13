import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import '../../../domain/usecases/get_drawer_favourite_ads_usecase.dart';
import 'favourite_drawer_state.dart';

class FavouriteDrawerCubit extends Cubit<FavouriteDrawerState> {
  final GetDrawerFavouriteAdsUsecase _favouriteAdsUsecase;
  FavouriteDrawerCubit(
      this._favouriteAdsUsecase)
      : super(const FavouriteDrawerState());



  Future<void> fetchFavourite() async {
    emit(state.copyWith(status: FavouriteDrawerStates.loading));
    final response = await _favouriteAdsUsecase(const NoParams());
    response.fold((l) {
      emit(state.copyWith(failure: l, status: FavouriteDrawerStates.error));
    }, (data) {
      emit(state.copyWith(favourite: data,status: FavouriteDrawerStates.success));
    });
  }
}
