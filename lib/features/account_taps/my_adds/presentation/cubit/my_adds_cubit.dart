import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';

import '../../../../../core/error/failure.dart';
import '../../../../ads_feature/ads/domain/entities/ad_entity.dart';
import '../../../../requests_history/domain/entities/trip_entity.dart';
import '../../../../ride/trip_details/domain/entities/trip_and_request_entity.dart';
import '../../domain/usecases/delete_come_with_me_usecase.dart';
import '../../domain/usecases/delete_pick_me_usecase.dart';
import '../../domain/usecases/get_my_ads_usecase.dart';
import '../../domain/usecases/get_my_come_with_you_usecase.dart';
import '../../domain/usecases/get_my_pick_me_usecase.dart';

part 'my_adds_state.dart';

class MyAddsCubit extends Cubit<MyAddsState> {
  final GetMyAdsUseCase _getMyAdsUseCase;
  final GetMyPickMeAdsUseCase _getMyPickMeAdsUseCase;
  final GetMyComeWithMeUseCase _getMyComeWithMeUseCase;
  final DeletePickMeUseCase _deletePickMeUseCase;
  final DeleteComeWithMeUseCase _deleteComeWithMeUseCase;
  MyAddsCubit(
    this._getMyAdsUseCase,
    this._deleteComeWithMeUseCase,
    this._deletePickMeUseCase,
    this._getMyComeWithMeUseCase,
    this._getMyPickMeAdsUseCase,
  ) : super(const MyAddsState());

  void loadData() async {
    await getMyAds();
    await getPickMeTrips();
    await getComeWithMeTrips();
  }

  Future<void> getMyAds() async {
    final response = await _getMyAdsUseCase.call(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) => emit(state.copyWith(myAds: r, status: MyAddsStates.initState)));
  }

  Future<void> getPickMeTrips() async {
    final response = await _getMyPickMeAdsUseCase(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) => emit(
            state.copyWith(pickMeTrips: r, status: MyAddsStates.initState)));
  }

  Future<void> getComeWithMeTrips() async {
    final response = await _getMyComeWithMeUseCase(const NoParams());
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: MyAddsStates.error)),
        (r) => emit(state.copyWith(
            comeWithMeTrips: r, status: MyAddsStates.initState)));
  }
}
