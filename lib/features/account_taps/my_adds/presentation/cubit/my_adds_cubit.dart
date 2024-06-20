import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';

import '../../../../../core/error/failure.dart';
import '../../../../ads_feature/ads/domain/entities/ad_entity.dart';
import '../../domain/usecases/get_my_ads_usecase.dart';

part 'my_adds_state.dart';

class MyAddsCubit extends Cubit<MyAddsState> {
  final GetMyAdsUseCase _getMyAdsUseCase;
  MyAddsCubit(this._getMyAdsUseCase) : super(const MyAddsState());

  void loadData() async {
    await getMyAds();
  }

  Future<void> getMyAds() async {
    final response = await _getMyAdsUseCase.call(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) => emit(state.copyWith(myAds: r, status: MyAddsStates.initState)));
  }
}
