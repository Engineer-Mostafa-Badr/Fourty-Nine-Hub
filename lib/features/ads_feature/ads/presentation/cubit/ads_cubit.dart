import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../../../../core/error/failure.dart';
import '../../data/models/Ad_model.dart';
import '../../domain/usecases/get_ads_usecase.dart';

part 'ads_state.dart';

class AdsCubit extends Cubit<AdsState> {
  final GetAdsUseCase _getAdsUseCase;
  AdsCubit(this._getAdsUseCase) : super(const AdsState());

  void loadData() async {
    await getAds();
  }

  Future<void> getAds() async {
    final response = await _getAdsUseCase.call(0);
    response.fold(
        (failure) =>
            emit(state.copyWith(failure: failure, status: AdsStates.error)),
        (data) => emit(state.copyWith(ads: data, status: AdsStates.initState)));
  }
}
