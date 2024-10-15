import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/features/account_taps/account/domain/usecases/delete_favourite_ads_usecase.dart';
import '../../../domain/usecases/get_drawer_favourite_ads_usecase.dart';
import 'favourite_drawer_state.dart';

class FavouriteDrawerCubit extends Cubit<FavouriteDrawerState> {
  final GetDrawerFavouriteAdsUsecase _favouriteAdsUsecase;
  final DeleteFavouriteAdsUsecase _deleteFavouriteAdsUsecase;
  FavouriteDrawerCubit(
      this._favouriteAdsUsecase, this._deleteFavouriteAdsUsecase)
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

  Future<void> deleteFavouriteAds({required String id}) async {
    emit(state.copyWith(status: FavouriteDrawerStates.loading));
    final response = await _deleteFavouriteAdsUsecase(id);
    response.fold((l) {
      emit(state.copyWith(failure: l, status: FavouriteDrawerStates.error));
    }, (data) {
      emit(state.copyWith(status: FavouriteDrawerStates.successDelete));
      fetchFavourite();
    });
  }
}
