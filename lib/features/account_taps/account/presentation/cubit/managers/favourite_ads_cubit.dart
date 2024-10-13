import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/enums/base_status_enum.dart';
import 'package:fourtyninehub/core/states/basic_state.dart';

import 'package:fourtyninehub/features/account_taps/account/domain/usecases/get_favourite_ads_usecase.dart';

import '../../../domain/entities/favourite_ad_entity.dart';

class
FavouriteAdsCubit extends Cubit<BasicState<List<FavouriteAdEntity>>> {
  final GetFavouriteAdsUsecase _getFavouriteAdsUsecase;

  FavouriteAdsCubit(this._getFavouriteAdsUsecase)
      : super(
          const BasicState(),
        );

  void loadData() async {
    emit(state.copyWith(status: StateStatus.loading));
    final result = await _getFavouriteAdsUsecase.call(const NoParams());
    emit(
      result.fold(
        (failure) => state.copyWith(
          failure: failure,
          status: StateStatus.error,
        ),
        (data) => state.copyWith(
          status: StateStatus.success,
          data: data,
        ),
      ),
    );
  }
}
